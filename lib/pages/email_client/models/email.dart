// this files defines the data model of an email (structure)
// by defining a data class that represents an email's properties
class Email {
  final String id;
  final String sender;
  final String senderEmail;
  final List<String> recipients;
  final String subject;
  final String body;
  final DateTime date;
  final bool isUnread;
  final bool isStarred;
  final List<String> attachments;
  final EmailFolder folder;

  // Added for IMAP operations
  final int uid; // IMAP UID for server operations

  const Email({
    required this.id,
    required this.sender,
    required this.senderEmail,
    required this.recipients,
    required this.subject,
    required this.body,
    required this.date,
    this.isUnread = false,
    this.isStarred = false,
    this.attachments = const [],
    this.folder = EmailFolder.inbox,
    this.uid = 0, // Default to 0 for local/dummy emails
  });

  // Updated dummy constructor
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

  // JSON serialization
  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'senderEmail': senderEmail,
        'recipients': recipients,
        'subject': subject,
        'body': body,
        'date': date.toIso8601String(),
        'isRead': !isUnread,
        'isStarred': isStarred,
        'attachments': attachments,
        'folder': folder.name,
        'uid': uid,
      };

  factory Email.fromJson(Map<String, dynamic> json) => Email(
        id: json['id'],
        sender: json['sender'],
        senderEmail: json['senderEmail'],
        recipients: List<String>.from(json['recipients']),
        subject: json['subject'],
        body: json['body'],
        date: DateTime.parse(json['date']),
        isUnread: !json['isRead'],
        isStarred: json['isStarred'],
        attachments: List<String>.from(json['attachments']),
        folder: EmailFolder.values.byName(json['folder']),
        uid: json['uid'] ?? 0,
      );

  Email copyWith({
    String? id,
    String? sender,
    String? senderEmail,
    List<String>? recipients,
    String? subject,
    String? body,
    DateTime? date,
    bool? isUnread,
    bool? isStarred,
    List<String>? attachments,
    EmailFolder? folder,
    int? uid,
    bool? isRead,
  }) =>
      Email(
        id: id ?? this.id,
        sender: sender ?? this.sender,
        senderEmail: senderEmail ?? this.senderEmail,
        recipients: recipients ?? this.recipients,
        subject: subject ?? this.subject,
        body: body ?? this.body,
        date: date ?? this.date,
        isUnread: isRead != null ? !isRead : (isUnread ?? this.isUnread),
        isStarred: isStarred ?? this.isStarred,
        attachments: attachments ?? this.attachments,
        folder: folder ?? this.folder,
        uid: uid ?? this.uid,
      );

  String get preview {
    return body.length > 50 ? '${body.substring(0, 50)}...' : body;
  }

  // Convenience getters for compatibility with IMAP service
  bool get isRead => !isUnread;
  bool get hasAttachments => attachments.isNotEmpty;
  String get senderName => sender;
  DateTime get timestamp => date;
}

enum EmailFolder {
  inbox,
  sent,
  drafts,
  trash,
  archives,
}
