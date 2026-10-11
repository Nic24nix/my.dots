#!/usr/bin/env bash

# Showcase do rice — Hyprland + Kitty

kitty --title "CAVA • Audio Visualizer" cava &
sleep 0.4
kitty --title "NERDFETCH • Fedora" --override cursor_shape=block --override cursor_blink_interval=0 sh -c '~/.local/bin/nerdfetch; sleep infinity' &
sleep 0.4
kitty --title "PEACLOCK • Clock" peaclock &

