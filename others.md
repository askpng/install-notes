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
