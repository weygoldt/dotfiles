#!/bin/sh

killall conky
sleep 5s && conky -c "$HOME/.conky/weygoldt.conkyrc"
