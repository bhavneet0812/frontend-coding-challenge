# 🗓️ Absence Manager App

A Flutter app to view and filter employee absences, featuring support for mobile/desktop layouts, calendar event export (ICS), and a clean state management architecture using BLoC.

---

## 🚀 Features

* 🔍 Filter absences by type, status, and date
* 📲 Adaptive UI for mobile and desktop
* 📤 Export absences as ICS calendar events
* 🧪 Robust unit, widget, and integration tests
* 🧱 Clean architecture with Repository and Bloc layers

---

## 📸 Screenshots

<p align="center"> Mobile View </p>

![Mobile View](/assets/screenshots/mobile.png?raw=true "Mobile View")

<p align="center"> Desktop View </p>

![Desktop View](/assets/screenshots/desktop.png?raw=true "Desktop View")

---

## 📦 Dependencies

* [go\_router](https://pub.dev/packages/go_router)
* [flutter\_bloc](https://pub.dev/packages/flutter_bloc)
* [equatable](https://pub.dev/packages/equatable)
* [intl](https://pub.dev/packages/intl)
* [cached_network_image](https://pub.dev/packages/cached_network_image)
* [share\_plus](https://pub.dev/packages/share_plus)
* [path\_provider](https://pub.dev/packages/path_provider)

## 📦 Dev Dependencies

* [bloc\_test](https://pub.dev/packages/bloc_test)
* [mocktail](https://pub.dev/packages/mocktail)

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

## 🛠️ Setup

Clone the repo and install dependencies:

```bash
git clone https://github.com/bhavneet0812/frontend-coding-challenge.git
cd frontend-coding-challenge
flutter pub get
```

---

## 💠 Running App

To run:

```bash
flutter run
```

To run profile mode:

```bash
flutter run --profile
```

To run release mode:

```bash
flutter run --release
```

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

## 💠 Release App Build

Android Release:

```bash
flutter build apk --release
```

Android(AppBundle) Release:

```bash
flutter build appbundle
```

iOS Release:

```bash
flutter build ipa --release
```

Web Release:

```bash
flutter build web --release
```

---

## 🌐 Deploy to GitHub Pages

Deploy the web app under `gh-pages` branch:

```bash
flutter build web --release --base-href="/frontend-coding-challenge/"

# Switch to gh-pages branch or create one
git checkout --orphan gh-pages
rm -rf *
cp -r build/web/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages --force
```

Then visit: [Live Demo](https://bhavneet0812.github.io/frontend-coding-challenge/)

---

## 🧼 Test Setup & Mocking

* **Bloc:** Uses `bloc_test` and `mocktail` for event/state verification.
* **Repository/API:** The `ApiService` singleton is mocked via dependency injection using a constructor.
* **Widget Tests:** Cover various UI states like loading, error, no data, and data available scenarios.

---

## 📁 Project Structure

```
lib/
├── data/
│   ├── data_models/    # Absence list filter model
│   ├── enums/          # Absence sort type, Absence status, Absence type
│   ├── models/         # Absence, Member models
│   ├── services/       # API Service (local JSON based)
│   └── repository/     # AbsenceRepository (handles filtering + pairing)
├── presentation/
│   ├── app/            # My App
│   ├── bloc/           # BLoC pattern (events, states, bloc)
│   ├── pages/          # Screens & layouts
│   ├── dialogs/        # Dialogs
│   └── widgets/        # UI Components
├── core/
│   ├── router/         # Route Management
│   ├── extensions/     # Extensions (Date, Generic, String)
│   └── utils/          # ICS calendar generator and Nullable Value
├── main.dart           # Main App
```

---

## 📚 Learn More

* ICS File Format: [RFC 5545](https://icalendar.org/)
* Flutter BLoC Pattern: [bloclibrary.dev](https://bloclibrary.dev/)
* Flutter Testing Guide: [flutter.dev/docs/testing](https://flutter.dev/docs/testing)

---

## 📄 License

This project is licensed under the MIT License.

---

Let us know if you'd like badges or a lighter version of the README for submissions!
