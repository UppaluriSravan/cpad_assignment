# CPAD Assignment

A modern Flutter application demonstrating user authentication and CRUD operations using Back4App (Parse Server) as the backend.

## youtube Demo link

- https://www.youtube.com/watch?v=1ROF8HxOkFg

## Features

- **User Authentication**: Sign up, login, and password reset using Parse Server (Back4App).
- **CRUD Operations**: Create, read, update, and delete records (with `name` and `age` fields) stored in the cloud.
- **Modern UI**: Material Design, responsive layout, cards, icons, and color schemes.
- **Error Handling**: User-friendly error messages and loading indicators.
- **Logout**: Securely log out from the app.
- **Code Comments**: Clear, structured comments for maintainability.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- A Back4App (Parse Server) account ([Sign up here](https://www.back4app.com/))

### Setup

1. **Clone the repository:**
   ```pwsh
   git clone <your-repo-url>
   cd CPAD_Assignment
   ```
2. **Install dependencies:**
   ```pwsh
   flutter pub get
   ```
3. **Configure Back4App:**
   - Update the `main.dart` file with your Back4App Application ID, Client Key, and Server URL if needed.
4. **Run the app:**
   ```pwsh
   flutter run
   ```

## Usage

- **Sign Up:** Register a new user with username, email, and password.
- **Login:** Log in with your credentials.
- **Forgot Password:** Request a password reset email.
- **CRUD Records:** Add, edit, or delete records (name & age) in the cloud.
- **Logout:** Securely log out from the app.

## Tools & Packages Used

- [Flutter](https://flutter.dev/) – UI toolkit for building natively compiled apps.
- [parse_server_sdk_flutter](https://pub.dev/packages/parse_server_sdk_flutter) – Parse SDK for Flutter, enables communication with Back4App.
- [Material Design](https://m3.material.io/) – Modern UI components.

## Project Structure

- `lib/main.dart` – Main app logic, UI, and Parse integration.
- `pubspec.yaml` – Project dependencies and configuration.
- `test/` – Widget and unit tests.

## Demo Script

1. **Open the app.**
2. **Sign up** with a new username, email, and password.
3. **Login** with your credentials.
4. **Add a record** (enter name and age, then tap Add).
5. **Edit or delete** a record using the icons.
6. **Logout** and try logging in again.
7. **Reset password** using the Forgot Password link.

## Common Challenges & Solutions

- **Parse Initialization Errors:** Double-check your Back4App credentials.
- **Network Issues:** Ensure you have a stable internet connection.
- **Field Validation:** The app prevents empty or invalid input for all forms.

## Video/YouTube Description

This video demonstrates a Flutter app integrated with Back4App (Parse Server) for user authentication (signup, login, password reset) and cloud-based CRUD operations. The app features a modern UI, secure authentication, and real-time data management, making it ideal for learning full-stack mobile development with Flutter and Back4App.

---
