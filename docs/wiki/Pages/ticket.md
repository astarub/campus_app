# Semesterticket

This page is to provide a basic overview about the semesterticket feature located inside
`lib/pages/wallet/ticket`.

---

## TicketUsecases

| Type | Name | Description |
|------|------|-------------|
| Future<Image?> | renderAztecCode({int width = 200, int height = 200}) | Returns an Image widget with a resized Aztec code loaded from secure storage. |
| Future<Map<String, dynamic>?> | getTicketDetails() | Returns parsed ticket details from secure storage. |

---

## TicketRepository

| Type | Name | Description |
|------|------|-------------|
| Future<void> | loadTicket() | Loads the remote ticket and stores it securely. Deletes local ticket if remote ticket was removed. |
| Future<String?> | getAztecCode() | Returns the Aztec code as a Base64 String
| Future<String?> | getTicketDetails() | Returns the whole ticket map as JSON
| Future<void> | saveTicket(Map<String, dynamic> ticket) | Saves the Aztec code and ticket details to secure storage. |
| Future<void> | deleteTicket() | Deletes the ticket from secure storage. |

---

## TicketDataSource

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, dynamic>> | getRemoteTicket() | Loads the ticket using a headless webview and extracts Aztec code + ticket details from the RIDE website. |
