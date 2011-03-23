#!/bin/sh

ACTION=`zenity --width=90 --height=200 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE Shutdown FALSE Reboot FALSE LockScreen` # FALSE Suspend`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
    gksudo halt		#zenity --question --text "Are you sure you want to halt?" && gksudo halt
    ;;
  Reboot)
    gksudo reboot	#zenity --question --text "Are you sure you want to reboot?" && gksudo reboot
    ;;
#  Suspend)
    #gksudo pm-suspend
#    dbus-send --system --print-reply --dest=org.freedesktop.Hal \
#    /org/freedesktop/Hal/devices/computer \
#    org.freedesktop.Hal.Device.SystemPowerManagement.Suspend int32:0
#
#    ;;
  LockScreen)
    xscreensaver-command -activate
    ;;
  esac
fi

