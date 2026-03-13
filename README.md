# SRT
Snapper BTRFS snapshot restore tool. SRT features an easy to use text user interface (based upon dialog) to select the snapshot you wish to restore with rsync.

Quit any browsers and stop any other running programs before running this script locally.

You do not need to have root permissions to run SRT.

## Snapper config

This tool cannot work without the following snapper configuration.

This script presumes your users snapper config matches the user name.

It also requires that your users ~/.snapshots directory has the same GID as your user and that your users groups can read the .snapshots dir:

```
chown root:USERS_GID /home/USER/.snapshots/
chmod g+rx /home/USER/.snapshots/
```

You can find your users GID by running the `id` command.

Your user must have permission to run the snapper tool in order to list the snapshots and their info:

```
snapper -c USER set-config ALLOW_USERS=USER
```
