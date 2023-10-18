#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# xsetroot -cursor_name left_ptr &

#run conky -c $HOME/.config/hypr/system-overview &
# run nm-applet &
# run 1password &
# numlockx on &
run $HOME/.config/hypr/scripts/swww_wallpapers "$HOME/.config/hypr/wallpapers" &
run $HOME/.config/hypr/scripts/swww_wallpapers "$HOME/.config/hypr/wallpapers" &
run $HOME/.config/hypr/scripts/swww_wallpapers "$HOME/.config/hypr/wallpapers" &
run $HOME/.config/hypr/scripts/swww_wallpapers "$HOME/.config/hypr/wallpapers" &
