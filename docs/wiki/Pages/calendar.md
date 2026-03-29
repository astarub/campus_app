# Calendar Page

This page is to provide a basic overview about the "Calendar" feature located inside
`lib/pages/calendar`.

---

## CalendarUsecases

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, List\<dynamic>>> | updateEventsAndFailures() | Returns a map with `failures`, `events` and `saved` event lists. |
| Map<String, List\<dynamic>> | getCachedEventsAndFailures() | Returns cached events and failures only. |

---

## CalendarRepository

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<Event>>> | getAStAEvents() | Loads AStA events, parses them and caches them. |
| Future<Either<Failure, List\<Event>>> | getAppEvents() | Loads app events, parses them and caches them. |
| Either<Failure, List\<Event>> | getCachedEvents() | Returns cached AStA + app events. |
| Future<Either<Failure, List\<Event>>> | updateSavedEvents({Event? event}) | Updates and returns locally saved events. |

---

## CalendarDatasource

| Type | Name | Description |
|------|------|-------------|
| Future<List\<dynamic>> | getAStAEventsAsJsonArray() | Requests AStA events as JSON array. |
| Future<List\<dynamic>> | getAppEventsAsJsonArray() | Requests app events as JSON array. |
| Future<void> | writeEventsToCache(List\<Event> entities, {bool saved = false, bool app = false}) | Writes event lists to cache. |
| List\<Event> | readEventsFromCache({bool saved = false, bool app = false}) | Reads event lists from cache. |

---

## Event

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
| List\<Category> | categories | list can be empty |
| Venue | venue | |
| List\<Organizer> | organizers | list can be empty |

---

## Venue

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

## Organizer

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

## Category

### Attributes

| Type | Name | Description |
|------|------|-------------|
| int | id|  |
| String | url|  |
| String | name|  |
| String | slug| url identifier |
| String | description|  |

---


