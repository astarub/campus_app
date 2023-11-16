//* Forgerock Docs:     https://backstage.forgerock.com/docs/idcloud/latest/developer-docs/postman-collection.html
//*                     https://backstage.forgerock.com/docs/openam/13/dev-guide/#rest-api-auth
//*                     https://backstage.forgerock.com/docs/openam/13/admin-guide/index.html#authn-2sv
//* Postman Collection: https://backstage.forgerock.com/docs/idcloud/latest/_attachments/ForgeRock_Identity_Cloud.postman_collection.20210804.json
//* OpenAM API Summary: https://gist.github.com/burck1/e9c0d48118fbe61a9c13

class ForgerockAPIConstants {
  static const String baseUrl = 'https://sso-ecampus.ruhr-uni-bochum.de/';
  static const String openamPath = 'openam/json/';
  static const String realm = 'realms/root/realms/ecampus';
  static const String methodPOST = 'POST';
  static const String methodGET = 'GET';
  static const Map<String, String> jsonHeader = {
    'Content-Type': 'application/json',
  };
  static const String cookieName = 'iPlanetDirectoryPro';
}

class ForgerockAPIOperations {
  static const String authenticate = '${ForgerockAPIConstants.openamPath}${ForgerockAPIConstants.realm}/authenticate';
  static const String validateSession =
      '${ForgerockAPIConstants.openamPath}${ForgerockAPIConstants.realm}/sessions?_prettyPrint=true&_action=validate';
}

class ForgerockAPIUtils {
  Map<String, dynamic> bodyAuthAnwserTOTP(
    String authId,
    String totp,
  ) {
    return {
      'authId': authId,
      'callbacks': [
        {
          'type': 'NameCallback',
          'output': [
            {'name': 'prompt', 'value': 'Enter verification code'},
          ],
          'input': [
            {'name': 'IDToken1', 'value': totp},
          ],
        },
        {
          'type': 'ConfirmationCallback',
          'output': [
            {'name': 'prompt', 'value': ''},
            {'name': 'messageType', 'value': 0},
            {
              'name': 'options',
              'value': ['Submit', 'Use recovery code'],
            },
            {'name': 'optionType', 'value': -1},
            {'name': 'defaultOption', 'value': 0},
          ],
          'input': [
            {'name': 'IDToken2', 'value': 0},
          ],
        }
      ],
    };
  }

  Map<String, dynamic> bodyAuthAnwserUsernameAndPassword(
    String authId,
    String username,
    String password,
  ) {
    return {
      'authId': authId,
      'callbacks': [
        {
          'type': 'NameCallback',
          'output': [
            {'name': 'prompt', 'value': 'User Name'},
          ],
          'input': [
            {'name': 'IDToken1', 'value': username},
          ],
          '_id': 0,
        },
        {
          'type': 'PasswordCallback',
          'output': [
            {'name': 'prompt', 'value': 'Password'},
          ],
          'input': [
            {'name': 'IDToken2', 'value': password},
          ],
          '_id': 1,
        },
        {
          'type': 'TextOutputCallback',
          'output': [
            {
              'name': 'message',
              'value':
                  'document.getElementById(\"infotext_0\").innerHTML=\"<div class=\\\"tooltipam\\\"><a href=\\\"https://idm.ruhr-uni-bochum.de/rubiks_a/pw_reset.startseite\\\">Wissen Sie Ihr Passwort nicht?</a><span class=\\\"tooltiptextam\\\">Diesen Service können Sie nur nutzen, wenn für Sie bereits eine Handynummer hinterlegt ist. Klicken Sie auf den Link für weitere Informationen.</span></div><div style=\\\"margin-top:10px;\\\"><div class=\\\"tooltipamTOTP\\\"><a href=\\\"https://www.it-services.ruhr-uni-bochum.de/services/ias/2fa.html.de\\\">Informationen &amp; Anleitungen zur 2-Faktor-Authentifizierung</a><span class=\\\"tooltiptextamTOTP\\\"></span></div></div><br><div style=\\\"float:left; margin-bottom:10px;\\\"><h1 style=\\\"color:#8dae10;\\\">Sie sind noch nicht freigeschaltet?</h1><br><div><span style=\\\"color:#003560;\\\">Nach Aktivierung der zusätzlichen 1-Faktor- oder 2-Faktor-Authentifizierung im <a href=\\\"https://www.rub.de/login\\\">Identity-Management-Portal der RUB</a> (Menüpunkt „2-Faktor-Authentifizierung\\\") können Sie den Login auf dieser Seite für den eCampus WebClient nutzen.</span></div></div>\"',
            },
            {'name': 'messageType', 'value': '4'},
          ],
          '_id': 2,
        }
      ],
    };
  }
}
