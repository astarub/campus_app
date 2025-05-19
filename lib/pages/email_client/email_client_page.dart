import 'package:campus_app/pages/email_client/email_drawer.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/compose_email_screen.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/search_bar.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:flutter/material.dart';

class EmailClientScreen extends StatefulWidget {
  const EmailClientScreen({super.key});

  @override
  State<EmailClientScreen> createState() => _EmailClientScreenState();
}

class _EmailClientScreenState extends State<EmailClientScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Placeholder emails to work with untill backend is implemented
  final List<Email> _allEmails = List.generate(10, (i) => Email.dummy(i));
  late List<Email> _filteredEmails;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // When initialized show emails that are in the inbox only.
  @override
  void initState() {
    super.initState();
    _filteredEmails = _allEmails.where((e) => e.folder == EmailFolder.inbox).toList();
  }

  // logic for filtering Emails. If the query is Empty all inbox emails are shown.
  // Otherwise the emails are filtered whilst handling case sensitivity and field matching logic
  void _filterEmails(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmails = _allEmails.where((e) => e.folder == EmailFolder.inbox).toList();
      } else {
        _filteredEmails = _allEmails
            .where((email) =>
                email.folder == EmailFolder.inbox &&
                (email.sender.toLowerCase().contains(query.toLowerCase()) ||
                    email.subject.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  //When an email is deleted it is moved to the Trash list and removed from inbox.
  void _moveToTrash(Email email) {
    setState(() {
      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: EmailFolder.trash);
        _filterEmails(_searchController.text); // Refresh filtered list
      }
    });
  }

  // with this I am trying to make it so that the back press closes things in the right order,
  // however there are some issues with the order still.
  // This will close the drawer if it's open while searching before closing the search:
  Future<void> _handlePop(BuildContext context) async {
    final isDrawerOpen = _scaffoldKey.currentState?.isEndDrawerOpen ?? false;
    if (isDrawerOpen) {
      Navigator.of(context).maybePop();
    } else if (_isSearching) {
      setState(() {
        _isSearching = false;
        _searchController.clear();
        _filterEmails('');
      });
    } else {
      Navigator.of(context).maybePop(); // Normal pop
    }
  }

  // onPopInvoked is depricated in the new flutter version.
  // TODO: fix pop order.
  // TODO: find another function to replace onPopInvoked.
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _handlePop(context);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,

        //Here we use the functionality implemented in '.../email_client/widgets/search_bar.dart'
        //This code is UI layer it handles user interactionslike button press and text input.
        //The logic behind the filtering is _filterEmails (see above)
        appBar: SearchAppBar(
          isSearching: _isSearching,
          onStartSearch: () => setState(() => _isSearching = true),
          onStopSearch: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
              _filterEmails('');
            });
          },
          onSearchChanged: _filterEmails,
          searchController: _searchController,
        ),

        // endDrawer add the drawer button on the right
        endDrawer: EmailDrawer(allEmails: _allEmails),

        body: RefreshIndicator(
          //Waits 1 second then re_runs _filterEmails
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            _filterEmails(_searchController.text);
          },
          // Scrollable email list
          child: ListView.separated(
            itemCount: _filteredEmails.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) => EmailTile(
              email: _filteredEmails[index],
              // Tapping opens the Email view and provides a delete functionality from there
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmailView(
                    email: _filteredEmails[index],
                    onDelete: _moveToTrash,
                  ),
                ),
              ),
            ),
          ),
        ),

        //This button is for composing a new email
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ComposeEmailScreen()),
          ),
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}

// Trash is fully implemented so far.
// TODO: Sent, Archives, Drafts
// TODO: Settings, so far I am unsure what to add in here.

// TODO: add selection functionality, preferably as an independent file to be used anywhere.

// TODO: Upload on a git branch.

// TODO: extract _filterEmails as a separate component(maybe?)
