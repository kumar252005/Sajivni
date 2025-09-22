The Technology Behind Sanjivni: A Resilient and Accessible Healthcare Platform

Sanjivni is more than just an application—it’s a technology-driven healthcare delivery model designed to tackle the infrastructural challenges of rural India. Its technical architecture is built on a resilient, hybrid foundation, combining offline-first capabilities with a robust cloud backend to ensure uninterrupted service even in areas with limited or intermittent internet connectivity. The core objective of the Sanjivni tech stack is to remain reliable, secure, and accessible for all users.

Frontend and User Interface
Local Health Nodes (LHNs)

A dedicated Android mobile application serves the needs of the Sanjivni Sahayak (community health assistant).

Developed using Flutter, a cross-platform framework, the app provides a smooth and consistent user experience across low-cost Android devices.

Offline-first design:

Patient vitals and symptoms are collected and stored locally in a lightweight SQLite database.

When internet connectivity becomes available (even briefly), data is automatically synchronized with the central cloud server.

Doctors and Specialists

A responsive web portal is available for doctors, accessible from any device with a modern web browser.

Key features include:

A clear patient queue with priority indicators.

Access to pre-recorded vitals and medical history.

A streamlined, easy-to-use consultation interface.

This bifurcated design ensures both local accessibility in villages and seamless expert consultation remotely.

Running the Flutter Application (For Developers)

If you’ve cloned the Sanjivni Flutter app from GitHub, follow these steps to set it up and run it on your system.

Prerequisites

Before starting, ensure you have:

Git – version control to clone repositories.

Flutter SDK – the toolkit for building and running Flutter applications.

An IDE – such as Visual Studio Code or Android Studio, with the Flutter and Dart plugins installed.

Step-by-Step Setup Guide

Find the Repository URL

Go to the project’s GitHub page.

Click the green “<> Code” button.

Copy the HTTPS URL of the repository.

Clone the Repository
Open your terminal/command prompt, navigate to your desired folder, and run:

git clone [repository-URL]


Navigate to the Project Directory

cd [name-of-the-cloned-repository]


Install Dependencies
Download all required Flutter packages listed in pubspec.yaml:

flutter pub get


Check Your Environment
Run Flutter’s environment check to verify everything is configured properly:

flutter doctor


Run the Application

Connect an Android device via USB or start an emulator.

Run the project:

flutter run


This will build and install the app on your connected device, enabling you to test the Sanjivni application.

✅ With this setup, you’ll be able to explore Sanjivni’s technology stack firsthand and understand how it bridges the gap between rural communities and quality healthcare.
<img width="449" height="863" alt="Screenshot 2025-09-22 220819" src="https://github.com/user-attachments/assets/b9b4bc18-1ccc-4a49-8f81-15e409baa93b" />

