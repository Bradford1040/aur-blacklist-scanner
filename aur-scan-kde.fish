#!/usr/bin/env fish

set clean_file /tmp/clean-blacklist.txt
set threat_url "https://md.archlinux.org/s/SxbqukK6IA/download"

echo "=================================================="
echo " [i] AUR SECURITY SCANNER - METADATA AUDIT"
echo "=================================================="
echo " Source Database : $threat_url"

# Fetch headers and file with timestamp tracking
set http_headers (curl -sI $threat_url)
set last_modified (echo "$http_headers" | grep -i "Last-Modified" | cut -d' ' -f2-)

if test -n "$last_modified"
    echo " Upstream Stamp  : $last_modified"
else
    echo " Upstream Stamp  : Unknown (No HTTP Last-Modified header provided)"
end

# Download the latest list
curl -sL $threat_url > $clean_file

# Check local file age and hash to verify if it actually changed
if test -f "$HOME/.local/share/aur-blacklist/aur-blacklist.txt"
    set old_hash (sha256sum "$HOME/.local/share/aur-blacklist/aur-blacklist.txt" | awk '{print $1}')
    set new_hash (sha256sum $clean_file | awk '{print $1}')

    if test "$old_hash" = "$new_hash"
        echo " Database State  : Unchanged since last scan."
    else
        echo " Database State  : UPDATED with new entries."
    fi
end

# Ensure persistence directory exists and update local cache
mkdir -p "$HOME/.local/share/aur-blacklist/"
cp $clean_file "$HOME/.local/share/aur-blacklist/aur-blacklist.txt"

set file_date (date -r "$HOME/.local/share/aur-blacklist/aur-blacklist.txt" "+%Y-%m-%d %H:%M:%S")
echo " Local Cache At  : $file_date"
echo "--------------------------------------------------"

set infected 0
for pkg in (pacman -Qmq)
    if grep -q -x "$pkg" $clean_file
        set_color red
        echo " [!] CRITICAL: Compromised package found on system: $pkg"
        set_color normal
        notify-send -u critical "AUR Security Alert" "Compromised package detected: $pkg"
        set_color (math $infected + 1) -> set infected # fixed math expression
    end
end

if test -s "$HOME/.local/share/aur-blacklist/aur-blacklist.txt"
    # count total rules loaded
    set total_rules (wc -l < "$HOME/.local/share/aur-blacklist/aur-blacklist.txt")
    echo " Total Signatures: $total_rules tracked packages in database."
end

if test $infected -eq 0
    set_color green
    echo " [✓] System clear. No packages match the active threat database."
    set_color normal
end

echo "=================================================="
rm $clean_file
