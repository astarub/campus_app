# Internet Connection: Dio

> Dio is a powerful Http client for Dart, which supports Interceptors, Global configuration, FormData, Request Cancellation, File downloading, Timeout etc.
>
> - [pub.dev](https://pub.dev/packages/dio)

In comparison to the standard HTTP client, Dio provides a lot of handy features such
as automatic Cookie- and Session-Management. That makes our life easier. At the beginning
of development just the standard HTTP client was used and caused problems. That the reason
why we switched to Dio.

The Dio client is initialized inside the injection Container located inside `lib/core/injection.dart`. The `DioUtils` class takes the Dio client a `CookieJar` to initialize
both correctly.

Certificate validation bypass code is currently commented out and marked as unsafe (`DON'T DO THIS`). Current implementation keeps certificate validation enabled.

---

# Forgerock API
 
> If we plan to implement the eCampus / Flexnow connection, we will write this wiki page.

---

# Moodle API

> If we plan to implement the Moodle connection, we will write this wiki page.

---

