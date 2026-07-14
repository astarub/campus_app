class StudentProfile {
  final String name;
  final String loginId;
  // This can stay empty for now if we do not get a matriculation number
  final String? matriculationNumber;

  const StudentProfile({
    required this.name,
    required this.loginId,
    this.matriculationNumber,
  });

  // Build one profile object from ticket details.
  factory StudentProfile.fromTicketDetails({
    required String loginId,
    required Map<String, dynamic> ticketDetails,
  }) {
    // We already have ticket data in storage
    // This keeps raw ticket parsing out of the UI
    return StudentProfile(
      // Try to use the ticket owner as the display name
      name: _fallbackName(
        ticketDetails['owner'],
        loginId,
      ),
      // Keep the login ID (username) because it is useful on the profile page
      loginId: loginId,
      // Read the matriculation number if the ticket data ever contains one.
      matriculationNumber: _optionalString(ticketDetails['matriculation_number']),
    );
  }

  // This function decides what name to show. 
  // If the real name is missing, it just uses the login name (username).
  static String _fallbackName(
    dynamic value,
    String loginId,
  ) {
    final String? name = _optionalString(value);
    // If name is null, use loginId instead
    return name ?? loginId;
  }

  // This helps clean up the text we get from the ticket data.
  static String? _optionalString(dynamic value) {
    // If there is nothing, just return null.
    if (value == null) return null;

    // Change the value to text and remove extra spaces at the start or end.
    final String normalized = value.toString().trim();
    
    // If the text is empty now, return null.
    if (normalized.isEmpty) return null;

    return normalized;
  }
}
