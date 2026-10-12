/// Stores profile data read from Keycloak or the semester ticket
/// Sharing this model does not connect the two login sessions
class StudentProfile {
  final String name;
  final String loginId;
  final String? email;
  // Set only when the login source provides a matriculation number
  final String? matriculationNumber;

  const StudentProfile({
    required this.name,
    required this.loginId,
    this.email,
    this.matriculationNumber,
  });

  // A factory constructor prepares values before returning a StudentProfile
  // This one builds the profile from ticket details stored by the repository
  factory StudentProfile.fromTicketDetails({
    required String loginId,
    required Map<String, dynamic> ticketDetails,
  }) {
    return StudentProfile(
      name: _fallbackName(
        ticketDetails['owner'],
        loginId,
      ),
      loginId: loginId,
      matriculationNumber: _optionalString(ticketDetails['matriculation_number']),
    );
  }

  // Use the login ID when the ticket contains no owner name
  // dynamic allows values whose type is only known while the app is running
  static String _fallbackName(
    dynamic value,
    String loginId,
  ) {
    final String? name = _optionalString(value);
    // ?? returns the login ID only when no usable name was found
    return name ?? loginId;
  }

  static String? _optionalString(dynamic value) {
    if (value == null) return null;

    final String normalized = value.toString().trim();

    if (normalized.isEmpty) return null;

    return normalized;
  }
}
