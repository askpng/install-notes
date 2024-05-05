# Other useful commands/utilities

## Stem darkening
```
sudo echo "FREETYPE_PROPERTIES=\"cff:no-stem-darkening=0 autofitter:no-stem-darkening=0\""  | tee -a /etc/enviroment
```
## Flags for electron-based apps
```
--ozone-platform-hint=auto
--enable-features=VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer
```
## Set Flatpak locale via Flatseal
```
LC_ALL=en_US.UTF-8
```
## Flameshot via Flatpak
### Give screenshot permissions
[Origin](https://github.com/flameshot-org/flameshot/issues/3383#issuecomment-1916839965)
```
flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes
```
### Bind Flameshot GUI to Super+Shift+S via Gnome Settings 
```
flatpak run --command=flameshot -u org.flameshot.Flameshot gui
```
