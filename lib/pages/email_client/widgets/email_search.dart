import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/pages/email_client/email_pages/email_view.dart';
import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/widgets/dynamic_search_text.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class EmailSearch extends StatefulWidget {
  final UserEmailFolder folder;

  const EmailSearch({
    super.key,
    required this.folder,
  });

  @override
  State<EmailSearch> createState() => _EmailSearchState();
}

class _EmailSearchState extends State<EmailSearch> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Email> _searchResults = [];
  bool _isSearchLoading = false;
  bool _hasMoreSearchResults = false;
  bool _cancelSearch = false;
  bool _hasSearched = false;
  bool _isBGIndexing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // detect if the user has scrolled close enough to the bottom to dynamically load the next batch of emails matching the search
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreSearchResults();
    }
  }

  // load the next batch of emails and add them to the already loaded emails
  Future<void> _loadMoreSearchResults() async {
    if (!_hasMoreSearchResults || _isSearchLoading) return;

    setState(() => _isSearchLoading = true);

    try {
      final emailService = Provider.of<EmailService>(context, listen: false);
      final moreEmails = await emailService.loadMoreSearchResults(folder: widget.folder);
      if (mounted) {
        setState(() {
          _searchResults = [..._searchResults, ...moreEmails];
          _hasMoreSearchResults = emailService.hasMoreSearchResults;
          _isSearchLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSearchLoading = false);
    }
  }

  // search for emails matching input, not filter loaded emails
  Future<void> _search() async {
    final input = _searchController.text.trim();

    if (input.isEmpty) return;

    final emailService = Provider.of<EmailService>(context, listen: false);

    // if we are in the inbox, we could be indexing it, therefore check if it is and wait until it's done
    if (emailService.isIndexing && widget.folder == UserEmailFolder.inbox) {
      setState(() {
        _isBGIndexing = true;
        _hasSearched = true;
      });

      while (emailService.isIndexing) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      setState(() {
        _isBGIndexing = false;
      });
    }
    _cancelSearch = true;
    await Future.delayed(Duration.zero);
    _cancelSearch = false;

    setState(() {
      _isSearchLoading = true;
      _hasSearched = true;
      _searchResults = [];
    });

    try {
      if (!mounted) return;
      final emailService = Provider.of<EmailService>(context, listen: false);
      final results = await emailService.searchEmails(
        query: input,
        folder: widget.folder,
      );

      if (_cancelSearch) {
        debugPrint('Email Search: Canceled previous Search.');
        return;
      }
      if (mounted) {
        setState(() {
          _searchResults = results.reversed.toList();
          _isSearchLoading = false;
          _hasMoreSearchResults = emailService.hasMoreSearchResults;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSearchLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _search(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isBGIndexing) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            DynamicSearchText(
              messages: ['Mailbox wird indiziert...', 'Bitte einen Moment warten...'],
            )
          ],
        ),
      );
    }

    if (_isSearchLoading && _searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            DynamicSearchText(),
          ],
        ),
      );
    }

    if (_hasSearched && _searchResults.isEmpty && !_isSearchLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 50),
            SizedBox(height: 16),
            Text(
              'Keine Emails gefunden...',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      return const Center(
        child: Text('Gebe einen Suchterm ein.'),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      itemCount: _searchResults.length + (_hasMoreSearchResults ? 1 : 0),
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 45,
        endIndent: 10,
        color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
      ),
      itemBuilder: (_, index) {
        if (index == _searchResults.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          );
        }
        final email = _searchResults[index];
        final emailService = Provider.of<EmailService>(context, listen: false);
        return EmailTile(
          email: email,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EmailView(
                  email: email,
                  folder: widget.folder,
                  onDelete: (email, mailboxName) {
                    emailService.moveEmailsToFolder([email], UserEmailFolder.trash);
                    setState(() => _searchResults.remove(email));
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
