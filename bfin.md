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
3a. Add `/var/home/.snapshots` if planning to use `butter`

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

### Fix suspend
If problematic, verify wakeups:
```
cat /proc/acpi/wakeup | grep enabled
```
Disable XHC wakeup:

#### 1a. fish
```
sudo su %% echo XHC > /proc/acpi/wakeup
```
#### 1b. bash
```
sudo sh -c "echo 'XHC' >> /proc/acpi/wakeup"
```
#### 2. Trigger suspend behavior
1. Disconnect computer from AC/dock
2. Suspend laptop on battery for ~15 seconds, power on again
3. Power off laptop and dock completely
4. Power on laptop, suspend again on battery, wake up laptop
5. Power on dock and reattach to laptop
At this point suspend *should* work again. If not, power off, power on and try again.

## Disable kernel lockdown if on Secure Boot (optional)
1. Check `lsm`:
```
cat /sys/kernel/security/lsm
```
1a. Exclude lockdown from `lsm`:
> As of right now this has no effect on Fedora variants. To use `throttled`, disable Secure Boot.
```
lsm=capability,yama,selinux,bpf,landlock
```
2. Add kernel arguments to enable `SysRq`, `zcfan`, GuC loading, and FBC. Changes will be applied on next boot:
```
sudo rpm-ostree kargs --append=lsm=capability,yama,selinux,bpf,landlock --append=sysrq_always_enabled=1 --append=thinkpad_acpi.fan_control=1 --append=i915.enable_guc=2 --append=i915.enable_fbc=1
```
> Full command without `lockdown` disablement:
```
sudo rpm-ostree kargs --append=lsm=capability,yama,selinux,bpf,landlock --append=sysrq_always_enabled=1 --append=thinkpad_acpi.fan_control=1 --append=i915.enable_guc=2 --append=i915.enable_fbc=1
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
- butter
- open-fprintd packages
- throttled
- tlp
- tlp-rdw
- zcfan
```
rpm-ostree override remove thermald fprintd fprintd-pam --install open-fprintd --install fprintd-clients --install fprintd-clients-pam --install python3-validity --install throttled --install tlp --install tlp-rdw --install zcfan --install butter
```
### Copy config files and reboot
1. Clone this repo and copy files into `/etc`.
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
flatpak uninstall --all --delete-data --assumeyes
flatpak remote-modify --disable flathub
flatpak remote-delete --system flathub
```
### Reinstall Flatpaks
Only reinstall stock Flatpaks:
```
xargs flatpak install -u < bluefin-flatpaks
```
Stripped-down Bluefin Flatpaks + essential Flatpaks:
```
xargs flatpak install -u -y < essential-flatpaks
```
