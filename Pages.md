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



---

# Mensa Page

This page is to provide a basic overview about the "Mensa" feature located inside
`lib/pages/mensa`.

---

## MensaUsecases

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, List\<dynamic>>> | updateDishesAndFailures() | Returns a map with `failures`, `mensa`, `roteBeete` and `qwest`. |
| Map<String, List\<dynamic>> | getCachedDishesAndFailures() | Returns cached dishes and failures only. |

---

## MensaRepository

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<DishEntity>>> | getRemoteDishes(int restaurant) | Loads dishes for one restaurant, parses them and caches them. |
| Either<Failure, List\<DishEntity>> | getCachedDishes(int restaurant) | Returns cached dishes for one restaurant. |

---

## MensaDataSource

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, dynamic>> | getRemoteData(int restaurant) | Requests menu data from backend API. |
| Future<void> | writeDishEntitiesToCache(List\<DishEntity> entities, int restaurant) | Writes dish entities to cache. |
| List\<DishEntity> | readDishEntitiesFromCache(int restaurant) | Reads dish entities from cache. |

---

## DishEntity

Represents one dish in the mensa feature.

---

# Wallet Page

This page is to provide a basic overview about the "Wallet" feature located inside
`lib/pages/wallet`.

---

## WalletPage

The wallet page is the entry point for wallet related features and views.

Current content includes:

- Semesterticket views
- Mensa balance page
- FAQ/guide screens

Main implementation:

- `lib/pages/wallet/wallet_page.dart`
- `lib/pages/wallet/ticket_login_screen.dart`
- `lib/pages/wallet/mensa_balance_page.dart`
- `lib/pages/wallet/faq_page.dart`
- `lib/pages/wallet/guide_content.dart`

Detailed semesterticket logic is documented in `docs/wiki/Pages/ticket.md`.

---

# More Page

This page is to provide a basic overview about the "More" feature located inside
`lib/pages/more`.

---

## MorePage

The `MorePage` bundles settings and external links.

It includes:

- Settings entry points
- Imprint and privacy policy pages
- External links (AStA and RUB related resources)
- In-app web view or external browser routing based on settings

Main implementation:

- `lib/pages/more/more_page.dart`
- `lib/pages/more/settings_page.dart`
- `lib/pages/more/in_app_web_view_page.dart`
- `lib/pages/more/imprint_page.dart`
- `lib/pages/more/privacy_policy_page.dart`

---

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

---

# Home Page

This page is to provide a basic overview about the "Home" feature located inside
`lib/pages/home`.

---

## HomePage

The `HomePage` is the app shell for the main navigation.

It handles:

- Bottom/side navigation
- Page switching between the main features
- Nested navigator keys per page
- Entry/exit animations for pages

---

## NavBarNavigator

`NavBarNavigator` creates a dedicated navigator stack per tab.

Configured page items:

- Feed
- Events
- Mensa
- Navigation
- Wallet
- More

Main implementation:

- `lib/pages/home/home_page.dart`
- `lib/pages/home/page_navigator.dart`

---

# Feed / News Page

This page is to provide a basic overview about the "Feed / News" feature located inside
`lib/pages/feed/news`.

---

## NewsUsecases

| Type | Name | Description |
|------|------|-------------|
| Future<Map<String, List\<dynamic>>> | updateFeedAndFailures() | Returns a map with `failures` and `news`. |
| Map<String, List\<dynamic>> | getCachedFeedAndFailures() | Returns cached news and failures only. |

---

## NewsRepository

| Type | Name | Description |
|------|------|-------------|
| Future<Either<Failure, List\<NewsEntity>>> | getRemoteNewsfeed() | Loads AStA and RUB news, parses entities and updates cache. |
| Either<Failure, List\<NewsEntity>> | getCachedNewsfeed() | Returns cached news list. |

---

## NewsDatasource

| Type | Name | Description |
|------|------|-------------|
| Future\<XmlDocument> | getNewsfeedAsXml() | Requests the RUB XML feed from `news.rub.de/newsfeed`. |
| Future<Map<String, dynamic>> | getImageDataFromNewsUrl(String url) | Requests image and copyright data for a news detail page. |
| Future<List\<dynamic>> | getAStAFeedAsJson() | Requests WordPress posts from `asta-bochum.de`. |
| Future<List\<dynamic>> | getAppFeedAsJson() | Requests WordPress posts from `app.asta-bochum.de`. |

---

## NewsEntity

### Attributes

| Type | Name | Description |
|------|------|-------------|
| String | content | HTML Content of News |
| String | title | |
| String | description | Short Summary |
| String | url | |
| DateTime | pubDate | Date of Publishing |
| List\<String> | imageUrls | List of image URLs. |

---

# Navigation Page

This page is to provide a basic overview about the "Navigation" feature located inside
`lib/pages/navigation`.

---

## Navigation Views

The feature currently contains:

- `outdoor_navigation_page.dart`
- `indoor_navigation_page.dart`
- Multiple widgets and static data files for room/path rendering

---

## NavigationDatasource

| Type | Name | Description |
|------|------|-------------|
| Future<NavigationGraph> | syncGraphOnUpdate() | Syncs graph data from remote Appwrite storage to local file. |
| Future<NavigationGraph> | loadGraphFromFile() | Loads graph data from local file. |
| NavigationGraph | loadGraphFromString(String jsonString) | Parses a JSON graph to app graph format. |
| Future<void> | syncMaps() | Syncs map image files from remote storage. |

Note: The datasource currently contains a comment that it is not yet used in production flow.

---

