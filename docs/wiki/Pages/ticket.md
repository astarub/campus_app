# Semesterticket

This page is to provide a basic overview about the "Calendar" feature located inside
`lib/pages/wallet/ticket`.

---

## Ticket usescases

| Type | Name | Description |
|------|------|-------------|
| Future<Image?> | renderAztecCode() | Returns an Image object, containing the resized Aztec code loaded from storage.
| Future<Map<String, dynamic>?> | getTicketDetails() | Returns a map, containing the ticket details such as the name of the owner, the birthdate and validity information.

---

## Ticket repository

| Type | Name | Description |
|------|------|-------------|
| Future<void> | loadTicket() | Calls the ticket datasource to load the remote ticket and then saves it to storage or deletes the exisiting one if it expired or was removed.
| Future<String?> | getAztecCode() | Returns the Aztec code as a Base64 String
| Future<String?> | getTicketDetails() | Returns the whole ticket map as JSON
| Future<void> | saveTicket(Map<String, dynamic> ticket) | Saves the Aztec Code and ticket details to two separate files using the passed Map
| Future<void> | deleteTicket() | Deletes the ticket from storage

---

## Ticket datasource

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, dynamic>> | getRemoteTicket() | Loads the remote ticket using a headless webview which clicks through the RUB login process and then extracts the Aztec code and ticket details from the RIDE website.
