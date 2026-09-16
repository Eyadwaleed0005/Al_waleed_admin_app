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

## Related Application

This administration application manages the content and data displayed in the **Al-Waleed Student Application**.

## Development

Developed by **Eyad Waleed**  
© 2026 Fame X. All rights reserved.
