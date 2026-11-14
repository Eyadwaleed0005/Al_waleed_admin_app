# Al-Waleed Admin

Al-Waleed Admin is an administration application for managing students, educational content, exams, results, live sessions, notifications, and application settings across the Al-Waleed platform.

## Features

- Administrator authentication
- Student account and subscription management
- Grade-based student organization
- Educational lesson and study-note management
- Free and subscription-based content controls
- Video and PDF material management
- Online exam and question management
- Student exam-results monitoring
- Individual student performance tracking
- Live-session management
- Push-notification management
- Application version and update management
- Network connection monitoring

## Student Management

- View and create student accounts
- Organize students by academic grade
- Manage student names, phone numbers, and email addresses
- Update student passwords
- Support students without subscription dates
- Manage subscription dates, renewals, and activation status
- Track subscription status independently of Firebase Authentication account status
- Reset student device-login status
- Delete student accounts
- Review student exam history, results, and performance

Students without an active subscription can access the free content available for their academic grade in the student application.

## Content Management

- Add and manage educational lessons and study notes
- Attach educational videos
- Upload and replace PDF materials
- Organize content by academic grade
- Manage content publication status
- Mark lessons and study notes as free or subscription-based
- Preserve content access settings when replacing PDF files

## Exam Management

- Create and manage online exams
- Add and organize exam questions
- Control exam duration and availability
- Monitor exam participants
- Review general exam results
- Review individual student results

## Live Sessions

- Create and manage live sessions
- Assign sessions to specific academic grades
- Update meeting platforms and session links
- Control live-session availability

## Notifications

- Send push notifications to students
- Announce new lessons and educational materials
- Send exam and live-session reminders
- Publish important announcements
- Notify students about application updates

## Application Updates

- Manage the latest Android and iOS versions
- Manage Android and iOS build numbers
- Configure optional updates
- Enable forced updates when required
- Manage application store URLs

## Authentication and Local Storage

- Administrator authentication using Firebase Authentication
- Flutter Secure Storage for sensitive local data
- SharedPreferences for local application preferences
- HTTPS communication with Firebase services

## Database and Storage

- Cloud Firestore for students, grades, lessons, study notes, exams, results, live sessions, and application settings
- Firebase Storage for educational files and media
- Firebase Authentication for account credentials
- Cloud Functions for server-side operations

## Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Functions
- Firebase Cloud Messaging
- Bloc / Cubit
- GetIt
- Flutter Secure Storage
- SharedPreferences
- Clean Architecture

## Architecture

The application follows Clean Architecture principles, separating each feature into three main layers:

- **Data:** Data sources, models, and repository implementations
- **Domain:** Entities, repository contracts, parameters, and use cases
- **Presentation:** Screens, widgets, and state management

## Platforms

- Android
- iOS

Current CI/CD distribution workflows target Android.

## CI/CD

GitHub Actions handles code validation and build distribution. Fastlane builds signed Android APKs and distributes them through Firebase App Distribution.

| Workflow | Trigger | Purpose | Status |
| --- | --- | --- | --- |
| Development CI | Pull requests targeting `development` | Run static analysis and automated tests | Implemented |
| Development Distribution | Manual dispatch on `development` | Build and distribute an Android APK to the development team and testers | Implemented |
| Client Distribution | Pull requests from `development` targeting `main` | Build and distribute an Android APK to the client | Implemented |

### Development CI

Runs when a pull request is opened, updated, or reopened against `development`, regardless of its source branch.

The workflow:

- Sets up the Flutter environment
- Installs project dependencies
- Runs static analysis
- Runs automated tests
- Reports validation results on the pull request

### Development Distribution

Runs manually on the `development` branch.

The workflow:

- Sets up the Flutter and Fastlane environments
- Installs project dependencies
- Builds a signed Android APK using Fastlane
- Uploads the APK to Firebase App Distribution
- Distributes the build to the development team and testers

### Client Distribution

Runs when a pull request is opened, updated, or reopened from `development` to `main`.

The workflow:

- Sets up the Flutter and Fastlane environments
- Installs project dependencies
- Builds a signed Android APK using Fastlane
- Uploads the APK to Firebase App Distribution
- Distributes the build to the client

Workflow files are located in `.github/workflows/`. Distribution lanes are defined in `android/fastlane/Fastfile`.

Signing credentials and Firebase service account credentials are stored in GitHub Actions Secrets.

## Related Application

This administration application manages the content and data displayed in the **Al-Waleed Student Application**.

## Development

Developed by **Eyad Waleed**  
© 2026 Fame X. All rights reserved.
