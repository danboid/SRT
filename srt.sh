#!/bin/bash

# SRT aka (Snapper) Snapshot Restore Tool.
# SRT makes it easy to restore user home directories from BTRFS snapshots created by Snapper using rsync and a simple TUI interface.
# SRT does not require root permission to run but it does require rsync, dialog and xmlstarlet.

# Close your web browser and any open documents before running this, if you are running it locally.

# Configuration
SNAPSHOT_DIR="$HOME/.snapshots"

# Check Dependencies
if ! command -v dialog &> /dev/null || ! command -v xmlstarlet &> /dev/null; then
    echo "This script requires 'dialog' and 'xmlstarlet'."
    echo "Install them: sudo apt install dialog xmlstarlet (Debian/Ubuntu) or sudo pacman -S dialog xmlstarlet (Arch)"
    exit 1
fi

# 1. Build the Snapshot Menu
MENU_OPTIONS=()
for dir in $(ls -1 "$SNAPSHOT_DIR" | grep -E '^[0-9]+$' | sort -nr); do
    INFO_FILE="$SNAPSHOT_DIR/$dir/info.xml"
    if [ -f "$INFO_FILE" ]; then
        DATE=$(xmlstarlet sel -t -v "//date" "$INFO_FILE" | cut -d' ' -f1,2)
        DESC=$(xmlstarlet sel -t -v "//description" "$INFO_FILE")
        [ -z "$DESC" ] && DESC="No description"
        MENU_OPTIONS+=("$dir" "[$DATE] $DESC")
    fi
done

if [ ${#MENU_OPTIONS[@]} -eq 0 ]; then
    dialog --title "Error" --msgbox "No snapshots found in $SNAPSHOT_DIR" 6 50
    exit 1
fi

# 2. Display the Selection Menu
SNAP_NUM=$(dialog --title "Select a Snapshot" \
    --menu "Choose a snapshot to manage:" 20 75 10 \
    "${MENU_OPTIONS[@]}" \
    3>&1 1>&2 2>&3)

[ $? -ne 0 ] && exit

# 3. Choose Action: Dry Run vs. Restore
ACTION=$(dialog --title "Choose Action for Snapshot #$SNAP_NUM" \
    --menu "What would you like to do?" 12 60 4 \
    "1" "Dry Run (See what will happen)" \
    "2" "RESTORE (Delete local files and restore)" \
    3>&1 1>&2 2>&3)

[ $? -ne 0 ] && exit

TARGET_PATH="$SNAPSHOT_DIR/$SNAP_NUM/snapshot"

# --- Logic for Dry Run ---
if [ "$ACTION" == "1" ]; then
    clear
    echo "--- DRY RUN: Snapshot #$SNAP_NUM ---"
    echo "The following changes WOULD be made to your home directory:"
    echo "-----------------------------------------------------------"
    # -n is --dry-run. It shows deletions and updates.
    rsync -aAXv --dry-run --delete --exclude='.snapshots' "$TARGET_PATH/" "$HOME/"
    echo "-----------------------------------------------------------"
    echo "DRY RUN COMPLETE. No files were actually changed."
    read -p "Press Enter to return to terminal."
    exit 0
fi

# --- Logic for Actual Restore ---
if [ "$ACTION" == "2" ]; then
    dialog --title "!!! FINAL WARNING !!!" --colors \
        --yesno "You are about to \ZbPERMANENTLY DELETE\Zn your current home directory files and replace them with Snapshot \Zb#$SNAP_NUM\Zn.\n\nOnly the .snapshots folder is safe.\n\nAre you 100% sure?" 15 65

    if [ $? -eq 0 ]; then
        clear
        echo "PERFORMING RESTORE: Snapshot #$SNAP_NUM"
        echo "----------------------------------------"
        rsync -aAXvh --delete --exclude='.snapshots' --info=progress2 "$TARGET_PATH/" "$HOME/"

        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            dialog --title "Success" --msgbox "Restore finished successfully." 6 45
        else
            echo "Error occurred during rsync. Check permissions."
            read -p "Press Enter to exit."
        fi
    else
        dialog --infobox "Restore cancelled." 3 30
        sleep 1
    fi
fi

clear
