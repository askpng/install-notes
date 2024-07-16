# Other useful commands/utilities

## Stem darkening
```
sudo echo "FREETYPE_PROPERTIES=\"cff:no-stem-darkening=0 autofitter:no-stem-darkening=0\""  | tee -a /etc/enviroment
```
## Flags for electron-based apps
```
--ozone-platform=wayland
--enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer,smooth-scrolling,gpu-rasterization,zero-copy
```
## Set Electron apps to use wayland
```
ELECTRON_OZONE_PLATFORM_HINT=auto
```
## Set Flatpak locale via Flatseal
```
LC_ALL=en_US.UTF-8
```
## Fix Fn keys on keyboards that use Apple keyboards

On typical distros, run

```
echo "options hid_apple fnmode=0" | sudo tee -a /etc/modprobe.d/hid_apple.conf
```

and regenerate GRUB or reinstall kernel using dracut.

On Fedora Siverblue, run

```
rpm-ostree kargs --append-if-missing=hid_apple.fnmode=0"
```

and reboot.
