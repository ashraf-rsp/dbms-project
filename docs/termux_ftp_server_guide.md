# Guide: Setting up Termux as an FTP Server

This guide details how to configure your Android device (via Termux) to act as an FTP server, allowing your Windows PC (or other FTP clients) to connect and transfer files.

## Termux System Context (from fastfetch)

For reference, here's a snapshot of the Termux environment this guide is based on:

```
OS: Android REL 13 aarch64
Host: itel P663LN
Kernel: Linux 5.4.210-android12-9-g20d7c7c42370-ab224
Uptime: 28 days, 20 hours, 26 mins
Packages: 449 (dpkg)
Shell: bash 5.3.0
WM: Window Manager
Terminal: MainThread
CPU: 2 x T606 (8) @ 1.61 GHz
GPU: Mesa llvmpipe (LLVM 20.1.4, 128 bits)
Memory: 4.79 GiB / 7.59 GiB (63%)
Swap: 2.53 GiB / 4.17 GiB (61%)
Disk (/): 1.67 GiB / 1.67 GiB (100%) - erofs [Read-only]
Disk (/storage/emulated): 78.22 GiB / 230.83 GiB (34%) - fuse
Local IP (wlan0): 192.168.0.164/24
Battery: 83% [Discharging]
Locale: en_US.UTF-8
```

---

### **Part 1: Set up FTP Server in Termux (Android)**

We'll use `proftpd` as it's a common and relatively easy-to-configure FTP server for Linux-like environments.

1.  **Open Termux.**

2.  **Install `proftpd`:**
    ```bash
    pkg install proftpd
    ```

3.  **Configure `proftpd`:**
    *   The main configuration file is usually located at `etc/proftpd.conf` within your Termux prefix.
    *   You'll need to edit this file. Use a text editor like `nano`:
        ```bash
        nano $PREFIX/etc/proftpd.conf
        ```
    *   **Basic Configuration Edits:**
        *   **ServerName:** You can change this to something descriptive (e.g., `ServerName "Termux FTP Server"`).
        *   **Port:** Keep it at `21` for standard FTP.
        *   **User/Group:** `proftpd` usually runs as `nobody` by default. You might want to change this to your Termux user for easier file access.
            *   Find the lines:
                ```
                User nobody
                Group nogroup
                ```
            *   Change them to your Termux username and group (which is usually the same as your username).
                ```
                User <your_termux_username>
                Group <your_termux_username>
                ```
        *   **DefaultRoot:** This defines the directory users land in after logging in. By default, it's often `/data/data/com.termux/files/home`. You can change it to a specific directory you want to share, e.g., `/sdcard/FTP_Share` (if you have storage permissions set up for Termux).
            *   Find the line:
                ```
                # DefaultRoot                     ~
                ```
            *   Uncomment it and set your desired path. For example, to share your Termux home directory:
                ```
                DefaultRoot                     ~
                ```
            *   Or to share a specific folder on your SD card (ensure Termux has storage permission):
                ```
                DefaultRoot                     /sdcard/FTP_Share
                ```
        *   **Passive Ports:** This is crucial for connections through NAT/firewalls.
            *   Add these lines (or uncomment and modify existing ones) to define a passive port range:
                ```
                PassivePorts 50000 50100
                ```
        *   **Allowing your Termux user to log in:**
            *   By default, `proftpd` might not allow system users to log in directly. You might need to add a line like this to allow your Termux user:
                ```
                AuthUserFile /dev/null
                AuthGroupFile /dev/null
                AuthOrder mod_auth_unix.c
                ```
                (This tells `proftpd` to use the system's user authentication, which Termux users are part of).
        *   Save the file (`Ctrl+X`, then `Y`, then `Enter` in nano).

4.  **Set a Password for your Termux User:**
    *   If you haven't already, set a password for your Termux user (the one you used in `proftpd.conf`):
        ```bash
        passwd
        ```
        Follow the prompts to set your password.

5.  **Start the `proftpd` server:**
    ```bash
    proftpd
    ```
    If there are no errors, the server should be running. You won't see a prompt; it runs in the foreground. To run it in the background, you can use `proftpd &`.

6.  **Find Termux's IP Address:**
    *   Open a *new* Termux session (or use `Ctrl+Z` to background `proftpd` and then `bg` to continue it, then `fg` to bring it back to foreground if needed).
    *   Type:
        ```bash
        ifconfig
        ```
        Look for your Wi-Fi interface (usually `wlan0` or similar) and find the `inet addr` or `inet` address. This is your Termux device's local IP address (e.g., `192.168.0.164` from your fastfetch output).

---

### **Part 2: Connect from Windows (FTP Client)**

1.  **On your Windows PC, you can use:**
    *   **File Explorer:** Open File Explorer and type `ftp://<TERMUX_IP_ADDRESS>` in the address bar (e.g., `ftp://192.168.0.164`). It will prompt for username and password.
    *   **Web Browser:** Some browsers support `ftp://` links, but many modern browsers have removed or limited FTP support.
    *   **FileZilla Client:** (Recommended for full functionality)
        *   Download and install "FileZilla Client" from `https://filezilla-project.org/`.
        *   Open FileZilla Client.
        *   In the "Quickconnect" bar at the top:
            *   **Host:** `<TERMUX_IP_ADDRESS>` (e.g., `192.168.0.164`)
            *   **Username:** Your Termux username
            *   **Password:** Your Termux password
            *   **Port:** `21`
        *   Click `Quickconnect`.

---

**Important Considerations:**

*   **Termux Storage Permissions:** If you set `DefaultRoot` to an external storage path (like `/sdcard/`), ensure Termux has storage permissions granted in Android settings.
*   **Android Battery Optimization:** Android might kill background processes like `proftpd` to save battery. You might need to disable battery optimization for Termux in your Android settings.
*   **Security:** Again, standard FTP is unencrypted. For secure transfers, it's highly recommended to use **SFTP**. Termux comes with an SSH server (`sshd`) built-in, which supports SFTP. You can start it with `sshd` and connect from Windows using an SFTP client (like FileZilla Client, selecting SFTP protocol). This is generally a much safer approach.
