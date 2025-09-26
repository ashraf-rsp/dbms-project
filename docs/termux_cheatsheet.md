# My Termux Cheatsheet

A collection of useful commands and concepts for developing in the Termux environment.

---

## 1. Making Scripts Executable

The standard `chmod +x` command does not work on files located in shared storage (`/storage/emulated/0/...`) due to Android's security restrictions.

- **Problem:** `chmod +x /storage/emulated/0/myscript.sh` will fail.
- **Solution:** Place your executable scripts in your Termux home directory (`~`).

**Workflow:**
1. Create your script in your project folder.
2. Copy it to your home directory: `cp /path/to/your/script.sh ~`
3. Make it executable there: `chmod +x ~/script.sh`
4. Run it from your home directory: `~/script.sh`

---

## 2. Networking

### Finding Your Phone's IP Address

Standard Linux commands like `ip addr` may fail with "Permission denied". The correct method is to use the Termux API.

1.  **Install the API tools** (if you haven't already):
    ```bash
    pkg install termux-api
    ```
    *(You also need the separate "Termux:API" app installed on your phone from F-Droid or the Play Store).*

2.  **Run the command to get connection info:**
    ```bash
    termux-wifi-connectioninfo
    ```

3.  Look for the `"ip"` value in the JSON output. This is your phone's address on the local Wi-Fi network.

### Accessing a Server from Your PC

Once you have your phone's IP address, you can access any server running on it from another device on the same Wi-Fi.

- **URL Format:** `http://<your-phone-ip>:<port>`
- **Example (Tomcat):** `http://192.168.0.164:8081/academic-center/`

---

## 3. Automating Deployment with `rsync`

Here is a template for a script (`~/deploy.sh`) that uses `rsync` to synchronize a project's `webapp` folder with a Tomcat server running in Termux.

```bash
#!/usr/bin/env bash

# Source project directory
SOURCE_DIR="/storage/emulated/0/path/to/your/project/webapp/"

# Destination Tomcat directory
DEST_DIR="~/apache-tomcat-version/webapps/your-app-name/"

echo "--- Starting Deployment ---"

# Use rsync to synchronize the files
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR"

echo "--- Deployment Finished ---"
```

---

## 4. Useful Packages

- `rsync`: For efficient file synchronization.
- `termux-api`: To access native Android device features from the command line.

---

## 5. Interacting with Android (Termux:API)

The `termux-api` package is a powerful tool that acts as a bridge, allowing your command-line scripts to interact with your phone's hardware and the Android operating system.

**Prerequisite:** You must have the `termux-api` package (`pkg install termux-api`) and the free Termux:API app from F-Droid or the Play Store installed.

Here are some of the most useful commands:

### Wi-Fi Information

- **Why it's useful:** To get network details for scripts or for accessing servers.
- **How to use:**
  ```bash
  # Get info about your current Wi-Fi connection (including your IP address)
  termux-wifi-connectioninfo

  # Get a list of all nearby Wi-Fi networks
  termux-wifi-scaninfo
  ```

### Clipboard

- **Why it's useful:** To programmatically read from or write to your phone's clipboard.
- **How to use:**
  ```bash
  # Copy text to your clipboard
  echo "Hello from Termux" | termux-clipboard-set

  # Get the current content of your clipboard
  termux-clipboard-get
  ```

### Notifications

- **Why it's useful:** To get alerts from your scripts, especially for long-running tasks.
- **How to use:**
  ```bash
  # Create a simple notification
  termux-notification --title "Task Complete" --content "Your script has finished."
  ```

### Dialog Boxes

- **Why it's useful:** To get interactive input from the user in a graphical way.
- **How to use:**
  ```bash
  # A simple confirmation box
  termux-dialog confirm -t "Run cleanup?" -i "This will delete temp files."

  # A text input box
  username=$(termux-dialog text -t "Enter your name")
  echo "Hello, $username"
  ```

### Hardware & Sensors

- **Why it's useful:** To get data from your phone's hardware.
- **How to use:**
  ```bash
  # Get current battery status
  termux-battery-status

  # Get GPS location data
  termux-location

  # Take a picture with the back camera and save it
  termux-camera-photo -c 0 my-photo.jpg
  ```

### Text-to-Speech (TTS)

- **Why it's useful:** To have your scripts provide audio feedback.
- **How to use:**
  ```bash
  # Make your phone speak
  termux-tts-speak "Hello world, I am a script."
  ```

---

## 6. Areas for Further Exploration

Termux is a full-fledged development environment. Here are some powerful features to explore beyond the basics.

### The Ultimate Upgrade: Using SSH

This is the single most impactful feature for serious work. It allows you to log into your Termux session from a PC on the same Wi-Fi network, using your computer's keyboard and monitor.

1.  **Install:** `pkg install openssh`
2.  **Set password:** `passwd`
3.  **Start server:** `sshd`
4.  **Connect from PC:** `ssh <your-username>@<your-phone-ip> -p 8022` (Termux uses port 8022).

### Advanced Command-Line Text Editing

Move beyond simple editors to code efficiently within the terminal.

-   **Neovim (`neovim`):** Extremely powerful and efficient once you learn it.
-   **Micro (`micro`):** Modern and intuitive, uses familiar keybindings like `Ctrl+S`. A great starting point.

### Expanding Your Programming Arsenal

Install compilers and interpreters for almost any language.

-   **Node.js:** `pkg install nodejs`
-   **C/C++:** `pkg install clang`
-   **Git:** `pkg install git` (essential for version control)

### Deeper Android Integration

-   **`termux-setup-storage`:** Run this once. It creates a `~/storage` directory with links to your phone's shared folders (Downloads, DCIM, etc.), making file access much easier.
-   **`termux-wake-lock`:** Use this to prevent your phone from sleeping during long-running scripts (like downloads or compilations).
-   **Termux:Widget (Add-on App):** Lets you create home screen shortcuts to run your favorite scripts.
