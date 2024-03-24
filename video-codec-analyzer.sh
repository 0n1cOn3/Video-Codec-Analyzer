#!/bin/bash

# Show Logo
show_logo() {
    echo "
 █████   █████ ███      █████                       █████████                      ████                                     
░░███   ░░███ ░░░      ░░███                       ███░░░░░███                    ░░███                                     
 ░███    ░███ ████   ███████   ██████  ██████     ░███    ░███ ████████    ██████  ░███ █████ ████ █████   ██████  ████████ 
 ░███    ░███░░███  ███░░███  ███░░██████░░███    ░███████████░░███░░███  ░░░░░███ ░███░░███ ░███ ███░░   ███░░███░░███░░███
 ░░███   ███  ░███ ░███ ░███ ░███████░███ ░███    ░███░░░░░███ ░███ ░███   ███████ ░███ ░███ ░███░░█████ ░███████  ░███ ░░░ 
  ░░░█████░   ░███ ░███ ░███ ░███░░░ ░███ ░███    ░███    ░███ ░███ ░███  ███░░███ ░███ ░███ ░███ ░░░░███░███░░░   ░███     
    ░░███     █████░░████████░░██████░░██████     █████   █████████ █████░░█████████████░░███████ ██████ ░░██████  █████    
     ░░░     ░░░░░  ░░░░░░░░  ░░░░░░  ░░░░░░     ░░░░░   ░░░░░░░░░ ░░░░░  ░░░░░░░░░░░░░  ░░░░░███░░░░░░   ░░░░░░  ░░░░░     
                                                                                         ███ ░███                           
                                                                                        ░░██████                            
                                                                                         ░░░░░░                             
"
}

# Function to extract codec information
extract_codec_info() {
    local codec_info
    codec_info=$(ffprobe -v error -select_streams v:0 -show_entries "$1" -of default=noprint_wrappers=1:nokey=1 "$2" 2>/dev/null)
    echo "$codec_info"
}

# Function to count total video files
count_video_files() {
    local count
    count=$(find . -type f \( -iname '*.mp4' -o -iname '*.mkv' \) | wc -l)
    echo "$count"
}

# Function to update progress bar
update_progress() {
    local progress=$1
    echo -ne "\rProgress: ["
    printf "%0.s=" $(seq 1 "$progress")
    printf "%0.s " $(seq "$progress" 99)
    echo -n "] $progress%"
}

# Function to find the best and worst codec based on video duration
find_best_and_worst_codec() {
    local total_files=$(count_video_files)
    local processed_files=0

    local best_codec=""
    local worst_codec=""
    local best_duration=0
    local worst_duration=0

    # Loop through video files recursively
    while IFS= read -r -d '' file; do
        # Extract codec information
        codec=$(extract_codec_info stream=codec_name "$file")

        # Ensure codec information is retrieved
        if [ -n "$codec" ]; then
            # Extract duration of the video
            duration=$(extract_codec_info format=duration "$file")
            if [ -n "$duration" ]; then
                # Determine the best codec based on duration
                if (( $(echo "$duration > $best_duration" | bc -l) )); then
                    best_codec="$codec"
                    best_duration="$duration"
                fi

                # Determine the worst codec based on duration
                if (( $(echo "$duration < $worst_duration" | bc -l) || $(echo "$worst_duration == 0" | bc -l) )); then
                    worst_codec="$codec"
                    worst_duration="$duration"
                fi
            fi
        fi

        ((processed_files++))
        if [ "$total_files" -gt 0 ]; then
            update_progress $((processed_files * 100 / total_files))
        fi
    done < <(find . -type f \( -iname '*.mp4' -o -iname '*.mkv' \) -print0)
    
    echo # Move to the next line after progress bar
    # Output results
    echo -e "\nBest Codec: $best_codec ($best_duration seconds)"
    echo "Worst Codec: $worst_codec ($worst_duration seconds)"
}

# Function to analyze the most common codec
analyze_codec() {
    local total_files=$(count_video_files)
    local processed_files=0

    echo "Analyzing the most common codec..."

    # Array to store unique codecs
    declare -A codec_counts

    # Loop through video files recursively
    while IFS= read -r -d '' file; do
        # Extract codec information
        codec=$(extract_codec_info stream=codec_name "$file")

        # Ensure codec information is retrieved
        if [ -n "$codec" ]; then
            ((codec_counts[$codec]++))
        fi

        ((processed_files++))
        if [ "$total_files" -gt 0 ]; then
            update_progress $((processed_files * 100 / total_files))
        fi
    done < <(find . -type f \( -iname '*.mp4' -o -iname '*.mkv' \) -print0)

    echo # Move to the next line after progress bar

    # Find the most common codec
    local most_common_codec=""
    local max_count=0
    for codec in "${!codec_counts[@]}"; do
        if [ "${codec_counts[$codec]}" -gt "$max_count" ]; then
            most_common_codec="$codec"
            max_count="${codec_counts[$codec]}"
        fi
    done

    # Output results
    echo -e "\nMost Common Codec: $most_common_codec (found in $max_count files)"
    case "$most_common_codec" in
        "h264") echo "Ideal for good quality and small files: libx264" ;;
        "hevc") echo "Ideal for good quality and small files: libx265" ;;
        *) echo "No ideal codec found." ;;
    esac
}

# Execute functions
show_logo
find_best_and_worst_codec
analyze_codec

