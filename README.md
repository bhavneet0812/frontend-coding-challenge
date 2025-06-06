# 🗓️ Absence Manager App

A Flutter app to view and filter employee absences, featuring support for mobile/tablet layouts, calendar event export (ICS), and a clean state management architecture using BLoC.

---

## 🚀 Features

- 🔍 Filter absences by type, status, and date
- 📲 Adaptive UI for mobile and tablet
- 📤 Export absences as ICS calendar events
- 🧪 Robust unit, widget, and integration tests
- 🧱 Clean architecture with Repository and Bloc layers

---

## 🥪 Test Coverage

### ✅ Included Test Suites:

| File                           | Purpose                                                      |
| ------------------------------ | ------------------------------------------------------------ |
| `absence_list_bloc_test.dart`  | Tests BLoC events, state transitions, and error handling     |
| `absence_repository_test.dart` | Validates API integration, filtering logic, and data pairing |
| `ical_generator_test.dart`     | Ensures correct ICS format generation for calendar export    |
| `absence_list_page_test.dart`  | Widget tests for UI rendering across multiple states         |

---

## 💠 Running Tests

To run all tests:

```bash
flutter test
```

To run tests for a specific file:

```bash
flutter test test/data/absence_repository_test.dart
```

---

## 🧼 Test Setup & Mocking

- **Bloc:** Uses `bloc_test` and `mocktail` for event/state verification.
- **Repository/API:** The `ApiService` singleton is mocked via dependency injection using a constructor.
- **Widget Tests:** Cover various UI states like loading, error, no data, and data available scenarios.

---

## 📁 Project Structure

```
lib/
├── data/
│   ├── models/         # Absence, Member models
│   ├── services/       # API Service (local JSON based)
│   └── repository/     # AbsenceRepository (handles filtering + pairing)
├── presentation/
│   ├── bloc/           # BLoC pattern (events, states, bloc)
│   ├── pages/          # Screens & layouts
│   └── widgets/        # UI Components
├── core/
│   └── utils/          # ICS calendar generator
```

---

## 🤝 Contributing

1. Fork the repo
2. Create your feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -am 'Add new feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a pull request

---

## 📄 License

This project is licensed under the MIT License.

---

Let us know if you'd like badges or a lighter version of the README for submissions!
