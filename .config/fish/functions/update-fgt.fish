function update-fgt --wraps='cd ~/.var/app/org.mozilla.firefox/.mozilla/firefox/[profile-path-here]/chrome/firefox-gnome-theme && git pull && cd' --description 'Update firefox-gnome-theme'
  cd ~/.var/app/org.mozilla.firefox/.mozilla/firefox/[profile-path-here]/chrome/firefox-gnome-theme && git pull && cd $argv
        
end
