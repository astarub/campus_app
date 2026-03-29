# Environment Variables

The app uses `envied` and reads secrets from a `.env` file in the project root.

---

## Required keys

The following keys are currently used by `lib/env/env.dart`:

- `MENSA_API_KEY`
- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_IOS_API_KEY`
- `APPWRITE_CREATE_USER_AUTH_KEY`
- `SENTRY_DSN`

---

## Setup

1. Create a `.env` file in the project root.
2. Add all required keys to the file.
3. Generate `lib/env/env.g.dart` with:

`flutter pub run build_runner build --delete-conflicting-outputs`

4. Start the app.