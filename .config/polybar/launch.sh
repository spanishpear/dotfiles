#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

num_monitors=$(polybar -m | wc -l)
# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [[ $num_monitors == 3 ]]; then
	echo "3 monitors detected"
	echo "----" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log
	MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar1.log & disown
	MONITOR=$(polybar -m|tail -2 | head -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar2.log & disown
	MONITOR=$(polybar -m|head -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar3.log & disown
else
	echo "1 monitor detected"
	echo "----" | tee -a /tmp/polybar1.log
	MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar1.log & disown	
fi

echo "Bars launched..."
