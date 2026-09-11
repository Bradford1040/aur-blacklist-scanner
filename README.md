# AUR Blacklist Scanner

[![Total](https://wakatime.com/badge/user/f18ab90b-d5ab-44a5-a771-88b32a561950/project/66e57e0f-2459-484e-b11e-f303b552324c.svg)](https://wakatime.com/badge/user/f18ab90b-d5ab-44a5-a771-88b32a561950/project/66e57e0f-2459-484e-b11e-f303b552324c)

A lightweight, automated security tool for Arch Linux and Arch-based distributions (like CachyOS or EndeavourOS). It scans your locally installed AUR packages against a live threat list of known compromised packages to protect against supply-chain attacks.

## Features

- The threat [database](https://md.archlinux.org/s/SxbqukK6IA) is automatically synchronized daily at midnight UTC from the Arch Linux community list via GitHub Actions.
- **Automated Threat Fetching:** Dynamically pulls the latest threat list directly from the repository before every scan.
- **Dual-Environment Support:**
- `aur-scan-kde`: A Fish script optimized for KDE Plasma users, utilizing Konsole and native window holds.
- `aur-scan-universal`: A POSIX-compliant Bash script for all other desktop environments (GNOME, XFCE, Hyprland, etc.).
- **Active Monitoring:** Includes a systemd user timer to run background checks automatically every 12 hours.
- **Desktop Alerts:** Triggers native desktop notifications (`notify-send`) if a compromised package is detected during a background scan.

## Support

- You can and encouraged to create and issue on GitHub but, if you
- Need or Want **Help** click the link to join [telegram group](https://t.me/JerksOfAllTrades/2) or scan QR-code below
- Here you will get 🤝 Support & 👨‍💻 Developer Contact

![Telegram_Group](./Jerks-Of-All-Trades.png "Telegram Group, Scan QR-code with Phone")

## Installation

You can build and install the package directly from source using standard Arch tooling.

```bash
# Clone the repository
git clone [https://github.com/Bradford1040/aur-blacklist-scanner.git](https://github.com/Bradford1040/aur-blacklist-scanner.git)
cd aur-blacklist-scanner

# Build and install the package
makepkg -si
```

## Manual Usage

Once installed, the tool integrates directly into your desktop environment's application launcher.

Open your launcher (Super/Meta key) and search for **AUR Blacklist Scan**.

- Select **(KDE)** if you are running KDE Plasma.

- Select **(Universal)** if you are running any other desktop environment.

## Enabling Automated Background Scans

To enable the 12-hour automated background checks, activate the included systemd user timer. The scanner will run silently and only alert you via a desktop notification if a compromised package is found.

Bash

``` ng-tns-c2185672871-280
systemctl --user enable --now aur-scanner.timer
```

To verify the timer is active and see when the next scan will run:

Bash

``` ng-tns-c2185672871-281
systemctl --user list-timers | grep aur-scanner
```

## Uninstallation

To completely remove the scanner, systemd services, and `.desktop` shortcuts from your system, disable the timer and remove the package using your AUR helper:

Bash

``` ng-tns-c2185672871-282
# Disable the background timer
systemctl --user disable --now aur-scanner.timer

# Remove the package
yay -Rns aur-blacklist-scanner-git
```
