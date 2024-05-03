# Bluefin installation steps

## Manual partitioning

1. Select installation destination
2. Select **Advanced Custom (Blivet-GUI)**
3. Create the following partitioning scheme:
```
/boot/efi
- 300 MiB
- EFI system Partition

/boot
- 1 GiB
- ext4

- label: system
BTRFS volume

	root
	/

	/var
	var

	/var/home
	home
```

Proceed to install

## Secure Boot (optional)

On first boot, select `Enroll MOK`. Input password `ublue-os`

## Remove duplicate Grub entries
```
sudo grub2-switch-to-blscfg
sudo grub2-mkconfig -o /etc/grub2.cfg
```
## Rebase to 40
```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bluefin:latest --reboot
```

## To-do list (manual)
- Replace fonts with Inter 12 and monospace to 12 (if on `40`, via `dconf-editor`)
- Test suspend on AC power
If problematic, verify wakeups:
```
cat /proc/acpi/wakeup | grep enabled
```
Disable XHC wakeup:
```
sudo su %% echo XHC > /proc/acpi/wakeup
```
Test suspend again, then log out, log in, and test suspend again

## Disable kernel lockdown if on Secure Boot (optional)

Check lsm:
```
cat /sys/kernel/security/lsm
```
Add kernel arguments to include everything above, but without lockdown:
```
sudo rpm-ostree kargs --append=lsm=capability,yama,selinux,bpf,landlock
```
Also add kernel arguments to enable `SysRq`
```
sudo rpm-ostree kargs --append=lsm=capability,yama,selinux,bpf,landlock --append=sysrq_always_enabled=1
```
Changes will be applied after reboot.
## Add repos for python-validity and throttled
Add COPRs:
```
cd /etc/yum.repos.d/
sudo wget https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/repo/fedora-$(rpm -E %fedora)/sneexy-python-validity-fedora-$(rpm -E %fedora).repo
sudo wget https://copr.fedorainfracloud.org/coprs/abn/throttled/repo/fedora-$(rpm -E %fedora)/abn-throttled-fedora-$(rpm -E %fedora).repo
```
Remove and install repo files for easier upgrade. For reference, check this and adapt to COPRs:
```
rpm-ostree update \
--uninstall $(rpm -q rpmfusion-free-release) \
--uninstall $(rpm -q rpmfusion-nonfree-release) \
--install rpmfusion-free-release \
--install rpmfusion-nonfree-release
```

## Install and configure utilities (open-fprintd, throttled, tlp, zcfan)
Disable `power-profiles-daemon` and `rfkill`:
```
sudo systemctl disable --now power-profiles-daemon
sudo systemctl mask power-profiles-daemon
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

Remove
- thermald
- fprintd
- fprintd-pam


and install
- open-fprintd packages
- throttled
- tlp
- tlp-rdw
- zcfan
```
rpm-ostree override remove thermald fprintd fprintd-pam --install open-fprintd --install fprintd-clients --install fprintd-clients-pam --install python3-validity --install throttled --install tlp tlp-rdw --install zcfan
```

### Copy config files

Clone and copy files in `/etc`

### Enable services

```
sudo systemctl enable tlp throttled zcfan
```

## Reboot to apply changes

```
systemctl reboot
```

## Switch system Flatpak to user
Export list of installed flatpaks
```
flatpak list --columns=application --app > bluefin-flatpaks
```
Remove system Flathub
```
flatpak uninstall --all --delete-data --assumeyes  # prefered flathub remote
flatpak remote-modify --disable flathub
flatpak remote-delete --system flathub  # remove filtered flathub remote
```
### Reinstall Bluefin Flatpaks
```
xargs flatpak install -u < bluefin-flatpaks
```
