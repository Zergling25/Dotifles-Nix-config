#!/bin/bash
# 🎵 Per-Bar EQ Visualizer for Waybar — Optimized with Working Volume 🎵

# === CONFIG ===
channel_mode="${1:-stereo}"    # mono or stereo
bars=40
framerate=30
fallback_icon="🔇"
pulse_enabled=false
theme="${2:-inferno}"
volume_scaled=false

# === CHARSET ===
bar=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)

# === THEMES ===
declare -A theme_colors1
theme_colors1[arch]="#1793d1 #1bb6e8 #33c3ee #4fd0f4 #66ddfa #80eaff #99f7ff #b3ffff"
theme_colors1[teal]="#005f5f #007f7f #009f9f #00bfbf #00dfdf #00ffff #40ffff #80ffff"
theme_colors1[opensuse]="#28b741 #33c34d #3fd159 #59dd73 #73e68c #8cff99 #a6ffb3 #c0ffcc"
theme_colors1[sunset]="#ff4d4d #ff704d #ff944d #ffb84d #ffd24d #ffe64d #fff94d #ffff80"
theme_colors1[aurora]="#7f00ff #9933ff #b366ff #cc99ff #99ccff #66e0ff #33f5ff #00ffff"
theme_colors1[inferno]="#ff0000 #ff3300 #ff6600 #ff9900 #ffcc00 #ffff00 #ffff33 #ffff66"
theme_colors1[0led]="#000000 #1a1a1a #333333 #4d4d4d #666666 #999999 #cccccc #ffffff"
theme_colors1[eq]="#ff0000 #ff6600 #ffcc00 #ccff00 #66ff00 #ff6600 #ff3300 #ff0000"

IFS=' ' read -r -a colors1 <<< "${theme_colors1[$theme]}"

colors2=()
for c in "${colors1[@]}"; do
  r=$((0x${c:1:2} + (255 - 0x${c:1:2}) * 40 / 100))
  g=$((0x${c:3:2} + (255 - 0x${c:3:2}) * 40 / 100))
  b=$((0x${c:5:2} + (255 - 0x${c:5:2}) * 40 / 100))
  (( r > 255 )) && r=255
  (( g > 255 )) && g=255
  (( b > 255 )) && b=255
  colors2+=( "#$(printf '%02X%02X%02X' "$r" "$g" "$b")" )
done

get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null \
    | awk 'NR==1 {gsub(/%/,"",$5); print $5}' \
    || echo 100
}

draw_volume_bar() {
  local vol="$1"
  local blocks=10
  local filled=$((vol * blocks / 100))
  local bar=""
  for ((i = 0; i < blocks; i++)); do
    if (( i < filled )); then
      bar+="<span foreground=\"#eeeeee\">█</span>"
    else
      bar+="<span foreground=\"#444\">░</span>"
    fi
  done
  echo -n "🔊 $bar "
}

config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
framerate = $framerate
bars = $bars
bar_width = 2
bar_spacing = 4
autosens = 1
overshoot = 25
lower_cutoff_freq = 35
higher_cutoff_freq = 17500
sensitivity = 180

[input]
method = pipewire
source = auto
sample_rate = 48000
sample_bits = 32
channels = 2
autoconnect = 2

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
bit_format = 65530
channels = mono
mono_option = average
reverse = 0

[smoothing]
integral = 0
gravity = 200
noise_reduction = 0
monstercat = 1
waves = 1    

[eq]
1 = 2
2 = 1
3 = 1
4 = 1
5 = 1
6 = 2
7 = 2
8 = 2
9 = 2
10 = 2
11 = 2
12 = 2
13 = 2
14 = 2
15 = 2
16 = 2
EOF

pkill -f "cava -p $config_file" 2>/dev/null

pulse_state=0
frame_count=0
volume=$(get_volume)

stdbuf -oL cava -p "$config_file" | while IFS= read -r line; do
  
  if (( frame_count % 5 == 0 )); then
    volume=$(get_volume)
    (( volume < 5 )) && volume=5
  fi
  ((frame_count++))

  raw=${line//[[:space:];]/}
  output=""

  for ((i = 0; i < ${#raw}; i++)); do
    level=${raw:$i:1}
    [[ "$level" =~ ^[0-7]$ ]] || continue

    if [[ "$volume_scaled" == true ]]; then
      scaled_level=$(( level * volume / 100 ))
      (( scaled_level > 7 )) && scaled_level=7
    else
      scaled_level=$level
    fi

    glyph="${bar[$scaled_level]}"
    base_color="${colors1[$scaled_level]}"
    if [[ "$pulse_enabled" == true && "$pulse_state" == 1 ]]; then
      base_color="${colors2[$scaled_level]}"
    fi

    output+="<span foreground=\"$base_color\">$glyph</span>"
  done

  pulse_state=$((1 - pulse_state))
  echo "$(draw_volume_bar "$volume")$output"
done || echo "$fallback_icon"

