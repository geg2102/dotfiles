#!/bin/sh
# xrdp X session start script (c) 2015, 2017 mirabilos
# published under The MirOS Licence

#!/bin/sh
# xRDP start script for i3 (Xorg)

# Locale & profile (best-effort)
[ -r /etc/profile ] && . /etc/profile
if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  [ -n "${LANG+x}" ] && export LANG
  [ -n "${LANGUAGE+x}" ] && export LANGUAGE
  [ -n "${LC_ALL+x}" ] && export LC_ALL
fi

# Ensure xRDP's chansrv can start a clean dbus
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR

# User X resources / keymap
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"
[ -f "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"

# Start a session bus (needed for clipboard via cliprdr)
if command -v dbus-launch >/dev/null 2>&1; then
  eval "$(dbus-launch --sh-syntax)"
  export DBUS_SESSION_BUS_ADDRESS
  export DBUS_SESSION_BUS_PID
fi

# OPTIONAL but helps clipboard reliability in i3
# (pick one if you like; otherwise omit)
# command -v parcellite >/dev/null 2>&1 && parcellite &

# Start i3 under dbus
exec /usr/local/bin/i3


# if test -r /etc/profile; then
# 	. /etc/profile
# fi
#
# if test -r /etc/default/locale; then
# 	. /etc/default/locale
# 	test -z "${LANG+x}" || export LANG
# 	test -z "${LANGUAGE+x}" || export LANGUAGE
# 	test -z "${LC_ADDRESS+x}" || export LC_ADDRESS
# 	test -z "${LC_ALL+x}" || export LC_ALL
# 	test -z "${LC_COLLATE+x}" || export LC_COLLATE
# 	test -z "${LC_CTYPE+x}" || export LC_CTYPE
# 	test -z "${LC_IDENTIFICATION+x}" || export LC_IDENTIFICATION
# 	test -z "${LC_MEASUREMENT+x}" || export LC_MEASUREMENT
# 	test -z "${LC_MESSAGES+x}" || export LC_MESSAGES
# 	test -z "${LC_MONETARY+x}" || export LC_MONETARY
# 	test -z "${LC_NAME+x}" || export LC_NAME
# 	test -z "${LC_NUMERIC+x}" || export LC_NUMERIC
# 	test -z "${LC_PAPER+x}" || export LC_PAPER
# 	test -z "${LC_TELEPHONE+x}" || export LC_TELEPHONE
# 	test -z "${LC_TIME+x}" || export LC_TIME
# 	test -z "${LOCPATH+x}" || export LOCPATH
# fi
#
# if test -r /etc/profile; then
# 	. /etc/profile
# fi
#
# test -x /etc/X11/Xsession && exec /etc/X11/Xsession
#
# if [ -f ~/.Xmodmap ]; then
#     xmodmap ~/.Xmodmap
# fi
#
#
# # kill any existing dbus
# if [ -r ~/.Xresources ]; then
#     xrdb -merge ~/.Xresources
# fi
#
# # Start a dbus session explicitly (needed for chansrv)
# export $(dbus-launch)
#
# # Start i3 under dbus
# exec i3
#
# # exec /bin/sh /etc/X11/Xsession
