class BackendAccount {
  final String id;
  final String password;
  final String fcmToken;
  final List<Map<String, dynamic>> savedEvents;
  final String lastLoginDocumentId;

  const BackendAccount({
    required this.id,
    required this.password,
    required this.fcmToken,
    required this.savedEvents,
    required this.lastLoginDocumentId,
  });

  const BackendAccount.empty({
    this.id = '',
    this.password = '',
    this.fcmToken = '',
    this.savedEvents = const [],
    this.lastLoginDocumentId = '',
  });

  BackendAccount copyWith({
    String? id,
    String? password,
    String? fcmToken,
    List<Map<String, dynamic>>? savedEvents,
    String? lastLoginDocumentId,
  }) {
    return BackendAccount(
      id: id ?? this.id,
      password: password ?? this.password,
      fcmToken: fcmToken ?? this.fcmToken,
      savedEvents: savedEvents ?? this.savedEvents,
      lastLoginDocumentId: lastLoginDocumentId ?? this.lastLoginDocumentId,
    );
  }

  factory BackendAccount.fromJson({required Map<String, dynamic> json}) {
    return BackendAccount(
      id: json['id'],
      password: json['password'],
      fcmToken: json['fcmToken'],
      savedEvents: List<Map<String, dynamic>>.from(json['savedEvents']),
      lastLoginDocumentId: json['lastLoginDocumentId'],
    );
  }

  Map<String, dynamic> toInternalJson() {
    return {
      'id': id,
      'password': password,
      'fcmToken': fcmToken,
      'savedEvents': savedEvents,
      'lastLoginDocumentId': lastLoginDocumentId,
    };
  }
}
