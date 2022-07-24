#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done
echo "----" | tee -a /tmp/polybar1.log /tmp/polybar2.log /tmp/polybar3.log

echo "Bars launched..."
# Launch bar
MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar1.log & disown
MONITOR=$(polybar -m|tail -2 | head -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar2.log & disown
MONITOR=$(polybar -m|head -1|sed -e 's/:.*$//g') polybar -r -c ~/.config/polybar/config_xmonad mon1 2>&1 | tee -a /tmp/polybar3.log & disown

echo "Bars launched..."
