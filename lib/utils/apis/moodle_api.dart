//* Moodle Docs: https://docs.moodle.org/dev/Creating_a_web_service_client
//*              https://docs.moodle.org/dev/Web_service_API_functions
//* Reference:   https://github.com/moodle/moodle/blob/master/lib/db/services.php
//* Tutorial:    https://stackoverflow.com/questions/44652206/getting-information-from-the-moodle-api-as-a-student

class MoodleAPIConstants {
  static const String usernameQuery = 'username';
  static const String passwordQuery = 'password';
  static const String service = 'service=moodle_mobile_app';
  static const String wsRestFormatJSON = 'moodlewsrestformat=json';
  static const String wsRestFormatXML = 'moodlewsrestformat=xml';
  static const String baseUrl = 'https://moodle.ruhr-uni-bochum.de/';
  static const String serverPHP = 'webservice/rest/server.php';
  static const String tokenQuery = 'wstoken';
  static const String functionQuery = 'wsfunction';
  static const String usridQuery = 'userid';
  static const String getUsersCourses = 'core_enrol_get_users_courses';
  static const String getSiteInfo = 'core_webservice_get_site_info';
  static const String methodPOST = 'POST';
  static const String methodGET = 'GET';
}

class MoodleAPIOperations {
  static const String getUsersCoursesAsXML =
      '${MoodleAPIConstants.serverPHP}?${MoodleAPIConstants.functionQuery}=${MoodleAPIConstants.getUsersCourses}&${MoodleAPIConstants.wsRestFormatXML}';
  static const String getUsersCoursesAsJson =
      '${MoodleAPIConstants.serverPHP}?${MoodleAPIConstants.functionQuery}=${MoodleAPIConstants.getUsersCourses}&${MoodleAPIConstants.wsRestFormatJSON}';
  static const String getTokenByLogin =
      'login/token.php?${MoodleAPIConstants.service}&${MoodleAPIConstants.wsRestFormatJSON}';
  static const String getSiteInfoAsJSON =
      '${MoodleAPIConstants.serverPHP}?${MoodleAPIConstants.functionQuery}=${MoodleAPIConstants.getSiteInfo}&${MoodleAPIConstants.wsRestFormatJSON}';
}
