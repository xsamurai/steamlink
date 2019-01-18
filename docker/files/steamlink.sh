#!/bin/bash
#
# Script to launch the Steam Link app on Raspberry Pi

TOP=$(cd "$(dirname "$0")" && pwd)

function show_message()
{
	style=$1
	shift
	if ! zenity "$style" --no-wrap --text="$*" 2>/dev/null; then
		case "$style" in
		--error)
			title=$"Error"
			;;
		--warning)
			title=$"Warning"
			;;
		*)
			title=$"Note"
			;;
		esac

		# Save the prompt in a temporary file because it can have newlines in it
		tmpfile="$(mktemp || echo "/tmp/steam_message.txt")"
		echo -e "$*" >"$tmpfile"
		if [ "$DISPLAY" = "" ]; then
			cat $tmpfile; echo -n 'Press enter to continue: '; read input
		else
			xterm -T "$title" -e "cat $tmpfile; echo -n 'Press enter to continue: '; read input"
		fi
		rm -f "$tmpfile"
	fi
}

# Check to make sure the hardware is capable of streaming at 1080p60
# Model code information from:
# https://www.raspberrypi.org/documentation/hardware/raspberrypi/revision-codes/README.md
if [ ! -f "$TOP/.ignore_cpuinfo" ]; then
	revision=$(cat /proc/cpuinfo | fgrep "Revision" | sed 's/.*: //')
	revision=$((16#$revision))
	processor=$(($(($revision >> 12)) & 0xf)) # 0: BCM2835, 1: BCM2836, 2: BCM2837
	if [ $processor -lt 2 ]; then
		show_message --error $"You need to run on a Raspberry Pi 3 or newer - aborting."
		exit 1
	fi
fi

# Check to make sure the experimental OpenGL driver isn't enabled
if [ ! -f "$TOP/.ignore_kms" ]; then
	if egrep '^dtoverlay=vc4-kms-v3d' /boot/config.txt >/dev/null 2>&1; then
		show_message --error $"You have dtoverlay=vc4-kms-v3d in /boot/config.txt, which will cause a black screen when starting streaming - aborting.\nTry commenting out that line and rebooting."
		exit 1
	fi
fi

# Install any additional dependencies, as needed
if [ -z "${STEAMSCRIPT:-}" ]; then
	STEAMSCRIPT=/usr/bin/steamlink
fi
STEAMDEPS="$(dirname $STEAMSCRIPT)/steamlinkdeps"
if [ -f "$STEAMDEPS" -a -f "$TOP/steamlinkdeps.txt" ]; then
	"$STEAMDEPS" "$TOP/steamlinkdeps.txt"
fi

# Check to make sure the Steam Controller rules are installed
UDEV_RULES_DIR=/lib/udev/rules.d
UDEV_RULES_FILE=60-steam-input.rules
if [ ! -f "$UDEV_RULES_DIR/$UDEV_RULES_FILE" ]; then
	title="Updating udev rules"

	script="$(mktemp || echo "/tmp/steamlink_copy_udev_rules.sh")"
	cat >$script <<__EOF__
echo "Copying Steam Input udev rules into place..."
echo "sudo cp $TOP/udev/rules.d/$UDEV_RULES_FILE $UDEV_RULES_DIR/$UDEV_RULES_FILE && sudo udevadm trigger"
sudo cp $TOP/udev/rules.d/$UDEV_RULES_FILE $UDEV_RULES_DIR/$UDEV_RULES_FILE && sudo udevadm trigger
echo -n "Press return to continue: "
read line
__EOF__
	if [ "$DISPLAY" = "" ]; then
		/bin/sh $script
	elif which lxterminal >/dev/null; then
		lxterminal -t "$title" -e /bin/sh $script

		# Wait for the script to complete
		sleep 3
		while ps aux | grep -v grep | grep $script >/dev/null; do
			sleep 1
		done
	elif which xterm >/dev/null; then
		xterm -bg white -fg black -T "$title" -e /bin/sh $script
	else
		/bin/sh $script
	fi
	rm -f $script
fi

# Set up the temporary directory
export TMPDIR="$TOP/.tmp"
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"

# Restore the display when we're done
cleanup()
{
	qemu-arm ~/.local/share/SteamLink/bin/screenblank -k
}
trap cleanup 2 3 15

# Run the shell application and launch streaming
QT_VERSION=5.12.0
export PATH="$TOP/bin:$PATH"
export QTDIR="$TOP/Qt-$QT_VERSION"
export QT_PLUGIN_PATH="$QTDIR/plugins"
export LD_LIBRARY_PATH="$TOP/lib:$QTDIR/lib:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/Valve Corporation/SteamLink/controller_map.txt"

if [ "$DISPLAY" = "" ]; then
	QPLATFORM="eglfs"
	export QT_QPA_EGLFS_FORCE888=1
else
	QPLATFORM="xcb"
fi

while true; do
	qemu-arm ~/.local/share/SteamLink/bin/shell -platform "$QPLATFORM" "$@"

	# See if the shell wanted to launch anything
	cmdline_file="$TMPDIR/launch_cmdline.txt"
	if [ -f "$cmdline_file" ]; then
		cmd=`cat "$cmdline_file"`
		eval $cmd
		rm -f "$cmdline_file"
	else
		# We're all done...
		break
	fi
done
cleanup
