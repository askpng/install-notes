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

4. Proceed to install & reboot

## Secure Boot (optional)

`Enroll MOK` > `ublue-os`

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
1. Replace fonts with Inter 12 and monospace to 12 (if on `40`, via `dconf-editor`)
2. Test suspend on AC power
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
1. Check `lsm`:
```
cat /sys/kernel/security/lsm
```
2. Exclude lockdown from `lsm`:
```
lsm=capability,yama,selinux,bpf,landlock
```
3. Add kernel arguments to enable `SysRq` and `zcfan`. Changes will be applied on next boot:
```
sudo rpm-ostree kargs --append=lsm=capability,yama,selinux,bpf,landlock --append=sysrq_always_enabled=1 --append=thinkpad_acpi.fan_control=1
```
## Add COPR repos for python-validity, throttled, and butter
```
cd /etc/yum.repos.d/
sudo wget https://copr.fedorainfracloud.org/coprs/sneexy/python-validity/repo/fedora-$(rpm -E %fedora)/sneexy-python-validity-fedora-$(rpm -E %fedora).repo
sudo wget https://copr.fedorainfracloud.org/coprs/abn/throttled/repo/fedora-$(rpm -E %fedora)/abn-throttled-fedora-$(rpm -E %fedora).repo
sudo wget https://copr.fedorainfracloud.org/coprs/zhangyuannie/butter/repo/fedora-$(rpm -E %fedora)/zhangyuannie-butter-fedora-$(rpm -E %fedora).repo
```
## Install and configure utilities (open-fprintd, throttled, tlp, zcfan)
1. Disable `power-profiles-daemon` and `rfkill`:
```
sudo systemctl disable --now power-profiles-daemon
sudo systemctl mask power-profiles-daemon
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
```
2. Remove:
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
rpm-ostree override remove thermald fprintd fprintd-pam --install open-fprintd --install fprintd-clients --install fprintd-clients-pam --install python3-validity --install throttled --install tlp --install tlp-rdw --install zcfan --install butter
```
### Copy config files and reboot
1. Clone and copy files into `/etc`.
2. `systemct reboot`
### Enable services
```
sudo systemctl enable tlp throttled zcfan
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
### Reinstall Flatpaks
Only reinstall stock Flatpaks:
```
xargs flatpak install -u < bluefin-flatpaks
```
Stripped-down Bluefin Flatpaks + essential Flatpaks:
```
xargs flatpak install -u -y < essential-flatpaks
