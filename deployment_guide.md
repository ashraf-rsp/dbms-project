# Deployment Automation Guide: What, Why, and How

This document explains the automated deployment process we set up for the Academic Center web application.

## What We Did (The Goal)

We created a one-command script, `deploy.sh`, that automatically copies your web application files from your project directory to the live Tomcat server directory.

## Why We Did It (The Problem)

Previously, deploying your application required manually copying files and folders. This manual process was:

- **Slow and Tedious:** It required multiple steps and navigating between different directories.
- **Error-Prone:** It was easy to forget a file or copy files to the wrong location.
- **Inefficient:** It slowed down the development cycle, as testing any small change was a hassle.

The new automated script solves these problems by providing a **fast, reliable, and repeatable** deployment method.

## How It Works (The Solution)

The solution involves a powerful command-line tool (`rsync`) and a custom shell script (`deploy.sh`), while working around a specific Android permission issue.

### 1. The Core Tool: `rsync`

We chose the `rsync` (Remote Sync) utility because it's extremely efficient at synchronizing directories. The command we use is:

`rsync -av --delete [SOURCE] [DESTINATION]`

- `-a` (archive): A magic flag that recursively copies files and preserves important attributes like permissions and timestamps.
- `-v` (verbose): Shows you which files are being copied.
- `--delete`: This is crucial. It deletes any files in the destination directory that you have deleted from your source project directory, ensuring the deployed version is an exact mirror.

### 2. The Permission Workaround

- **The Problem:** Android's security model prevents changing file permissions on the shared storage (`/storage/emulated/0/...`). This means we couldn't make a script executable (`chmod +x`) in your project folder.
- **The Solution:** We place the `deploy.sh` script in your Termux home directory (`~`), which has a standard filesystem where `chmod` works perfectly.

### 3. The Script: `~/deploy.sh`

We created the script `deploy.sh` in your home directory. Here is what it does when you run it:

1.  It defines the source (`/storage/emulated/0/LearnTmx/IUS/DBMS/academic-center/webapp/`) and destination (`.../tomcat/webapps/academic-center/`) directories.
2.  It ensures the destination directory exists.
3.  It runs the `rsync` command to synchronize your project to the Tomcat server.

---

## How to Use It

Whenever you make changes to the files in your `webapp` directory, simply open a new terminal and run this single command:

```bash
~/deploy.sh
```

This will instantly update the application running on your Tomcat server.
