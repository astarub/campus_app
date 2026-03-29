# Authentication

This page provides a short overview of authentication flows currently used in the app.

---

## Semesterticket Login

The semesterticket flow uses the user provided RUB credentials (`loginId`, `password`).

- Credentials are read from secure storage.
- A headless webview performs the login flow.
- Ticket information (Aztec code and metadata) is extracted and stored securely.

Main implementation:

- `lib/pages/wallet/ticket/ticket_datasource.dart`
- `lib/pages/wallet/ticket/ticket_repository.dart`
