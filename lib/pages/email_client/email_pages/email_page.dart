import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

import 'package:campus_app/core/injection.dart';
import 'package:campus_app/pages/email_client/models/user_email_folder.dart';
import 'package:campus_app/pages/email_client/widgets/email_search.dart';
import 'package:campus_app/pages/email_client/email_pages/email_login_screen.dart';
import 'package:campus_app/pages/email_client/email_pages/email_drawer.dart';
import 'package:campus_app/pages/email_client/email_pages/email_view.dart';
import 'package:campus_app/pages/email_client/email_pages/compose_email_screen.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/models/email.dart';
import 'package:campus_app/core/themes.dart';

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
  final ScrollController _scrollController = ScrollController();

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
        await emailService.moveEmailsToFolder(emails.toList(), UserEmailFolder.trash); // Move to Trash
        _rebuild(); // Refresh view
      },
      onEmailUpdated: (email) async {
        emailService.updateEmail(email); // Update state if email is modified
        _rebuild();
      },
    )..addListener(_onSelectionChanged); // Listen for selection state changes

    try {
      final isAuthenticated = await emailAuthService.isAuthenticated();

      if (isAuthenticated) {
        await emailService.initialize();
        if (mounted) {
          setState(() {
            _isAuthenticated = true;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Email init error: $e');
      // any failure -> return to login screen
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    }
  }

  // Rebuild UI when selection changes
  void _onSelectionChanged() => setState(() {});

  // Rebuild the UI
  void _rebuild() {
    setState(() {});
  }

  // Triggers the login screen and handles post-login setup
  Future<void> _handleLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmailLoginScreen(
          onLogin: (username, password, emailAddress, emailDisplayName) async {
            final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
            await emailAuthService.authenticate(username, password, emailAddress, emailDisplayName);
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

  // Handles back/gesture navigation, exits selection/search/drawer as needed
  Future<void> _handlePop(BuildContext context) async {
    if (_selectionController.isSelecting) {
      _selectionController.clearSelection();
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while initializing
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.colorScheme.surface,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: MediaQuery.heightOf(context) * 0.075,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 30,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Provider.of<ThemesNotifier>(context).currentThemeData.cardColor,
                  color: Provider.of<ThemesNotifier>(context).currentThemeData.primaryColor,
                  strokeWidth: 3,
                ),
              ),
            ),
          ],
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
    final List<Email> filteredEmails = emailService.filterEmails('', UserEmailFolder.inbox);

    return PopScope(
      onPopInvoked: (didPop) async {
        if (!didPop) await _handlePop(context); // Custom pop behavior
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('RubMail'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const EmailSearch(folder: UserEmailFolder.inbox),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              ),
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
            if (!_selectionController.isSelecting)
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
              _rebuild(); // Re-apply search
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
                  onTap: () async {
                    if (_selectionController.isSelecting) {
                      setState(() => _selectionController.toggleSelection(email));
                    } else {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmailView(
                            email: email,
                            onDelete: (email, mailboxName) {
                              emailService.moveEmailsToFolder([email], UserEmailFolder.trash);

                              _rebuild();
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
- some changes on the email client only appear on the app not in the actual Email. Like delete. (N.D. Dev Note -> this has been fixed, applied to both Move and Delete)
- Email inbox only loads a certain number of emails, loading takes a long time needs optimization. (N.D. Dev Note -> Optimized)
- Drawer top needs to be fixed (name/Email display) 
- Some Email bodies are not shown. (N.D. Dev Note -> fixed html bodies)
- sending emails and replying works. drafts also work. (N.D. Dev Note -> wasn't really working, sent emails had no body, replying has skewed format and drafts didn't work right. drafts and Sending is fixed)
- selection needs to be added to the drawer pages as well. the selection component is already implemented but
  the use of options different than the inbox is needed.
- Setting need to be implemented
- Attachments need implementing as well. Some UI components for that are already implemented but these are only UI
  as for the email view with attachments it needs to be further tested.
- Searching is implemented for the inbox but it should also be implemented for the drawer pages (N.D. Dev Note -> searching was only local with the emails already loaded in,
  we now search server side and load all relevant emails)
*/
