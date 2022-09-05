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
