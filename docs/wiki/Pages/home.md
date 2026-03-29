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
