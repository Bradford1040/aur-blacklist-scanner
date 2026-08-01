#!/usr/bin/env fish

set clean_file /tmp/clean-blacklist.txt
set threat_url "https://raw.githubusercontent.com/Bradford1040/aur-blacklist-scanner/main/aur-blacklist.txt"

echo "Fetching latest threat list from database..."
curl -sL $threat_url | tr -d '\r' | tr -d ' ' >$clean_file

set infected 0
for pkg in (pacman -Qmq)
    if grep -q -x "$pkg" $clean_file
        set_color red
        echo "[!] CRITICAL: Compromised package found on system: $pkg"
        set_color normal
        # This triggers the Plasma notification popup
        notify-send -u critical "AUR Security Alert" "Compromised package detected: $pkg"
        set infected (math $infected + 1)
    end
end

if test $infected -eq 0
    set_color green
    echo "[✓] System clear. No packages from the blacklist are installed."
    set_color normal
end

rm $clean_file
