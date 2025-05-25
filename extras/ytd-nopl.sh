#!/bin/bash

#proxychains4 yt-dlp -f 'bv[height=1080][ext=mp4]+ba[ext=m4a]' --no-playlist --merge-output-format mp4 -o '%(title)s.mp4' $1
yt-dlp --proxy="socks5h://127.0.0.1:10808" -f 'bv[height<=?1080][ext=mp4]+ba[ext=m4a]' --no-playlist --merge-output-format mp4 -o '%(title)s.mp4' $1
