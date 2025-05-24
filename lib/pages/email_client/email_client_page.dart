import 'package:campus_app/pages/email_client/email_drawer.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/compose_email_screen.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:flutter/material.dart';

class EmailClientScreen extends StatefulWidget {
  const EmailClientScreen({super.key});

  @override
  State<EmailClientScreen> createState() => _EmailClientScreenState();
}

class _EmailClientScreenState extends State<EmailClientScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Email> _allEmails = List.generate(10, (i) => Email.dummy(i));
  late List<Email> _filteredEmails;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late EmailSelectionController _selectionController;

  @override
  void initState() {
    super.initState();
    _filteredEmails = _allEmails.where((e) => e.folder == EmailFolder.inbox).toList();
    _selectionController = EmailSelectionController(
      onDelete: _deleteSelected,
      onArchive: _archiveSelected,
      onEmailUpdated: _updateEmail,
    )..addListener(_onSelectionChanged);
  }

  void _onSelectionChanged() {
    setState(() {}); // Rebuild when selection changes
  }

  @override
  void dispose() {
    _selectionController.removeListener(_onSelectionChanged);
    _selectionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _updateEmail(Email updatedEmail) {
    setState(() {
      final index = _allEmails.indexWhere((e) => e.id == updatedEmail.id);
      if (index != -1) {
        _allEmails[index] = updatedEmail;
        _filterEmails(_searchController.text);
      }
    });
  }

  Future<void> _deleteSelected(Set<Email> emails) async {
    setState(() {
      for (final email in emails) {
        final index = _allEmails.indexWhere((e) => e.id == email.id);
        if (index != -1) {
          _allEmails[index] = email.copyWith(folder: EmailFolder.trash);
        }
      }
      _selectionController.clearSelection();
      _filterEmails(_searchController.text);
    });
  }

  Future<void> _archiveSelected(Set<Email> emails) async {
    setState(() {
      for (final email in emails) {
        final index = _allEmails.indexWhere((e) => e.id == email.id);
        if (index != -1) {
          _allEmails[index] = email.copyWith(folder: EmailFolder.archives);
        }
      }
      _selectionController.clearSelection();
      _filterEmails(_searchController.text);
    });
  }

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

  void _moveToTrash(Email email) {
    setState(() {
      final index = _allEmails.indexWhere((e) => e.id == email.id);
      if (index != -1) {
        _allEmails[index] = email.copyWith(folder: EmailFolder.trash);
        _filterEmails(_searchController.text);
      }
    });
  }

  Future<void> _handlePop(BuildContext context) async {
    if (_selectionController.isSelecting) {
      _selectionController.clearSelection();
      return;
    }
    if (_isSearching) {
      setState(() {
        _isSearching = false;
        _searchController.clear();
        _filterEmails('');
      });
      return;
    }
    if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (!didPop) await _handlePop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search emails...',
                    border: InputBorder.none,
                  ),
                  onChanged: _filterEmails,
                )
              : const Text('RubMail'),
          leading: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                      _filterEmails('');
                    });
                  },
                )
              : null,
          actions: [
            if (!_isSearching && !_selectionController.isSelecting)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => setState(() => _isSearching = true),
              ),
            if (_selectionController.isSelecting) ...[
              IconButton(
                icon: const Icon(Icons.select_all),
                onPressed: () => _selectionController.selectAll(_filteredEmails),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _selectionController.clearSelection,
              ),
            ],
            if (!_isSearching && !_selectionController.isSelecting)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
          ],
        ),
        endDrawer: EmailDrawer(allEmails: _allEmails),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _selectionController.isSelecting ? _selectionController.clearSelection : null,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              _filterEmails(_searchController.text);
            },
            child: ListView.separated(
              itemCount: _filteredEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final email = _filteredEmails[index];
                return InkWell(
                  onLongPress: () {
                    setState(() {
                      _selectionController.toggleSelection(email);
                    });
                  },
                  child: EmailTile(
                    email: email,
                    isSelected: _selectionController.isSelected(email),
                    onTap: () {
                      //if selecting tapping toggles selection
                      if (_selectionController.isSelecting) {
                        setState(() {
                          _selectionController.toggleSelection(email);
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmailView(
                              email: email,
                              onDelete: _moveToTrash,
                            ),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      //bulk selection
                      setState(() {
                        _selectionController.toggleSelection(email);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: _selectionController.isSelecting
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    heroTag: 'delete',
                    onPressed: () => _selectionController.onDelete?.call(_selectionController.selectedEmails),
                    child: const Icon(Icons.delete),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'archive',
                    onPressed: () => _selectionController.onArchive?.call(_selectionController.selectedEmails),
                    child: const Icon(Icons.archive),
                  ),
                ],
              )
            : FloatingActionButton(
                //button to compose emails
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

// TODO: extract _filterEmails as a separate component(maybe?)

// Check: 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Check: ticket_datasource
// Use Login, make it go to Email
// Check IMAP plugins (for dart/flutter): enough_mail?s
