#!/bin/bash

PACKAGES=(
    # Bootloader
    grub                        # bootloader
    efibootmgr                  # to modify the EFI bootmanager
    os-prober                   # To detect other os for grub
    
    # Networking
    networkmanager              # for wifi etc
    network-manager-applet      # for system tray in KDE    
    dialog                      # display dialog boxes from shell scripts
    wpa_supplicant              # needed for wifi
    avahi                       # to make network devices discoverable
    nfs-utils                   # to use kernels NFS support for network sharing
    inetutils                   # collection of common network programs
    dnsutils                    # ? (some network stuff)

    # Basic tools
    mtools                      # tools to access ms-dos disks
    dosfstools                  # dos filesystem utilities
    base-devel                  # group of basic development tools
    intel-ucode                 # to update intel processor firmware
    xdg-user-dirs               # manage well known dirs (e.g. /home/user/Music)
    xdg-utils                   # needed for a desktop environment
    gvfs                        # ?
    gvfs-smb                    # ?
    bash-completion             # for bash completion    
    openssh                     # ssh daemon
    rsync                       # to sync dirs
    reflector                   # update pacman mirrors
    acpi                        # advanced configuration and power interface
    acpi_call                   # tlp dependency
    tlp                         # linux advanced power management
    openbsd-netcat              # tcp/ip swiss army knife
    iptables-nft                # linux kernel packet control tool
    ipset                       # admin tool for ip sets
    nss-mdns                    # ? (glibc plugin providing host name resolution via mDNS)
    acpid                       # ? (power management)
    ntfs-3g                     # ntfs file system utils
    exfat-utils                 # exfat file syste
    exfatprogs

    # LTS Kernel
    linux-lts                   # lts kernel
    linux-lts-headers           # lts kernel headers
    dkms                        # dynamic kernel module support

    # Graphics drivers
    xf86-video-intel            # proprietary intel needed for hybrid graphics
    # nvidia                      # nvidia driver for linux kernel
    # nvidia-lts                  # nvidia driver for linux-lts kernel
    nvidia-dkms                 # nvidia driver for dkms for all kernels
    nvidia-utils                # stuff for nvidia
    nvidia-settings             # nvidia settings manager
    nvidia-prime                # to run applications on this card, does not work for some reason
    nvtop                       # to view nvidia activity
    cuda                        
    cuda-tools
    cudnn

    # Bluethooth
    bluez                       # for bluetooth
    bluez-utils                 # also for bluetooth
    
    # Printing
    cups                        # printing server
    hplip                       # hp printing servers
    
    # Sound
    alsa-utils                  # advanced linux sound architecture utilities
    pipewire                    # for sound
    pipewire-alsa               # for sound
    pipewire-pulse              # for sound
    pipewire-jack               # for sound
    sof-firmware                # open sound firmware
    
    # Virtual machines 
    virt-manager                # for managing virtual machines
    qemu                        # machine emulator and virtualizer
    qemu-arch-extra             # qemu for foreign architectures
    edk2-ovmf                   # firmware for virtual machines
    bridge-utils                # configure linux ethernet bridge
    dnsmasq                     # DNS forwarder and DHCP server
    vde2                        # virtual ethernet for qemu
)

# set time zone
echo $'\e[1;32mSetting time zone ...\e[0m'
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime 

# run hwclock to generate /etc/adjtime
echo $'\e[1;32mSynchronizing system and hardware clock ...\e[0m'
hwclock --systohc

# generate locales
echo $'\e[1;32mGenerating locales ...\e[0m'
sed -i '178s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us" >> /etc/vconsole.conf

# create hostname file
echo $'\e[1;32mCreating hostname files ...\e[0m'
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

# set root pw
echo $'\e[1;32mSetting root password ...\e[0m'
echo root:password | chpasswd

# install low level software and drivers
echo $'\e[1;32mInstalling software ...\e[0m'
pacman -S ${PACKAGES[@]}

# Installs grub on efi parition. Change the directory to /boot/efi if you mounted the EFI partition at /boot/efi
echo $'\e[1;32mInstalling bootloader ...\e[0m'
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB 

# Regenerate grub config to enaible microcode updates
echo $'\e[1;32mMaking grub.cfg ...\e[0m'
grub-mkconfig -o /boot/grub/grub.cfg

# enable startup processes
echo $'\e[1;32mEnabling startup services ...\e[0m'
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable acpid

# add regular sudo user
echo $'\e[1;32mSeeting up a user account ...\e[0m'
useradd -m weygoldt
echo weygoldt:password | chpasswd
usermod -aG libvirt weygoldt

# add user to sudoers
echo "weygoldt ALL=(ALL) ALL" >> /etc/sudoers.d/weygoldt

# print finishing instructions
printf "\e[1;32mDone! If applicable, edit mkinitcpio.conf, type exit, umount -R and reboot.\e[0m"




