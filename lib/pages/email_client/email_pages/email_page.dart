import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/utils/widgets/login_screen.dart';
import 'package:campus_app/pages/email_client/email_pages/email_drawer.dart';
import 'package:campus_app/pages/email_client/email_pages/email_view.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

// Main entry widget for the email client screen
class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EmailClientContent();
  }
}

// Internal stateful widget that handles authentication, email loading, and UI behavior
class _EmailClientContent extends StatefulWidget {
  const _EmailClientContent();

  @override
  State<_EmailClientContent> createState() => _EmailClientContentState();
}

class _EmailClientContentState extends State<_EmailClientContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();

  bool _isSearching = false; // True when search bar is active
  bool _isLoading = true; // True while authenticating or initializing
  bool _isAuthenticated = false; // True after successful login
  late EmailSelectionController _selectionController; // Handles multi-select actions

  @override
  void initState() {
    super.initState();
    _initializeEmailClient(); // Start setup on load
  }

  // Initialize email services and authentication
  Future<void> _initializeEmailClient() async {
    final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
    final emailService = Provider.of<EmailService>(context, listen: false);

    // Set up selection controller with callbacks
    _selectionController = EmailSelectionController(
      onDelete: (emails) async {
        emailService.moveEmailsToFolder(emails, EmailFolder.trash); // Move to Trash
        _search(); // Refresh view
      },
      onArchive: (emails) async {
        emailService.moveEmailsToFolder(emails, EmailFolder.archives); // Move to Archives
        _search();
      },
      onEmailUpdated: (email) async {
        emailService.updateEmail(email); // Update state if email is modified
        _search();
      },
    )..addListener(_onSelectionChanged); // Listen for selection state changes

    // Check stored credentials and try to authenticate
    final isAuthenticated = await emailAuthService.isAuthenticated();

    if (isAuthenticated) {
      // If valid, initialize mailbox
      await emailService.initialize();
      setState(() {
        _isAuthenticated = true;
        _isLoading = false;
      });
    } else {
      // Show login screen if not authenticated
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Rebuild UI when selection changes
  void _onSelectionChanged() => setState(() {});

  // Rebuilds UI when a search is performed
  void _search() {
    setState(() {});
  }

  // Triggers the login screen and handles post-login setup
  Future<void> _handleLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(
          loginType: LoginType.email,
          customTitle: 'RubMail Login',
          customDescription: 'Melde dich mit deinen RUB-Daten an, um auf deine E-Mails zuzugreifen.',
          onLogin: (username, password) async {
            final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
            await emailAuthService.authenticate(username, password);
          },
          onLoginSuccess: () async {
            final emailService = Provider.of<EmailService>(context, listen: false);
            await emailService.initialize();
            setState(() {
              _isAuthenticated = true;
            });
          },
        ),
      ),
    );
  }

/*
  Future<void> _handleLogout() async {
    final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
    final emailService = Provider.of<EmailService>(context, listen: false);

    await emailAuthService.logout();
    emailService.clear();

    setState(() {
      _isAuthenticated = false;
    });
  } 
  */

  // Handles back/gesture navigation, exits selection/search/drawer as needed
  Future<void> _handlePop(BuildContext context) async {
    if (_selectionController.isSelecting) {
      _selectionController.clearSelection();
      return;
    }
    if (_isSearching) {
      setState(() {
        _isSearching = false;
        _searchController.clear();
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
  void dispose() {
    _selectionController.removeListener(_onSelectionChanged);
    _selectionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while initializing
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show login prompt if not authenticated
    if (!_isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('RubMail'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Willkommen bei RubMail',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Melde dich an, um auf deine E-Mails zuzugreifen',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleLogin,
                child: const Text('Anmelden'),
              ),
            ],
          ),
        ),
      );
    }

    final emailService = Provider.of<EmailService>(context);
    final filteredEmails = emailService.filterEmails(_searchController.text, EmailFolder.inbox); // Apply search filter

    return PopScope(
      onPopInvoked: (didPop) async {
        if (!didPop) await _handlePop(context); // Custom pop behavior
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'E-Mails durchsuchen...',
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => _search(), // Update search results
                )
              : const Text('RubMail'),
          leading: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
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
                onPressed: () => _selectionController.selectAll(filteredEmails),
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
        endDrawer: const EmailDrawer(), // Folder navigation drawer
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _selectionController.isSelecting ? _selectionController.clearSelection : null,
          child: RefreshIndicator(
            onRefresh: () async {
              final emailService = Provider.of<EmailService>(context, listen: false);
              await emailService.refreshEmails(); // Pull-to-refresh
              _search(); // Re-apply search
            },
            child: ListView.separated(
              itemCount: filteredEmails.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
              itemBuilder: (_, index) {
                final email = filteredEmails[index];
                return EmailTile(
                  email: email,
                  isSelected: _selectionController.isSelected(email),
                  onTap: () {
                    if (_selectionController.isSelecting) {
                      setState(() => _selectionController.toggleSelection(email));
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailView(
                            email: email,
                            onDelete: (email) {
                              emailService.moveEmailsToFolder([email], EmailFolder.trash);
                              _search();
                            },
                          ),
                        ),
                      );
                    }
                  },
                  onLongPress: () {
                    setState(() => _selectionController.toggleSelection(email));
                  },
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
                    child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'archive',
                    onPressed: () => _selectionController.onArchive?.call(_selectionController.selectedEmails),
                    child: Icon(Icons.archive, color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              )
            : FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ComposeEmailScreen()),
                ),
                child: Icon(Icons.edit, color: Theme.of(context).colorScheme.onPrimary),
              ),
      ),
    );
  }
}

/*
NOTES:
- some changes on the email client only appear on the app not in the actual Email. Like delete.
- Email inbox only loads a certain number of emails, loading takes a long time needs optimization.
- Drawer top needs to be fixed (name/Email display)
- Some Email bodies are not shown.
- sending emails and replying works. drafts also work.
- selection needs to be added to the drawer pages as well. the selection component is already implemented but
  the use of options different than the inbox is needed.
- Setting need to be implemented
- Attachments need implementing as well. Some UI components for that are already implemented but these are only UI
  as for the email view with attachments it needs to be further tested.
- Searching is implemented for the inbox but it should also be implemented for the drawer pages
*/
