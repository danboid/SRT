# SRT

SRT is the [Snapper](http://snapper.io/) Snapshot Restoration Tool.

I was unable to find a program for snapper that made it easy to restore users home directories to a previous snapshot state.

I was a happy ZFS user for several years before I tried BTRFS and one of my favourite ZFS features is filesystem snapshots. ZFS has snapshots of datasets whereas BTRFS has snapshots of subvolumes but there are differences in how subvols and datasets are handled. When I started using BTRFS I wanted to be able to revert snapper snapshots, at least of home directories, in a very similar way to how the `zfs rollback` command works but unfortunately the `snapper rollback` command does not work in a similar manner. I don't want a new snapshot or subvol to be created when I do a rollback which is why I wrote srt, to rollack witout having to think about multiple subvols.

SRT funtions a bit like `zfs rollback`, reverting all files in the current users home directory to how they were as per a defined snapper snapshot but it doesn't destroy the intervening snapshots so you could ptentially revert to a newer snapshot after reverting to an older one, if available. A new snapshot or subvol is not created when you rollback with SRT.

Running SRT can be dangerous! All files created since the chosen snapshot to restore will be deleted. Use the Dry Run mode to preview what files would be deleted if you restore to the chosen snapshots state. srt provides a text interface to easily choose a snapper home directory snapshot to revert to.

Quit any browsers and stop any other running programs before running this script locally.

You do not need to have root permissions to run SRT. It requires that your user has read access to their own ~/.snapshots directory.

## Snapper config

This tool cannot work without the following snapper configuration which needs to be applied for every user who wants to run srt.

This script presumes your users snapper config name matches the (Linux) user name of the user who wants to run srt.

```
chown root:USERS_GID /home/USER/.snapshots/
chmod g+rx /home/USER/.snapshots/
```

You would need to replace USERS_GID with your Linux users GID and USER the srt users Linux user name. You can find your users GID by running the `id` command.

Your user also needs permission to run the snapper tool to list the snapshots date and time:

```
snapper -c USER set-config ALLOW_USERS=USER
```

Here you replace USER with your user name to enable your user to be able to query snapper for snapshot info.
