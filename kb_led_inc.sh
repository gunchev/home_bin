#!/bin/sh

cur=$(dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.UPower /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.GetBrightness | sed s/...int32.//g)
max=$(dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.UPower /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.GetMaxBrightness | sed s/...int32.//g)

val=$(($cur + 1))
if (($val <= $max)); then
    dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.UPower /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.SetBrightness int32:$val
    notify-send -t 500 -i /usr/share/icons/HighContrast/scalable/devices/input-keyboard.svg "Brightness $val/$max"
fi
