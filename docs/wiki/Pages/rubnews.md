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
