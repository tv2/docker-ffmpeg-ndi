#!/bin/sh
/etc/init.d/dbus start
/etc/init.d/avahi-daemon start
sleep 8
/usr/local/ffmpeg "$@"
