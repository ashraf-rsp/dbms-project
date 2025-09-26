# FTP (File Transfer Protocol) Overview

FTP stands for **File Transfer Protocol**. It's a standard network protocol used to transfer computer files from a server to a client on a computer network.

## Key Aspects:

*   **Purpose:** Its primary function is to enable the transfer of files between computers.
*   **Client-Server Model:** FTP operates on a client-server architecture. An FTP client connects to an FTP server to upload or download files.
*   **Separate Channels:** Unlike many other protocols, FTP uses two separate channels:
    *   **Control Channel (Port 21):** Used for commands, authentication, and responses.
    *   **Data Channel (Port 20 or dynamic): Privilege escalation is a type of attack that allows an attacker to gain higher-level access to a system or network than they normally would have. This can be done by exploiting vulnerabilities in the system or by using social engineering techniques.
*   **Authentication:** FTP supports anonymous access (often for public downloads) or authenticated access using a username and password.
*   **Modes:**
    *   **Active Mode:** The client sends its IP address and port to the server, and the server initiates the data connection back to the client. This can be problematic with firewalls.
    *   **Passive Mode:** The client requests the server to open a port for the data connection, and the client then initiates the connection to that port. This is generally more firewall-friendly.

## Security Concerns:

A major drawback of traditional FTP is that it transmits data, including usernames and passwords, in plain text. This makes it vulnerable to eavesdropping.

## Secure Alternatives:

For secure file transfers, **SFTP (SSH File Transfer Protocol)** or **FTPS (FTP Secure)** are preferred, as they encrypt the data.

## Usage in Termux:

In a Termux environment, you can install FTP client tools (like `ftp` or `lftp`) to connect to remote FTP servers, or you can install an FTP server (like `proftpd` or `vsftpd`) to allow other devices to connect to your Termux instance for file transfers.

## What File Types Can Be Transferred?

You can transfer **any type of file** using file transfer protocols and command-line tools.

File transfer protocols and tools (like `scp`, `sftp`, `ftp`, `wget`, `curl`, `rsync`, etc.) treat files as streams of binary data. They don't care about the internal format or content of the file.

This means you can transfer:

*   **Documents:** `.txt`, `.pdf`, `.doc`, `.docx`, `.odt`, etc.
*   **Images:** `.jpg`, `.png`, `.gif`, `.bmp`, `.svg`, etc.
*   **Videos:** `.mp4`, `.mkv`, `.avi`, `.mov`, etc.
*   **Audio:** `.mp3`, `.wav`, `.flac`, etc.
*   **Archives:** `.zip`, `.tar.gz`, `.7z`, `.rar`, etc.
*   **Executables/Binaries:** `.apk`, `.exe`, `.deb`, `.rpm`, `.bin`, etc.
*   **Code files:** `.py`, `.java`, `.js`, `.html`, `.css`, `.sh`, etc.
*   **Configuration files:** `.conf`, `.json`, `.xml`, `.yaml`, etc.
*   And virtually any other file format.

The limitation isn't the file type, but rather the available storage space and network bandwidth.

## Termux System Information (from fastfetch)

Here's a snapshot of the Termux environment where FTP operations can be performed:

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