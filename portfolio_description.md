# Developer Portfolio Project Description: Hero Resume Builder

Below are two formats (detailed and short) that you can copy and paste directly into your developer portfolio website.

---

## Format 1: Bulleted Executive Summary (Recommended for resume/case-study section)

### **Hero Resume Builder** — *Interactive Cross-Platform Web Application*

**Project Overview:**
Designed and built a modern, offline-first Resume Builder web application using Flutter and Material 3. The application empowers users to construct professional resumes, preview them dynamically on a live simulated A4 sheet, and download them as high-quality, print-ready PDFs. 

* **State Architecture**: Developed a custom offline state architecture with clean change-propagation, ensuring real-time WYSIWYG previews as the user types without lag or cursor focus losses.
* **Responsive Layouts**: Engineered a layout system that shifts between a dual-pane split editor/preview interface on desktop and a mobile-optimized tabbed experience.
* **Offline Privacy**: Built to run entirely client-side. The image uploading (profile photo), form data storage, and PDF generation processes operate locally in the browser memory for maximum data security.
* **Rich Styling & Theme Engine**: Configured custom light/dark theme systems using standard Material 3 seeds centered around a primary orange aesthetic (`#FF6B00`).
* **PDF Compilation**: Integrated low-level canvas drawer APIs (`pdf` package) to generate print-compliant PDF files mirroring the visual live preview, featuring a custom font-fallback engine to support offline executions.

**Tech Stack Highlights:**
* **Frontend Core**: Flutter Web, Dart
* **Design & Typography**: Material 3, Google Fonts (Outfit, Inter)
* **Libraries**: `pdf`, `printing`, `image_picker`, `url_launcher`
* **Deployment & Hosting**: Vercel (Static Hosting CDN)

---

## Format 2: Short Synopsis (Recommended for thumbnail grids / summary cards)

### **Hero Resume Builder**
A high-fidelity, offline-first Flutter Web application built using Dart and Material 3. Centered around a vibrant orange palette, this tool allows developers and professionals to enter details, upload profile photos, and see them updated instantly in a real-time visual preview. Built entirely client-side, the app executes all data validations and compiles professional, print-ready PDF formats locally in the browser, ensuring 100% user data privacy. Deployed instantly on Vercel with structured routing rules.
