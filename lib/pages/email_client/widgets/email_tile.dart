import 'package:flutter/material.dart';
import 'package:campus_app/pages/email_client/models/email.dart';

class EmailTile extends StatelessWidget {
  final Email email;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const EmailTile({
    super.key,
    required this.email,
    required this.onTap,
    required this.onLongPress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? Colors.lightBlue.withOpacity(0.2)
        : email.isUnread
            ? Colors.blue[50]
            : Theme.of(context).canvasColor;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isSelected
                ? const Icon(Icons.check_circle, color: Colors.blue)
                : const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    email.sender,
                    style: TextStyle(
                      fontWeight: email.isUnread ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email.subject,
                    style: TextStyle(
                      fontWeight: email.isUnread ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email.preview,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: email.isUnread ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${email.date.hour}:${email.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: email.isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (email.isStarred) const Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
