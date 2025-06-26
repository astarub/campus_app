// This file defines the data model of an email (structure)
// by defining a data class that represents an email's properties
class Email {
  final String id; // Unique identifier for the email
  final String sender; // Display name of the sender
  final String senderEmail; // Sender's email address
  final List<String> recipients; // List of recipient email addresses
  final String subject; // Subject line of the email
  final String body; // Plain text body content
  final String? htmlBody; // Optional HTML version of the body
  final DateTime date; // Timestamp of when the email was sent
  final bool isUnread; // Whether the email is unread
  final bool isStarred; // Whether the email is marked as important/starred
  final List<String> attachments; // Filenames of any attachments
  final EmailFolder folder; // The folder where this email is stored

  // Added for IMAP operations
  final int uid; // IMAP UID for server operations (used to identify emails remotely)

  const Email({
    required this.id,
    required this.sender,
    required this.senderEmail,
    required this.recipients,
    required this.subject,
    required this.body,
    this.htmlBody,
    required this.date,
    this.isUnread = false,
    this.isStarred = false,
    this.attachments = const [],
    this.folder = EmailFolder.inbox,
    this.uid = 0, // Default to 0 for local/dummy emails
  });

  // Factory method for generating sample/mock emails (used for testing or UI previews)
  factory Email.dummy(int index) => Email(
        id: index.toString(),
        sender: 'Sender $index',
        senderEmail: 'sender$index@example.com',
        recipients: ['recipient$index@example.com'],
        subject: 'Subject line $index',
        body: 'This is the body content of email $index.\n\n'
            'It contains multiple paragraphs of sample text.\n\n'
            'Best regards,\nSender $index',
        date: DateTime.now().subtract(Duration(hours: index)),
        isUnread: index % 2 == 0,
        isStarred: index % 3 == 0,
        attachments: index % 4 == 0 ? ['document$index.pdf', 'image$index.jpg'] : [],
        uid: 0, // Dummy emails don't have IMAP UIDs
      );

  // Convert Email instance to a JSON map for storage or network transmission
  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'senderEmail': senderEmail,
        'recipients': recipients,
        'subject': subject,
        'body': body,
        'htmlBody': htmlBody,
        'date': date.toIso8601String(),
        'isRead': !isUnread, // Stored as "isRead" for clarity
        'isStarred': isStarred,
        'attachments': attachments,
        'folder': folder.name,
        'uid': uid,
      };

  // Create an Email instance from a JSON map
  factory Email.fromJson(Map<String, dynamic> json) => Email(
        id: json['id'],
        sender: json['sender'],
        senderEmail: json['senderEmail'],
        recipients: List<String>.from(json['recipients']),
        subject: json['subject'],
        body: json['body'],
        htmlBody: json['htmlBody'],
        date: DateTime.parse(json['date']),
        isUnread: !json['isRead'],
        isStarred: json['isStarred'],
        attachments: List<String>.from(json['attachments']),
        folder: EmailFolder.values.byName(json['folder']),
        uid: json['uid'] ?? 0,
      );

  // Create a modified copy of the current Email instance
  Email copyWith({
    String? id,
    String? sender,
    String? senderEmail,
    List<String>? recipients,
    String? subject,
    String? body,
    String? htmlBody,
    DateTime? date,
    bool? isUnread,
    bool? isStarred,
    List<String>? attachments,
    EmailFolder? folder,
    int? uid,
    bool? isRead, // Optional override using isRead instead of isUnread
  }) =>
      Email(
        id: id ?? this.id,
        sender: sender ?? this.sender,
        senderEmail: senderEmail ?? this.senderEmail,
        recipients: recipients ?? this.recipients,
        subject: subject ?? this.subject,
        body: body ?? this.body,
        htmlBody: htmlBody ?? this.htmlBody,
        date: date ?? this.date,
        isUnread: isRead != null ? !isRead : (isUnread ?? this.isUnread),
        isStarred: isStarred ?? this.isStarred,
        attachments: attachments ?? this.attachments,
        folder: folder ?? this.folder,
        uid: uid ?? this.uid,
      );

  // Shortened preview text of the email body
  String get preview {
    return body.length > 50 ? '${body.substring(0, 50)}...' : body;
  }

  // Convenience getters for easier access in UI and logic
  bool get isRead => !isUnread; // Inverted boolean for clarity
  bool get hasAttachments => attachments.isNotEmpty;
  String get senderName => sender; // Alias for UI usage
  DateTime get timestamp => date; // Alias for sorting or displaying
}

// Enum representing standard email folders
enum EmailFolder {
  inbox,
  sent,
  drafts,
  trash,
  archives,
  spam,
}
