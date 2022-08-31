# Calendar Page

> Disclaimer: Not full implemented yet!

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
