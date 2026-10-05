# Local Keycloak

The local Keycloak instance reproduces the realm and client needed by the app.
It is only intended for development and does not connect to the RUB SSO.

## Start

```powershell
docker compose up -d
```

Keycloak then runs at `http://localhost:8080`. The Android emulator reaches it
through `http://10.0.2.2:8080`.

Local development accounts:

- Keycloak administration: `admin` / `admin`
- App test user: `testuser` / `testuser`

These credentials are intentionally simple and must never be used outside a
local development environment. The admin values can be replaced with the
`KEYCLOAK_ADMIN_USERNAME` and `KEYCLOAK_ADMIN_PASSWORD` environment variables.
The host port can be changed with `KEYCLOAK_PORT`.

The realm import enables the Authorization Code Flow and requires PKCE with
SHA-256. The password flow is disabled for the Flutter client.

Keycloak imports the realm only when its data volume is empty. To recreate a
fresh local realm, first stop the environment and remove its development volume:

```powershell
docker compose down -v
docker compose up -d
```
