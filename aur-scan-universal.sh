#!/usr/bin/env bash

CLEAN_FILE="/tmp/clean-blacklist.txt"
THREAT_URL="https://raw.githubusercontent.com/Bradford1040/aur-blacklist-scanner/main/aur-blacklist.txt"

echo "Fetching latest threat list from database..."
curl -sL "$THREAT_URL" | tr -d '\r' | tr -d ' ' >"$CLEAN_FILE"

INFECTED=0
while IFS= read -r pkg; do
    if grep -q -x "$pkg" "$CLEAN_FILE"; then
        echo -e "\e[31m[!] CRITICAL: Compromised package found on system: $pkg\e[0m"
        # This triggers the Plasma notification popup
        notify-send -u critical "AUR Security Alert" "Compromised package detected: $pkg"
        INFECTED=$((INFECTED + 1))
    fi
done < <(pacman -Qmq)

if [ "$INFECTED" -eq 0 ]; then
    echo -e "\e[32m[✓] System clear. No packages from the blacklist are installed.\e[0m"
fi

rm "$CLEAN_FILE"

# Pause so the terminal window doesn't instantly vanish on non-KDE systems
echo ""
read -n 1 -s -r -p "Press any key to exit..."
