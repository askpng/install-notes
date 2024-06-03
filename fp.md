# Flatpaks

Add Flathub remote if not present yet
```
flatpak remote-add -u --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
## Essential packages
Install the following flatpak packages:
```
flatpak install -u -y com.discordapp.Discord com.github.d4nj1.tlpui com.github.tchx84.Flatseal com.mattjakeman.ExtensionManager com.quexten.Goldwarden de.haeckerfelix.Fragments io.github.flattool.Warehouse io.github.nokse22.minitext io.github.seadve.Kooha net.waterfox.waterfox org.chromium.Chromium org.flozz.yoga-image-optimizer org.gnome.Epiphany org.gnome.Evolution org.gnome.Snapshot org.gnome.gitlab.somas.Apostrophe org.mozilla.firefox page.codeberg.libre_menu_editor.LibreMenuEditor re.sonny.Junction com.slack.Slack org.flameshot.Flameshot
```
Runtimes (if not immediately installed):
```
org.freedesktop.Platform.VAAPI.Intel
org.freedesktop.Platform.ffmpeg-full
org.freedesktop.Platform.openh264
org.gtk.Gtk3theme.adw-gtk3
org.gtk.Gtk3theme.adw-gtk3-dark
```
### Enable wayland on Electron apps
Set the following environment variable:
```
ELECTRON_OZONE_PLATFORM_HINT=auto
```
This replaces `--ozone-platform-hint=auto`.

`--enable-features=VaapiVideoDecodeLinuxGL,...` still have to be passed using command line or by editing the `.desktop` file execution command. 
### Junction
Enable Junction as default browser
```
xdg-settings set default-web-browser re.sonny.Junction.desktop
```
### Goldwarden login
From [quexten/goldwarden/wiki/Getting-Started](https://github.com/quexten/goldwarden/wiki/Getting-Started)
#### Set API URL
```
flatpak run --command=/app/bin/goldwarden com.quexten.Goldwarden config set-api-url https://my.bitwarden.domain/api
flatpak run --command=/app/bin/goldwarden com.quexten.Goldwarden config set-identity-url https://my.bitwarden.domain/identity
flatpak run --command=/app/bin/goldwarden com.quexten.Goldwarden config set-notifications-url https://my.bitwarden.domain/notifications
flatpak run --command=/app/bin/goldwarden com.quexten.Goldwarden vault login --email myemail@here.io
```
#### If getting traffic errors:
```
flatpak run --command=/app/bin/goldwarden com.quexten.Goldwarden config set-client-id client/id/here
flatpak run --command=/app/bin/goldwarden com.quexten.Goldwarden config set-client-secret client/secret/here
```
#### System-wide autotype:
Set up a new shortcut through GNOME Settings for CTRL+ALT+P
```
dbus-send --type=method_call --dest=com.quexten.Goldwarden.autofill /com/quexten/Goldwarden com.quexten.Goldwarden.Autofill.autofill
```
## Install Spotify
Run on VPN for stable speeds
```
flatpak install -u -y com.spotify.Client
```
### Flameshot Flatpak

#### Give screenshot permissions to Flatpak
```
flatpak permission-set screenshot screenshot org.flameshot.Flameshot yes
```
#### Bind Gnome Shortcut 
Super+Shift+S
```
flatpak run --command=flameshot -u org.flameshot.Flameshot gui
```
