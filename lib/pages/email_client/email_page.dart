import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:campus_app/core/injection.dart';
import 'package:campus_app/utils/widgets/login_screen.dart';
import 'package:campus_app/pages/email_client/email_drawer.dart';
import 'package:campus_app/pages/email_client/email_view.dart';
import 'package:campus_app/pages/email_client/compose_email_screen.dart';
import 'package:campus_app/pages/email_client/services/email_service.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:campus_app/pages/email_client/widgets/email_tile.dart';
import 'package:campus_app/pages/email_client/widgets/select_email.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class EmailPage extends StatelessWidget {
  const EmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmailService()),
        ChangeNotifierProvider(create: (_) => EmailAuthService()),
      ],
      child: const _EmailClientContent(),
    );
  }
}

class _EmailClientContent extends StatefulWidget {
  const _EmailClientContent();

  @override
  State<_EmailClientContent> createState() => _EmailClientContentState();
}

class _EmailClientContentState extends State<_EmailClientContent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();
  bool _isSearching = false;
  bool _isLoading = true;
  bool _isAuthenticated = false;
  late EmailSelectionController _selectionController;

  @override
  void initState() {
    super.initState();
    _initializeEmailClient();
  }

  Future<void> _initializeEmailClient() async {
    final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
    final emailService = Provider.of<EmailService>(context, listen: false);

    _selectionController = EmailSelectionController(
      onDelete: (emails) async {
        emailService.moveEmailsToFolder(emails, EmailFolder.trash);
        _search();
      },
      onArchive: (emails) async {
        emailService.moveEmailsToFolder(emails, EmailFolder.archives);
        _search();
      },
      onEmailUpdated: (email) async {
        emailService.updateEmail(email);
        _search();
      },
    )..addListener(_onSelectionChanged);

    // Check if user is already authenticated
    final isAuthenticated = await emailAuthService.isAuthenticated();

    if (isAuthenticated) {
      // Initialize email service if authenticated
      await emailService.initialize();
      setState(() {
        _isAuthenticated = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSelectionChanged() => setState(() {});

  void _search() {
    setState(() {});
  }

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

  Future<void> _handleLogout() async {
    final emailAuthService = Provider.of<EmailAuthService>(context, listen: false);
    final emailService = Provider.of<EmailService>(context, listen: false);

    await emailAuthService.logout();
    emailService.clear();

    setState(() {
      _isAuthenticated = false;
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                color: Theme.of(context).primaryColor,
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
    final filteredEmails = emailService.filterEmails(_searchController.text, EmailFolder.inbox);

    return PopScope(
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
                    hintText: 'E-Mails durchsuchen...',
                    border: InputBorder.none,
                  ),
                  onChanged: (_) => _search(),
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
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: _handleLogout,
              ),
            if (!_isSearching && !_selectionController.isSelecting)
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
          ],
        ),
        endDrawer: const EmailDrawer(),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _selectionController.isSelecting ? _selectionController.clearSelection : null,
          child: RefreshIndicator(
            onRefresh: () async {
              final emailService = Provider.of<EmailService>(context, listen: false);
              await emailService.refreshEmails();
              _search();
            },
            child: ListView.separated(
              itemCount: filteredEmails.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
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
// Trash is fully implemented so far(not anymore)
// TODO: Sent, Archives, Drafts
// TODO: Settings: I am unsure what to add in here.

// Check: 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Check: ticket_datasource(pages/wallet/ticket/) and injection.dart (in lib/core)
// Use Login, make it go to Email

// Check IMAP plugins (for dart/flutter): enough_mail?s
                      // SMPT und IMAP client => API
                      // UI und Backend separate, start with UI it is easier.
                      // flutter secure storage login daten, take it from there