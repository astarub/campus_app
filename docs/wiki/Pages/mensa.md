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
