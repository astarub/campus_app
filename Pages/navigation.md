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
