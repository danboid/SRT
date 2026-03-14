# SRT

SRT is the [Snapper](http://snapper.io/) Snapshot Restoration Tool.

I was unable to find a program for snapper that made it easy to restore all of a users home directory to a previous state. SRT funtions a bit like `zfs rollback`, reverting all files to how they were as per a defined snapshot. ZFS has snapshots of datasets whereas BTRFS has snapshots of subvolumes.

Running SRT is dangerous! All files created since the chosen snapshot will be deleted. Use the Dry Run mode to preview what files would be deleted if you restore to the chosen snapshots state. srt provides a text interface to easily choose a snapper home directory snapshot to revert to.

Quit any browsers and stop any other running programs before running this script locally.

You do not need to have root permissions to run SRT. It requires that your user has read access to their own ~/.snapshots directory.

## Snapper config

This tool cannot work without the following snapper configuration.

This script presumes your users snapper config name matches the (Linux) user name.

```
chown root:USERS_GID /home/USER/.snapshots/
chmod g+rx /home/USER/.snapshots/
```

You would need to replace USERS_GID with your Linux users GID and USER with your username. You can find your users GID by running the `id` command.

Your user needs permission to run the snapper tool to list the snapshots date and time:

```
snapper -c USER set-config ALLOW_USERS=USER
```

Here you replace USER with your user name to enable your user to be able to query snapper for snapshot info.
