# 🍎 macOS Minecraft Plugin Builder

A streamlined script to build **Minecraft plugins** on macOS with support for both Java (Maven) and JavaScript (NPM) projects.

## ✨ Features

- **One-command setup** for plugin development environment
- Automatic installation of:
  - **Homebrew** (if missing)
  - **Maven** (for Java plugins)
  - **Node.js** (for JavaScript plugins)
- Supports both:
  - 🟨 **Maven projects** (`pom.xml` based)
  - 🟦 **NPM projects** (`package.json` based)
- Places built artifacts directly on your **Desktop**

## 🛠️ How It Works

1. **Prepares your system** by installing necessary tools
2. **Locates your plugin project** on Desktop (interactive selection)
3. **Builds using your preferred method**:
   - For Java: `mvn clean package` → produces `.jar` file
   - For JS: `npm install && npm run build` → produces `dist` folder
4. **Outputs results** to your Desktop for easy access

## 📦 Requirements

- macOS (Intel/Apple Silicon)
- Terminal access
- Plugin project folder placed on Desktop
- For Java plugins: `pom.xml` file
- For JS plugins: `package.json` file

## 🚀 Quick Start

```bash
# 1. Download and move to your desktop

# 2. Grant execution rights
cd Desktop
chmod 755 plugintool.sh

# 3. Run it! Drag the file from your desktop to the terminal and press enter
