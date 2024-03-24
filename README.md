# Video Codec Analyzer 🎥💻

This Bash script analyzes video files in the current directory to provide insights on codecs, helping you optimize your video encoding process.

## Features
- 💡 **Codec Analysis**: Determine the best and worst codecs based on video duration.
- 📊 **Common Codec Analysis**: Identify the most common codec among your video files.

## Usage
1. Ensure you have `ffprobe` installed.
2. Simply run the script in your video directory:

```bash
./video_codec_analyzer.sh

█████   █████ ███      █████                       █████████                      ████                                     
░░███   ░░███ ░░░      ░░███                       ███░░░░░███                    ░░███                                     
 ░███    ░███ ████   ███████   ██████  ██████     ░███    ░███ ████████    ██████  ░███ █████ ████ █████   ██████  ████████ 
 ░███    ░███░░███  ███░░███  ███░░██████░░███    ░███████████░░███░░███  ░░░░░███ ░███░░███ ░███ ███░░   ███░░███░░███░░███
 ░░███   ███  ░███ ░███ ░███ ░███████░███ ░███    ░███░░░░░███ ░███ ░███   ███████ ░███ ░███ ░███░░█████ ░███████  ░███ ░░░ 
  ░░░█████░   ░███ ░███ ░███ ░███░░░ ░███ ░███    ░███    ░███ ░███ ░███  ███░░███ ░███ ░███ ░███ ░░░░███░███░░░   ░███     
    ░░███     █████░░████████░░██████░░██████     █████   █████████ █████░░█████████████░░███████ ██████ ░░██████  █████    
     ░░░     ░░░░░  ░░░░░░░░  ░░░░░░  ░░░░░░     ░░░░░   ░░░░░░░░░ ░░░░░  ░░░░░░░░░░░░░  ░░░░░███░░░░░░   ░░░░░░  ░░░░

Progress: [====================================================================================================  ] 100%

Best Codec: hevc (10464.037000 seconds)
Worst Codec: h264 (4940.960000 seconds)
Analyzing the most common codec...
Progress: [====================================================================================================  ] 100%

Most Common Codec: h264 (found in 9 files)
Ideal for good quality and small files: libx264

```

## About
This script utilizes `ffprobe` to extract codec information from video files (`.mp4` and `.mkv`). It then analyzes this data to identify the best and worst codecs based on video duration, as well as the most common codec found in the directory.

Feel free to contribute or report issues on [GitHub](https://github.com/0n1cOn3/Video-Codec-Analyzer).

Happy video encoding! 🚀

