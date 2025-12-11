# Boo Match Page – Technical Test (Flutter)

This repository contains an implementation of the **Boo matching page**, built as part of the *Boo Flutter Developer Technical Assessment*.
The goal is to reproduce core UI and interactions of the existing Boo app using placeholder data and a clean Flutter architecture.

---

## Objectives

1. Recreate the **Match Page UI** closely using placeholder icons and data.
2. Implement scrollable profile cards.
3. Implement Pass (X) and Like (Heart) actions.
4. Demonstrate required flow:
   - Scroll profile #1 → Press X
   - Scroll profile #2 → Press ♥
   - Scroll profile #3
5. Provide full project source or public repository.

---

## Architecture

```
lib/
│
├── bloc/
│   ├── match_cubit.dart
│   └── match_state.dart
│
├── models/
│   └── user_profile.dart
│
├── pages/
│   └── match_page.dart
│
├── widgets/
│   ├── action_row.dart
│   ├── bottom_nav.dart
│   └── profile_card.dart
│
└── main.dart
```

### Principles
- Unidirectional data flow (UI → Cubit → State → UI)
- Stateless rendering; business logic isolated inside Cubit
- Componentized widgets for maintainability
- Mocked user data (no backend dependency)

---

## Feature Breakdown

### Profile Cards
- Scroll interaction
- Placeholder avatar/name/bio fields
- Simple animation and stack behavior

### Action Row
- **Pass** → remove current profile
- **Like** → remove and mark liked
- Triggered via `MatchCubit`

### Bottom Navigation
- Custom glassmorphic style
- Purely UI; no routing required

### State Management
`MatchCubit` exposes:
- Current user
- Remaining profiles
- `pass()`, `like()`, `loadNext()`

---

## Running the App

```
flutter pub get
flutter run
```

No additional configuration required.

---

## Testing

A basic widget smoke test is included:

- App renders without exception
- MatchPage loads
- Ensures presence of expected core widgets

---

## Demo Recording Steps

1. Scroll profile #1 → press **X**
2. Scroll profile #2 → press **♥**
3. Scroll profile #3

---

## Notes for Reviewers

- All UI manually built without external animation libs
- Tested on standard mobile sizes
- Concise architecture for clarity during review

---

## License

Provided solely for Boo Flutter Developer Technical Assessment.
