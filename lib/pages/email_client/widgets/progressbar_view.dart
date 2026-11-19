import 'package:campus_app/core/themes.dart';
import 'package:campus_app/pages/email_client/services/email_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is a progress bar widget for the email verifikation
///
/// It offers a more transparent view to the User, giving updates on how far along the progress is
class ProgressbarView extends StatelessWidget {
  final ValueListenable<EmailProgress> progress;
  const ProgressbarView({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemesNotifier>(context).currentThemeData;

    return ValueListenableBuilder<EmailProgress>(
      valueListenable: progress,
      builder: (_, p, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: p.value),
              duration: const Duration(milliseconds: 400),
              builder: (_, v, __) => LinearProgressIndicator(
                value: v,
                minHeight: 8,
                borderRadius: BorderRadius.circular(16),
                backgroundColor: theme.cardColor,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Text(
                p.status,
                key: ValueKey(p.status),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
