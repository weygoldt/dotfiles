#!/bin/bash
cd # change dir to home

PACKAGES=(
    com.spotify.Client              # music streaming
    md.obsidian.Obsidian            # obsidian knowledge management
    net.ankiweb.Anki                # spaced repitition flashcards
    org.signal.Signal               # signal private messaging
    org.zotero.Zotero               # zotero citation manager
    us.zoom.Zoom                    # uni video meetings
    com.obsproject.Studio           # obs screen recorder    
    com.github.tchx84.Flatseal      # flatpak permissions GUI
)

# install used flatpaks
sudo flatpak install -y ${PACKAGES[@]}