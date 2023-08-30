///
/// Sample XML construct with a single news item that follows the structure of news.rub.de/newsfeed
///
const String rubnewsSampleSingleNewsXMLItem = '''
<?xml version="1.0" encoding="utf-8" ?>
<rss version="2.0" xml:base="https://news.rub.de/"
    xmlns:atom="http://www.w3.org/2005/Atom">
    <channel>
        <item>
            <content>content</content>
            <title>title</title>
            <link>https://news.rub.de/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam</link>
            <description>description</description>
            <pubDate>Wed, 07 Sep 2022 09:31:00 +0200</pubDate>
        </item>
    </channel>
</rss>
''';
