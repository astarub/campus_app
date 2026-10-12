import 'package:flutter_test/flutter_test.dart';

import 'package:campus_app/core/auth/student_profile.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_provider.dart';
import 'package:campus_app/pages/wallet/ticket/ticket_auth_service.dart';

// These tests use a fake service and do not contact the RUB ticket system
void main() {
  test('successful ticket login stores the returned profile', () async {
    const profile = StudentProfile(
      name: 'Test User',
      loginId: 'test-user',
      matriculationNumber: '108012345678',
    );
    final service = _FakeTicketAuthService(loginResult: profile);
    final provider = TicketAuthProvider(ticketAuthService: service);

    final success = await provider.login(
      loginId: '  test-user  ',
      password: 'secret',
    );

    expect(success, isTrue);
    expect(provider.isLoggedIn, isTrue);
    expect(provider.currentUser, same(profile));
    expect(provider.errorMessage, isNull);
    expect(service.receivedLoginId, 'test-user');
    expect(service.receivedPassword, 'secret');
  });
}

// Implements only the service calls used by these tests
class _FakeTicketAuthService implements TicketAuthService {
  _FakeTicketAuthService({
    required this.loginResult,
  });

  final StudentProfile loginResult;
  String? receivedLoginId;
  String? receivedPassword;

  @override
  Future<StudentProfile> login({
    required String loginId,
    required String password,
  }) async {
    receivedLoginId = loginId;
    receivedPassword = password;
    return loginResult;
  }

  @override
  Future<bool> hasStoredCredentials() async => false;

  @override
  Future<StudentProfile?> getStoredStudentProfile() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
