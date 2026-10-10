# Al-Waleed Admin

Al-Waleed Admin is a secure administration application designed to manage the students, educational content, exams, results, live sessions, notifications, and application settings of the Al-Waleed platform.

## Features

- Secure administrator authentication
- Student account management
- Grade-based student organization
- Educational lesson management
- Video and PDF material management
- Online exam and question management
- Student exam-results monitoring
- Individual student performance tracking
- Live-session management
- Push-notification management
- Application version and update management
- Network connection monitoring

## Student Management

- View registered students
- Organize students by academic grade
- Access individual student details
- Review student exam history
- Monitor student results and performance

## Content Management

- Add and manage educational lessons
- Attach educational videos
- Upload and manage PDF materials
- Organize content by academic grade
- Control content availability for students

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

## Security

- Secure administrator authentication using Firebase Authentication
- Protected local data using Flutter Secure Storage
- Restricted access to administrative features
- Secure communication with Firebase services
- Firestore Security Rules for protecting application data

## Database and Storage

- Cloud Firestore for students, lessons, exams, results, and application settings
- Firebase Storage for educational files and media
- Flutter Secure Storage for sensitive local data
- SharedPreferences for local application preferences

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

The application follows Clean Architecture principles and separates each feature into three main layers:

- Data
- Domain
- Presentation

This structure improves maintainability, scalability, and separation of responsibilities.

## Platforms

- Android
- iOS

## CI/CD

Three GitHub Actions workflows are planned for code validation, development distribution, and client delivery. Build distribution will use **Fastlane** and **Firebase App Distribution**.

| Workflow | Trigger | Purpose | Status |
|----------|---------|---------|--------|
| Development CI | Any pull request from any branch targeting `development` | Run static analysis and automated tests to validate the proposed changes | Planned |
| Development Distribution | Manual trigger on `development` | Use Fastlane to build and upload an Android APK to Firebase App Distribution for the development team and testers | Planned |
| Client Distribution | A pull request from `development` targeting `main` | Use Fastlane to build and upload an Android APK to Firebase App Distribution for the client | Planned |

### Development CI

This workflow will run automatically when a pull request is opened, updated, or reopened against the `development` branch, regardless of its source branch.

It will:

- Set up the Flutter environment
- Install project dependencies
- Run static analysis
- Run automated tests
- Report validation results on the pull request

### Development Distribution

This workflow will run manually on the `development` branch.

It will:

- Set up the Flutter and Fastlane environments
- Install project dependencies
- Build a signed Android APK using Fastlane
- Upload the APK to Firebase App Distribution
- Distribute the build to the development team and testers

### Client Distribution

This workflow will run automatically when a pull request is opened, updated, or reopened from `development` to `main`.

It will:

- Set up the Flutter and Fastlane environments
- Install project dependencies
- Build a signed Android APK using Fastlane
- Upload the APK to Firebase App Distribution
- Distribute the build to the client

Signing credentials and Firebase service account credentials will be managed securely using **GitHub Actions Secrets**.

## Related Application

This administration application manages the content and data displayed in the **Al-Waleed Student Application**.

## Development

Developed by **Eyad Waleed**  
© 2026 Fame X. All rights reserved.
