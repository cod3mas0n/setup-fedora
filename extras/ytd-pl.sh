#!/bin/bash
read -p "youtube Link Here : " YLINK
read -p "start playlist index: " STARTPL
read -p "End playlist index: " ENDPL

yt-dlp --proxy="socks5h://127.0.0.1:10808" -f 'bv[height=1080][ext=mp4]+ba[ext=m4a]' --playlist-start $STARTPL --playlist-end $ENDPL --merge-output-format mp4 -o '%(title)s.mp4' $YLINK > $PWD/Download.log 2>&1 &
