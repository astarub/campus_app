# Semesterticket

This page is to provide a basic overview about the "Calendar" feature located inside
`lib/pages/wallet/ticket`.

---

## Ticket usescases

| Type | Name | Description |
|------|------|-------------|
| Future<Image?> | renderQRCode() | Returns an Image object, containing the resized QR code loaded from storage.
| Future<Map<String, dynamic>?> | getTicketDetails() | Returns a map, containing the ticket details such as the name of the owner, the birthdate and validity information.

---

## Ticket repository

| Type | Name | Description |
|------|------|-------------|
| Future<void> | loadTicket() | Calls the ticket datasource to load the remote ticket and then saves it to storage or deletes the exisiting one if it expired or was removed.
| Future<File> | getQRCodeFile() | Returns a File object of the saved QR code
| Future<File> | getTicketDetailsFile() | Returns a File object of the saved ticket details
| Future<bool> | qrCodeFileExists() | Checks whether a QR code was saved to storage
| Future<bool> | ticketDetailsFileExists() | Checks whether ticket details were saved to storage
| Future<void> | saveTicket(Map<String, dynamic> ticket) | Saves the QR Code and ticket details to two separate files using the passed Map
| Future<void> | deleteTicket() | Deletes the ticket from storage

---

## Ticket datasource

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, dynamic>> | getRemoteTicket() | Loads the remote ticket using a headless webview which clicks through the RUB login process and then extracts the QR code and ticket details from the RIDE website.
