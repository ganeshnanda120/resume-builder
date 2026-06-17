# Hero Resume Builder

A beautiful, modern, and production-ready Flutter web application that enables users to create and customize professional resumes completely free and 100% offline. 

## 🚀 Key Features

* **Real-time Live Preview**: See your resume update instantly on a visual A4 sheet preview as you fill in details.
* **Offline First**: Runs completely in the browser. Your personal data never leaves your device (guaranteeing maximum privacy).
* **Modern orange UI Theme**: Styled using the Material 3 design system with a clean, responsive layout.
* **Responsive Layout**: Fluid UI optimized for both desktop and mobile devices.
* **Rich Sections Support**:
  * Personal information (with optional profile picture upload)
  * Work experience (with dynamic add/remove/edit cards)
  * Education details
  * Technical projects (with repository/live links)
  * Skill categories and tags
  * Certifications
  * Languages
  * Achievements
  * Social links
* **High-Quality PDF Exports**: Generates styled, print-ready PDFs at the click of a button.
* **Dark / Light Mode**: Toggles seamlessly between light and dark visual aesthetics.
* **Instant Sample Data**: Single-click "Sample Data" button to pre-fill the form with a structured resume, letting you see the design immediately.

---

## 🛠️ Tech Stack

* **Framework**: Flutter (Web platform)
* **Language**: Dart
* **Design System**: Material 3
* **Typography**: Google Fonts (Outfit / Inter)
* **Packages**:
  * `pdf` - Custom document styling and page generation.
  * `printing` - Interactive layout, printing, and file downloads.
  * `image_picker` - Web-compatible file browser.
  * `url_launcher` - Secure external website navigation.

---

## 📸 Screenshots

> [!TIP]
> Add screenshots of the desktop split-pane UI and the responsive mobile tabs here!

*Desktop Live Editor & A4 Sheet Preview:*
```
+-----------------------------------------------------------+
|  [Logo] Hero Resume              [Light/Dark] [Download]  |
+-----------------------------+-----------------------------+
|                             |                             |
|  * Personal Info            |       ALEX MORGAN           |
|  * Work Experience          |     Lead Flutter Dev        |
|  * Education                |  -------------------------  |
|  * Projects                 |  Summary: Innovative...     |
|  * Technical Skills         |                             |
|                             |  Experience:                |
|                             |  - Digital Heroes Co.       |
|                             |                             |
+-----------------------------+-----------------------------+
| Built for Digital Heroes    |  Full Name: YOUR FULL NAME  |
+-----------------------------+-----------------------------+
```

---

## 🔧 Installation & Running Locally

### Prerequisites

Ensure you have the Flutter SDK installed on your machine. To verify, run:
```bash
flutter doctor
```

### Steps to Run

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/resume-builder-app.git
   cd resume-builder-app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the local development server:**
   ```bash
   flutter run -d chrome
   ```
   This compiles the project and opens the app at `http://localhost:XXXX/`.

---

## ☁️ Deployment to Vercel Free Plan

Vercel makes it incredibly easy to deploy static frontends. Follow these steps to host your Resume Builder for free:

### 1. Build the Flutter Web App
Compile the project to release-grade HTML/JS/CSS assets:
```bash
flutter build web --release
```
This builds all required assets into the `build/web` directory.

### 2. Configure Vercel Deployment

There are two primary methods to deploy the app:

#### Method A: Using Vercel CLI (Recommended)
1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```
2. Navigate to the root directory and run the deployment:
   ```bash
   vercel
   ```
3. Set the build parameters during CLI setup:
   * **Link to existing project?** No
   * **Which directory?** `.` (current folder)
   * **Want to override settings?** Yes, set the **Output Directory** to `build/web`.
4. Deploy to production:
   ```bash
   vercel --prod
   ```

#### Method B: Deploying via GitHub Git Integration
1. Push your code to a GitHub repository.
2. Log into the Vercel Dashboard and click **Add New Project**.
3. Import your GitHub repository.
4. In the **Build and Development Settings**:
   * **Build Command**: `flutter/bin/flutter build web --release` (or leave empty if committing pre-built `build/web`).
   * **Output Directory**: `build/web`
5. Click **Deploy**.

---

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
