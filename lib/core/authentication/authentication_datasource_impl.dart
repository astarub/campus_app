part of 'authentication_datasource.dart';

class AuthenticationDatasourceImpl implements AuthenticationDatasource {
  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyMoodleToken = 'token';
  static const _keyMoodlePrivatetoken = 'privatetoken';
  static const _keyTokenId = 'tokenId';

  final dio.Dio client;
  final DioUtils dioUtils;
  final FlutterSecureStorage storage;
  final ForgerockAPIUtils apiUtils;

  AuthenticationDatasourceImpl({
    required this.client,
    required this.storage,
    required this.apiUtils,
    required this.dioUtils,
  });

  @override
  Future<String> authenticateWithTOTPAndGetToken({
    required String username,
    required String password,
    required String totp,
  }) async {
    dioUtils.configure(
      baseUrl: ForgerockAPIConstants.baseUrl,
    );

    //* Step 1: Get authId of request
    var response = await client.post(
      ForgerockAPIOperations.authenticate,
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    var authId = (response.data as Map<String, dynamic>)['authId'];

    //* Step 2: Authenticate with username and password
    var anwser = apiUtils.bodyAuthAnwserUsernameAndPassword(
      authId,
      username,
      password,
    ); // construct correct json anwser

    response = await client.post(
      ForgerockAPIOperations.authenticate,
      options: dio.Options(
        headers: ForgerockAPIConstants.jsonHeader,
      ),
      data: json.encode(anwser),
    );

    authId = (response.data as Map<String, dynamic>)['authId'];

    //* Step 3: Authenticate with TOTP
    anwser = apiUtils.bodyAuthAnwserTOTP(authId, totp);
    response = await client.post(
      ForgerockAPIOperations.authenticate,
      options: dio.Options(
        headers: ForgerockAPIConstants.jsonHeader,
      ),
      data: json.encode(anwser),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    }

    final responseBody = response.data as Map<String, dynamic>;

    if (responseBody['tokenId'] == null) {
      throw Invalid2FATokenException();
    } else if (responseBody['tokenId'] == '') {
      throw EmptyResponseException();
    }

    return responseBody['tokenId'];
  }

  @override
  Future<void> credentialCheckByMoodle({
    required String username,
    required String password,
  }) async {
    dioUtils.configure(
      baseUrl: MoodleAPIConstants.baseUrl,
    );

    final response = await client.post(
      MoodleAPIOperations.getTokenByLogin,
      data: dio.FormData.fromMap({
        MoodleAPIConstants.passwordQuery: password,
        MoodleAPIConstants.usernameQuery: username
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      final responseBody = response.data as Map<String, dynamic>;

      if (responseBody['token'] == null ||
          responseBody['privatetoken'] == null) {
        throw InvalidLoginIDAndPasswordException();
      }

      await storeMoodleToken(responseBody['token'] as String);
      await storeMoodlePrivatetoken(responseBody['privatetoken'] as String);
    }
  }

  @override
  Future<void> deleteLoginID() async {
    await storage.delete(key: _keyUsername);
  }

  @override
  Future<void> deleteMoodlePrivatetoken() async {
    await storage.delete(key: _keyMoodlePrivatetoken);
  }

  @override
  Future<void> deleteMoodleToken() async {
    await storage.delete(key: _keyMoodleToken);
  }

  @override
  Future<void> deletePassword() async {
    await storage.delete(key: _keyPassword);
  }

  @override
  Future<void> deleteTokenId() async {
    await storage.delete(key: _keyTokenId);
  }

  @override
  Future<String?> getLoginID() async {
    return storage.read(key: _keyUsername);
  }

  @override
  Future<String?> getMoodlePrivatetoken() {
    return storage.read(key: _keyMoodlePrivatetoken);
  }

  @override
  Future<String?> getMoodleToken() async {
    return storage.read(key: _keyMoodleToken);
  }

  @override
  Future<String?> getPassword() async {
    return storage.read(key: _keyPassword);
  }

  @override
  Future<String?> getTokenId() async {
    return storage.read(key: _keyTokenId);
  }

  @override
  Future<void> storeLoginID(String username) async {
    await storage.write(key: _keyUsername, value: username);
  }

  @override
  Future<void> storeMoodlePrivatetoken(String privatetoken) async {
    await storage.write(key: _keyMoodlePrivatetoken, value: privatetoken);
  }

  @override
  Future<void> storeMoodleToken(String token) async {
    await storage.write(key: _keyMoodleToken, value: token);
  }

  @override
  Future<void> storePassword(String password) async {
    await storage.write(key: _keyPassword, value: password);
  }

  @override
  Future<void> storeTokenId(String tokenId) async {
    await storage.write(key: _keyTokenId, value: tokenId);
  }

  @override
  Future<Map<String, dynamic>> validate2FASession({
    required String tokenId,
  }) async {
    dioUtils.configure(
      baseUrl: ForgerockAPIConstants.baseUrl,
    );

    final response = await client.post(
      ForgerockAPIOperations.validateSession,
      options: dio.Options(
        headers: {ForgerockAPIConstants.cookieName: tokenId},
      ),
    );

    if (response.statusCode != 200) {
      throw ServerException();
    } else {
      return response.data as Map<String, dynamic>;
    }
  }
}
