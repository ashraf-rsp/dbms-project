# How IP Addresses Work on Your Local Network

This note explains why you can access your development server using multiple IP addresses like `127.0.0.1` and `192.168.x.x`.

Think of your phone as a house and your running application as a person inside waiting for visitors at a specific door (e.g., port `8080`). This house has several different addresses.

---

### 1. The Loopback Address: `127.0.0.1` (or `localhost`)

-   **What it is:** A special, universal address that **always means "this device"**.
-   **How it works:** When you access `http://127.0.0.1:8080`, the request is handled internally by your phone and never touches the Wi-Fi network.
-   **Analogy:** Leaving a note for yourself on your own refrigerator. The message never leaves the house.

---

### 2. The Private IP Address: `192.168.x.x` or `10.x.x.x`

-   **What it is:** A **local address** assigned to your phone by your Wi-Fi router. It's only visible to other devices on the **same Wi-Fi network**.
-   **How it works:** Other devices on your Wi-Fi can use this address to connect to your phone. The router directs the traffic.
-   **Analogy:** Your street address (e.g., "123 Main Street"). Only people in your local neighborhood (the Wi-Fi network) can use it to find your house.

---

### The Magic: Why They All Work at Once

When a development server starts, it usually "binds" to the special address `0.0.0.0`.

- **`0.0.0.0` means "listen for connections on all available network interfaces."**

Your application is waiting for visitors at every "door" your phone has: the internal loopback door (`127.0.0.1`) and the local Wi-Fi door (`192.168.x.x`). This is why you can connect using either address.

---

### How to Find Your Phone's Private IP

To access your server from another device on your Wi-Fi (like a PC), you need your phone's private IP address. The standard `ip addr` command may fail with "Permission denied" on Android. Here are the correct ways to find it:

#### Method 1: The Termux API (Recommended)

This is the best command-line method.

1.  **Install the API tools** (if you haven't already):
    ```bash
    pkg install termux-api
    ```
    *(You also need the separate "Termux:API" app installed on your phone from F-Droid or the Play Store).*

2.  **Run the command:**
    ```bash
    termux-wifi-connectioninfo
    ```

3.  **Find the `"ip"` value** in the JSON output.

#### Method 2: The Android GUI (Guaranteed)

This method always works.

1.  On your phone, go to **Settings** > **Network & internet** > **Wi-Fi**.
2.  Tap the gear icon ⚙️ next to your currently connected Wi-Fi network.
3.  Your **IP address** will be listed in the network details.