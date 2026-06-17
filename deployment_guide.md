# Deployment Guide: Flutter Web on Vercel

This guide provides step-by-step instructions for deploying your Resume Builder Flutter web application to the **Vercel Free Plan**.

---

## Technical Overview
Flutter Web compiles Dart code into standard static files (HTML, JS, CSS, assets, web manifests) inside the `build/web` directory. Vercel acts as a global CDN hosting these static assets.

Since Vercel's build environment does not include the Flutter SDK by default, you have two primary deployment strategies:
1. **Local Build & Deploy (easiest & fastest)**: You build the project locally and upload only the static `build/web` directory to Vercel.
2. **GitHub CI/CD Build**: Configure Vercel to fetch the Flutter SDK during build time.

---

## Strategy 1: Local Build & Deploy (Recommended)

This approach ensures zero errors with Vercel build environments since the compilation is performed on your development machine where Flutter is already set up.

### Step 1: Compile the Project
In your terminal, navigate to the project directory and run:
```bash
flutter build web --release --web-renderer canvaskit
```
*Note: Using `--web-renderer canvaskit` ensures the A4 page preview, text styling, and custom elements render with high pixel-density on all browser engines.*

### Step 2: Initialize Vercel
1. Install the global Vercel CLI if you haven't already:
   ```bash
   npm install -g vercel
   ```
2. Navigate to your project folder and run:
   ```bash
   vercel
   ```

### Step 3: Configure settings during command prompt
The CLI will ask you a series of questions. Respond as follows:
* **Set up and deploy?** Yes
* **Which scope?** (Select your Vercel account)
* **Link to existing project?** No
* **What name?** `hero-resume-builder`
* **In which directory?** `.`
* **Auto-detected framework?** Other (Vercel will detect it does not match standard JS frameworks)
* **Want to modify settings?** **Yes**
  * **Output Directory**: Change this value to `build/web` (Default is usually `public` or `dist`).
  * Leave the build command and install command empty.

### Step 4: Publish to Production
Once you verify the preview deployment, promote it to production:
```bash
vercel --prod
```
Vercel will upload the `build/web` directory and provide you with a live domain (e.g. `https://hero-resume-builder.vercel.app`).

---

## Strategy 2: Automated Git Deployments with Vercel Build Pipeline

If you want Vercel to automatically rebuild your project every time you commit code to GitHub:

### Step 1: Create a Build Script
Create a simple shell script named `build.sh` at the root of the project to download Flutter, run pub get, and build web:

```bash
#!/bin/bash
# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Run doctor to verify environment
flutter doctor

# Build web release
flutter pub get
flutter build web --release --web-renderer canvaskit
```

### Step 2: Push code to Git
Commit all files, including `build.sh` and `vercel.json` to GitHub.

### Step 3: Link Project in Vercel
1. Open the Vercel Dashboard and click **Import Project**.
2. Select your GitHub repository.
3. In **Build and Development Settings**:
   * **Build Command**: `bash build.sh`
   * **Output Directory**: `build/web`
4. Click **Deploy**. Vercel will launch a container, execute the script to fetch Flutter, compile your Dart code, and host the output.
