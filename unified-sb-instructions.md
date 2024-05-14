This is a work in progress.

# Download Silverblue ISO

Download official Silverblue installation ISO from the [official website](https://fedoraproject.org/atomic-desktops/silverblue/download)

# Installation steps

1. Select installation destination
2. Select Automatic Partitioning OR Blivet-GUI
2a. When partitioning with Blivet-GUI, use:

```
- /boot/efi
300 MiB EFI partition
- BTRFS volume
150 GiB
/, /var/home
- /mnt/data
remaining, ext4
```

## Create subvol for snapshots (~/.snapshots) and container homes (~/.containers)
1. Create subvolume
```
cd ~
sudo btrfs subvolume create .snapshots
sudo btrfs subvolume create .containers
```
2. Append entry to /etc/fstab
```
sudo nano /etc/fstab
```
Append:
```
UUID=[uuid] /var/home/$USER/.snapshots    btrfs   subvol=home/mel/.snapshots,compress=zstd:1 0 0
UUID=[uuid] /var/home/$USER/.containers   btrfs   subvol=home/mel/.containers,compress=zstd:1 0 0
```
3. Reload and mount:
```
sudo systemctl daemon-reload
sudo mount -a
```

# Rebase to target images
## silverblue-main

Important details/notes ([complete list of package diffs](https://github.com/ublue-os/main/blob/main/packages.json)):
- Firefox installed as system package, have to manually unlayer + `remove ~/.mozilla` + install flatpak
- `intel-media-driver`, `mesa-va-drivers-freeworld`, `ffmpeg`, `distrobox`, `gnome-tweaks`, `adw-gtk3-theme` installed by default

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main:latest --reboot
```

Then,

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/silverblue-main:latest --reboot
```

## bluefusion 

Important details/notes ([complete list of package diffs](https://github.com/ublue-os/main/blob/main/packages.json)):
- Firefox installed as system package, have to manually unlayer + `remove ~/.mozilla` + install flatpak
- `intel-media-driver`, `mesa-va-drivers-freeworld`, `ffmpeg`, `distrobox`, `gnome-tweaks`, `adw-gtk3-theme` installed by default

```
rpm-ostree rebase ostree-unverified-registry:ghcr.io/ublue-os/silverblue-main:latest --reboot
```

Then,

```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/silverblue-main:latest --reboot
```
