#!/usr/bin/env bash

clean_file="/tmp/clean-blacklist.txt"
threat_url="https://md.archlinux.org/s/SxbqukK6IA/download"

echo "=================================================="
echo " [i] AUR SECURITY SCANNER - METADATA AUDIT"
echo "=================================================="
echo " Source Database : $threat_url"

# Fetch headers and file with timestamp tracking
http_headers=$(curl -sI "$threat_url")
last_modified=$(echo "$http_headers" | grep -i "Last-Modified" | cut -d' ' -f2-)

if [ -n "$last_modified" ]; then
    echo " Upstream Stamp  : $last_modified"
else
    echo " Upstream Stamp  : Unknown (No HTTP Last-Modified header provided)"
fi

# Download the latest list
curl -sL "$threat_url" > "$clean_file"

# Check local file hash to verify if it actually changed
local_cache="$HOME/.local/share/aur-blacklist/aur-blacklist.txt"
if [ -f "$local_cache" ]; then
    old_hash=$(sha256sum "$local_cache" | awk '{print $1}')
    new_hash=$(sha256sum "$clean_file" | awk '{print $1}')

    if [ "$old_hash" = "$new_hash" ]; then
        echo " Database State  : Unchanged since last scan."
    else
        echo " Database State  : UPDATED with new entries."
    fi
fi

# Ensure persistence directory exists and update local cache
mkdir -p "$(dirname "$local_cache")"
cp "$clean_file" "$local_cache"

file_date=$(date -r "$local_cache" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || date -u "+%Y-%m-%d %H:%M:%S")
echo " Local Cache At  : $file_date"
echo "--------------------------------------------------"

infected=0
for pkg in $(pacman -Qmq); do
    if grep -q -x "$pkg" "$clean_file"; then
        echo -e "\033[31m [!] CRITICAL: Compromised package found on system: $pkg\033[0m"
        notify-send -u critical "AUR Security Alert" "Compromised package detected: $pkg"
        ((infected++))
    fi
done

if [ -s "$local_cache" ]; then
    total_rules=$(wc -l < "$local_cache")
    echo " Total Signatures: $total_rules tracked packages in database."
fi

if [ $infected -eq 0 ]; then
    echo -e "\033[32m [✓] System clear. No packages match the active threat database.\033[0m"
fi

echo "=================================================="
rm -f "$clean_file"
