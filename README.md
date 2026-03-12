# SRT
Snapper BTRFS snapshot restore tool. SRT features an easy to use text user interface (based upon dialog) to select the snapshot you wish to restore with rsync.

SRT uses xmlstarlet to parse Snapper's snapshot info.xml files to build the snapper snapshot selection menu for the home directory you run the script within.

You should copy srt.sh into and run it from $HOME/.snapshots or one of its sub directories.

Quit any browsers and stop any other running programs before running this script locally.

You do not need to have root permissions to run SRT.
