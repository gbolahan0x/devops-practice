#!/bin/bash

#################################################
# File Organizer Script
# Purpose : Organize files by file type/extension
# Usage: /Organize.sh [directory]
#################################################

echo "Organizing files in: $DIRECTORY"

# Create directories by the file type
mkdir -p "$DIRECTORY"/{documents,images,videos,audio,archives,scripts,other}

# Move files by extension
find "$DIRECTORY" -maxdepth 1 -type f | while read file; do
	extension="${file##*.}"

	case "$extension" in
        pdf|doc|docx|txt|xls|xlsx)
            mv "$file" "$DIRECTORY/documents/"
            ;;
        jpg|png|gif|svg|ico)
            mv "$file" "$DIRECTORY/images/"
            ;;
        mp3|wav|flac|aac)
            mv "$file" "$DIRECTORY/music/"
            ;;
        mp4|avi|mkv|mov)
            mv "$file" "$DIRECTORY/videos/"
            ;;
         zip|tar|gz|rar|7z)
            mv "$file" "$DIRECTORY/archives/"
            ;;
         sh|py|js|go|rb)
            mv "$file" "$DIRECTORY/scripts/"
            ;;
         *)
            mv "$file" "$DIRECTORY/other/"
            ;;
    esac

    echo "MOVED SUCCESFULLY WITH KLAUD"
    
 