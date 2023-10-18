Packages I will need for this

Install arch linux using the archinstall script and choose the desktop profile "awesome". This automatically installs awesome and the alacritty terminal (and some other packages...).

Manually install paru by running:

```sh
sudo pacman -S --noconfirm git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

To disable the annoying beep sound when doing something wrong, run this
```
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
```

Install these packages in addition:
```sh
PACKACKES = {
    ttf-jetbrains-mono-nerd,
    awesome,
    zsh-syntax-hightlighting,
    zsh-autosuggestions-git,
    zsh-autocomplete-git,
    zsh-autoswitch-virtualenv-git,
    gnome-keyring,      # keyring e.g. for wifi passwords
    polkit-gnome,       # policykit, e.g. when sudo rights required
    seahorse,           # control entries in keyring
    network-manager-applet, # network in systray
    blueman-applet,     # bluetooth in systray
    picom-jonaburg-git, # compositor with a nice blur effect
    feh,                # wallpaper setter
    xclip,              # terminal clipboard
    lxsession,          # session manager
    lxappearance,       # set gtk appearance
    i3lock-color,       # screen locker
    scrot,              # screen shot utility
    light,
    colloid-icon-theme-git, # nice icons
    openssh,
}
```

## You still need to enable some stuff

```sh
sudo systemctl enable --now cronie.service
sudo systemctl enable --now networkmanager.service
sudo systemctl enable --now tlp
sudo systemctl enable --now bluetooth
```


## Changing brightness via CLI

install light
add file /etc/udev/rules.d/backlight.rules:
```
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```
run `sudo usermod -aG video $(whoami)`
reboot
now you can use light -S x to set screen brightness to x percent


## TLP configurations

install `tlp powertop s-tui`
create file /etc/tlp.d/10-my.conf
```
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave

CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power

CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=75

CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=1

CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0

USB_EXCLUDE_PHONE=1
```

## earlyoom

install earlyoom
configure earlyoom by editing /etc/default/earlyoom -- e.g. I set EARLYOOM_ARGS to "-r 30 -p -m 3 -s 100" to run check every 30s and kill processes when free RAM < 3% (swap is ignored -- I recommend turning it of via removing record from /etc/fstab; -p increases priority of earlyoom service
systemctl enable --now earlyoom


## Export kde config to awesome
Add this to .xprofile in the home directory. .xprofile is sourced by sddm on startup
```
export XDG_CURRENT_DESKTOP="kde"
```
