#!/bin/sh

killall conky
sleep 5s 
conky -c "$HOME/.conky/monitor.conkyrc" 
#conky -c "$HOME/.conky/clock.conkyrc" 
conky -c "$HOME/.conky/manual.conkyrc" 
