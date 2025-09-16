#!/usr/bin/env python3
import subprocess
import sys
import time
import re
import math

# === ARGS & DEFAULTS ===

channel_mode  = sys.argv[1] if len(sys.argv) > 1 else "stereo"
theme_a       = sys.argv[2] if len(sys.argv) > 2 else "aurora"
theme_b       = sys.argv[3] if len(sys.argv) > 3 else "arch"
switch_speed  = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0

bars             = 50
framerate        = 60
fallback_icon    = "🔇"
volume_scaled    = False
color_switching  = False   # toggle for palette blending

bar_chars = ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█"]

# === PALETTES DEFINITION ===

theme_colors = {
    "arch":     "#1793d1 #1bb6e8 #33c3ee #4fd0f4 #66ddfa #80eaff #99f7ff #b3ffff".split(),
    "teal":     "#005f5f #007f7f #009f9f #00bfbf #00dfdf #00ffff #40ffff #80ffff".split(),
    "opensuse": "#28b741 #33c34d #3fd159 #59dd73 #73e68c #8cff99 #a6ffb3 #c0ffcc".split(),
    "sunset":   "#ff4d4d #ff704d #ff944d #ffb84d #ffd24d #ffe64d #fff94d #ffff80".split(),
    "aurora":   "#7f00ff #9933ff #b366ff #cc99ff #99ccff #66e0ff #33f5ff #00ffff".split(),
    "inferno":  "#ff0000 #ff3300 #ff6600 #ff9900 #ffcc00 #ffff00 #ffff33 #ffff66".split(),
    "0led":     "#000000 #1a1a1a #333333 #4d4d4d #666666 #999999 #cccccc #ffffff".split(),
    "eq":       "#ff0000 #ff6600 #ffcc00 #ccff00 #66ff00 #ff6600 #ff3300 #ff0000".split()
}

def get_palette(name, default="inferno"):
    return theme_colors.get(name, theme_colors[default])

palette_a = get_palette(theme_a)
palette_b = get_palette(theme_b)

# === COLOR UTILITIES ===

def hex_to_rgb(h):
    return tuple(int(h[i:i+2], 16) for i in (1, 3, 5))

def rgb_to_hex(r, g, b):
    return f"#{r:02X}{g:02X}{b:02X}"

def lerp_color(c1, c2, t):
    r1, g1, b1 = hex_to_rgb(c1)
    r2, g2, b2 = hex_to_rgb(c2)
    r = int(r1 + (r2 - r1) * t)
    g = int(g1 + (g2 - g1) * t)
    b = int(b1 + (b2 - b1) * t)
    return rgb_to_hex(r, g, b)

# === VOLUME FUNCTIONS ===

def get_volume():
    try:
        out = subprocess.check_output(
            ["pactl", "get-sink-volume", "@DEFAULT_SINK@"],
            stderr=subprocess.DEVNULL
        ).decode()
        m = re.search(r"(\d+)%", out)
        return int(m.group(1)) if m else 100
    except:
        return 100

def draw_volume_bar(vol):
    blocks = 10
    filled = vol * blocks // 100
    bar = "\u200A".join(
        f'<span foreground="#eeeeee">█</span>' if i < filled
        else '<span foreground="#444">░</span>'
        for i in range(blocks)
    )
    return f"🔊 {bar} "

# === CAVA CONFIGURATION ===

config = f"""
[general]
framerate = {framerate}
bars = {bars}
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
"""

config_path = "/tmp/bar_cava_config"
with open(config_path, "w") as f:
    f.write(config)

subprocess.call(
    ["pkill", "-f", f"cava -p {config_path}"],
    stderr=subprocess.DEVNULL
)
proc = subprocess.Popen(
    ["stdbuf", "-oL", "-eL", "cava", "-p", config_path],
    stdout=subprocess.PIPE, text=True
)

# === MAIN LOOP ===

volume      = get_volume()
last_vol    = time.time()
start_time  = time.time()

try:
    for line in proc.stdout:
        now = time.time()

        # refresh volume half-secondly
        if now - last_vol >= 0.5:
            volume = max(5, get_volume())
            last_vol = now

        # compute blend factor if switching
        blend = 0.0
        if color_switching:
            raw = math.sin(2 * math.pi * switch_speed * (now - start_time))
            blend = (raw + 1) / 2

        # build and print the bar
        levels = re.sub(r"[^\d]", "", line)
        parts = []
        for ch in levels:
            lvl = int(ch)
            if volume_scaled:
                lvl = min(7, lvl * volume // 100)
            glyph = bar_chars[lvl]
            if color_switching:
                color = lerp_color(palette_a[lvl], palette_b[lvl], blend)
            else:
                color = palette_a[lvl]
            parts.append(f'<span foreground="{color}">{glyph}</span>')

        print(draw_volume_bar(volume) + "\u200A".join(parts), flush=True)

except KeyboardInterrupt:
    pass

except Exception:
    print(fallback_icon)

