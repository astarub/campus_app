# Rubnews Page

> Not full implemented yet!

This page is to provide a basic overview about the "Rubnews" feature located inside
`lib/pages/rubnews`.

---

## RubnewsUsecases

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<RubnewsNewsEntity>>> | getNewsList() | Return a list of `RubnewsNewsEntity` or a Failure. It wil store the returned list for further caching in a local datsource.

---

## RubnewsRepository

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<RubnewsNewsEntity>>> | getNewsfeedAsXml() | Return a list of `RubnewsNewsEntity` or a Failure. With the help of `RubnewsNewsModel` it will parse the XML response of `RubnewsRemoteDatasource` to the corresponding entity. The requested events are coming from the RUB News site at [news.rub.de/newsfeed](https://news.rub.de/newsfeed).

---

## RubnewsRemoteDatasource

| Type | Name | Description |
|------|------|-------------|
| Future\<XmlDocument> | getNewsfeedAsXml() | Request news feed from [news.rub.de/newsfeed](https://news.rub.de/newsfeed). Throws a server exception if respond code is not 200.
| Future\<CachedNetworkImage> | getImageFromNewsUrl() | Request image of linked news. Throws a server excpetion if respond code is not 200. (Disclaimer: Image-handling should not part of this layer.)
| Future\<String> | getImageUrlFromNewsUrl() | Read out the image source url, based on the news url. Throws a server exception if respond code is not 200.

---

## RubnewsNewsEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| String | content | HTML Content of News |
| String | title | |
| String | description | Short Summary |
| String | url | |
| DateTime | pubDate | Date of Publishing |
| List\<String> | imageUrls | List of Urls to images source. Usually only one image. |

---

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

---

# Calendar Page

> Not full implemented yet!

This page is to provide a basic overview about the "Calendar" feature located inside
`lib/pages/calendar`.

---

## CalendarUsecases

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<CalendarEventEntity>>> | getEventsList() | Return a list of `CalendarEventEntitiy` or a Failure. It wil store the returned list for further caching in a local datasource.

---

## CalendarRepository

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<CalendarEventEntity>>> | getAStAEvents() | Return a list of `CalendarEventEntitiy` or a Failure. With the help of `CalendarEventModel` it will parse the JSON response of `CalendarRemoteDatasource` to the corresponding entity. The requested events are coming from the AStA Wordpress instance at [asta-bochum.de](asta-bochum.de)

---

## CalendarRemoteDatasource

| Type | Name | Description |
|------|------|-------------|
| Future<List\<dynamic>> | getAStAEventsAsJsonArray() | Request events from tribe API at [asta-bochum.de/wp-json/tribe/v1/events](asta-bochum.de/wp-json/tribe/v1/events). Throws a server excpetion if respond code is not 200.
| Future\<XmlDocument> | getAStAEventfeedAsXML() | Not implemented and properly unnecessary.

---

## CalendarEventEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| int | id | |
| String | url | |
| String | title | |
| String | description | |
| String | slug | url identifier |
| bool | hasImage | |
| String? | imageUrl | |
| bool | allDay | |
| DateTime | startDate | |
| DateTime | endDate | |
| int | duration | |
| String | timeZone | |
| Map<String, String> | cost | JSON object of value and currency |
| String | website | website of event |
| List\<CalendarCategoryEntity> | categories | list can be empty |
| List\<CalendarTagEntity> | tags | list can be empty |
| CalendarVenueEntity | venue | |
| List\<CalendarOrganizerEntity> | organizers | list can be empty |

---

## CalendarVenueEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| int | id|  |
| String | url|  |
| String | name|  |
| String | slug| url identifier |
| String? | address|  |
| String? | city|  |
| String? | country|  |
| String? | province|  |
| String? | zip|  |
| String? | phone|  |

---

## CalendarOrganizerEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| int | id|  |
| String | url|  |
| String | name|  |
| String | slug| url identifier |
| String? | phone|  |
| String? | website|  |
| String? | email|  |

---

## CalendarCategoryEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| int | id|  |
| String | url|  |
| String | name|  |
| String | slug| url identifier |
| String | description|  |

---

## CalendarTagEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| int | id|  |
| String | url|  |
| String | name|  |
| String | slug| url identifier |
| String | description|  |

---

