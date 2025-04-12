# 🖥️ motd-sys

A modern, colorful, and useful replacement for Ubuntu’s default MOTD (Message of the Day). This script displays essential system status with beautiful formatting on login or on demand.

---

## 🚀 Features

- 📅 Date, hostname, user, and public IP
- 👥 Active SSH session count
- 📥 Last login timestamp
- 🧠 CPU model and load
- 📊 RAM usage
- ⏱️ Uptime
- 📦 Disk usage (smart-mount filtering)
- 🐳 Docker container summary (name + status)
- 🌈 Color-coded output using emoji and ANSI formatting
- ✅ Installs for all users via `/opt` and `/etc/profile.d/`
- 💡 Replaces Ubuntu’s noisy default MOTD safely (non-destructive)

---

## 📦 Quick Install (Online via GitHub)

If you are connected to the internet, the fastest way is:

```bash
wget https://github.com/YOUR_USERNAME/motd-sys/raw/main/motd-sys.sh -O motd-sys.sh && chmod +x motd-sys.sh && sudo ./motd-sys.sh && source ~/.bashrc
```

> Replace `YOUR_USERNAME` with your actual GitHub username.

This will:
- Download the script
- Make it executable
- Install it system-wide in `/opt`
- Set up the `sys` alias
- Enable the login MOTD for all users

---

## 📦 Manual Install (Offline or Local File)

If you're copying the script manually:

### 1. Create a folder for scripts (optional)
```bash
mkdir -p ~/Scripts
cd ~/Scripts
```

### 2. Create the script file using nano
```bash
nano motd-sys.sh
```

### 3. Paste the content of `motd-sys.sh` and save (`CTRL+O`, `ENTER`, `CTRL+X`)

### 4. Make it executable and install:
```bash
chmod +x motd-sys.sh && sudo ./motd-sys.sh && source ~/.bashrc
```

---

## 🔧 Usage

- Type `sys` in any terminal to view system status.
- Or simply log in to your server — the dashboard will appear automatically.

---

## 📁 Sample Output

```
────────────────────────────────────────────────────────────
Welcome 🖥️  app | Ubuntu Server (6.11.0-21-generic)
────────────────────────────────────────────────────────────
📅 Date                 : Saturday, April 12, 2025 – 00:01:57
🧑 User                 : app
🖥️ Hostname             : app
🌐 Public IP            : 196.42.11.14
👥 SSH Sessions         : 1 active
📥 Last Login           : Fri Apr 11 22:51 still logged in

🧠 CPU Model            : Intel(R) Core(TM) Ultra 5 125H
⏱ Uptime               : 23 hours, 5 minutes
📊 RAM Used             : 2.3Gi / 30Gi
🧮 CPU Load             : 0%

📦 Disk Storage:
  /          : 50G used / 98G total (44G free)
  /boot      : 99M used / 2.0G total (1.7G free)

🐳 Docker Apps (11):
  - nginx-proxy-manager : Up 2 hours (healthy)
  - emby                : Up 23 hours (healthy)
  ...
────────────────────────────────────────────────────────────
```

---

## ✅ Compatibility

- Works on any Ubuntu Server or Debian-based distro with:
  - `bash`, `awk`, `curl`, and optional: `docker`

---

## 📜 Version

**v1.0.0** – First public release

---

## 👨‍🔧 Credits

Made with ❤️ by [Cristobal Ortiz Ortiz](https://github.com/)  
Want to contribute? Fork it, improve it, and open a pull request!

---

## 🪪 License

Licensed under the GNU General Public License v3.0 (GPLv3). See the LICENSE file for details.
