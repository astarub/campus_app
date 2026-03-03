import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

/// A tile representing a single email in the inbox list.
class EmailTile extends StatelessWidget {
  final Email email;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const EmailTile({
    super.key,
    required this.email,
    required this.onTap,
    this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set background color based on state:
    // - selected emails use a translucent primary color
    // - unread emails use surfaceVariant (highlight)
    // - read emails use regular surface
    final Color bgColor = isSelected
        ? theme.colorScheme.primary.withOpacity(0.1)
        : email.isUnread
            ? theme.colorScheme.surfaceVariant
            : theme.colorScheme.surface;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeadingIcon(theme), // Avatar or selection indicator
            const SizedBox(width: 16),
            _buildEmailContent(theme), // Sender, subject, and preview
            _buildTrailingInfo(theme), // Timestamp
          ],
        ),
      ),
    );
  }

  /// Displays a selection icon if selected, otherwise a generic avatar.
  Widget _buildLeadingIcon(ThemeData theme) {
    return isSelected
        ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
        : CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Icon(Icons.person, color: theme.colorScheme.onPrimaryContainer),
          );
  }

  /// Builds the main email content: sender, subject, and preview line.
  Widget _buildEmailContent(ThemeData theme) {
    final bool isUnread = email.isUnread;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender name
          Text(
            email.sender,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          const SizedBox(height: 4),

          // Email subject
          Text(
            email.subject,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),

          const SizedBox(height: 4),

          // Email preview (first line of body)
          Text(
            email.preview,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Displays the time of the email (e.g., 14:05).
  Widget _buildTrailingInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${email.date.hour}:${email.date.minute.toString().padLeft(2, '0')}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: email.isUnread ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
