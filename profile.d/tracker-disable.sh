#!/bin/bash

# /usr/share/dbus-1/services/org.freedesktop.portal.Tracker.service
# /etc/xdg/autostart/tracker-miner-fs-3.desktop
# /etc/xdg/autostart/tracker-miner-rss-3.desktop
#/usr/lib/systemd/user/tracker-extract-3.service
#/usr/lib/systemd/user/tracker-miner-fs-3.service
#/usr/lib/systemd/user/tracker-miner-fs-control-3.service
#/usr/lib/systemd/user/tracker-miner-rss-3.service
#/usr/lib/systemd/user/tracker-writeback-3.service
#/usr/share/dbus-1/services/org.freedesktop.Tracker3.Miner.Extract.service
#/usr/share/dbus-1/services/org.freedesktop.Tracker3.Miner.Files.Control.service
#/usr/share/dbus-1/services/org.freedesktop.Tracker3.Miner.Files.service
#/usr/share/dbus-1/services/org.freedesktop.Tracker3.Miner.RSS.service
#/usr/share/dbus-1/services/org.freedesktop.Tracker3.Writeback.service
#/usr/share/tracker3-miners/miners/org.freedesktop.Tracker3.Miner.Files.service
#/usr/share/tracker3-miners/miners/org.freedesktop.Tracker3.Miner.RSS.service



# Disable tracker in KDE, Gnome and Mate
TRACKERAUTOSTARTS=(tracker-extract tracker-miner-apps tracker-miner-fs tracker-miner-user-guides tracker-store)

# This script is enhanced version of https://bugzilla.redhat.com/attachment.cgi?id=1084926
# from https://bugzilla.redhat.com/show_bug.cgi?id=747689#c66

ME='/etc/profile.d/tracker-disable.sh'

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    notify-send "${ME} Failed!" "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    notify-send "${ME} Failed!" "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  # exit "${code}"
}

trap 'error ${LINENO}' ERR
set -e

disable_desktop_autostart() {
    FILE="$HOME/.config/autostart/$1.desktop"
    if [ -e "${FILE}" ]; then
        return
    fi
    cat > "${FILE}" <<EOF
[Desktop Entry]
# Disable in KDE (https://github.com/vasi/kdelibs/blob/master/kinit/README.autostart)
Hidden=true
OnlyShowIn=GNOME;XFCE;LXDE;
# Gnome
X-GNOME-Autostart-enabled=false
# Mate
X-MATE-Autostart-enabled=false
EOF
    if ! notify-send "${ME} disabled $1" "${ME} disabled autostart for ${FILE} in KDE, Gnome and Mate."; then
        : # Can't do anything without notify-send
    fi
}

if [ ! -d ~/.config/autostart ]; then
    mkdir -p ~/.config/autostart
fi

for i in "${TRACKERAUTOSTARTS[@]}"; do
    disable_desktop_autostart "$i"
done

trap - ERR
set +e
# notify-send "${ME} OK"
unset TRACKERAUTOSTARTS
unset ME
unset disable_desktop_autostart
