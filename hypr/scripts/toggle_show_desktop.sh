#!/bin/bash

CURRENT_WS=$(hyprctl activeworkspace | awk 'NR==1{print $3}' | tr -d '()')
SPECIAL_WS="special:hidden_ws_$CURRENT_WS"

if hyprctl clients | grep -q "(special:hidden_ws_$CURRENT_WS)"; then
    window_list=$(hyprctl clients | grep -B10 "(special:hidden_ws_$CURRENT_WS)" | grep "Window" | awk '{print $2}' | tr -d ':')
    if [ ! -z "$window_list" ]; then
        echo "$window_list" | while read -r window_addr; do
            [ ! -z "$window_addr" ] && hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:0x$window_addr"
        done
    fi
    sleep 0.1
    hyprctl dispatch workspace "$CURRENT_WS"
else
    window_list=$(hyprctl clients | grep -B10 "workspace: $CURRENT_WS (" | grep "Window" | awk '{print $2}' | tr -d ':')
    if [ ! -z "$window_list" ]; then
        echo "$window_list" | while read -r window_addr; do
            [ ! -z "$window_addr" ] && hyprctl dispatch movetoworkspacesilent "$SPECIAL_WS,address:0x$window_addr"
        done
    fi
fi
