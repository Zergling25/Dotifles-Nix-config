local wezterm = require("wezterm")

return {
    front_end = "OpenGL",
    color_scheme = "cyberpunk",
    enable_wayland = true,

    disable_default_key_bindings = true,
    keys = {
        { key = [[\]], mods = "CTRL|ALT", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
        { key = [[\]], mods = "CTRL", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
        { key = "q", mods = "CTRL", action = wezterm.action({ CloseCurrentPane = { confirm = false } }) },
        { key = "h", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
        { key = "l", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
        { key = "k", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = "j", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
        { key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
        { key = "Tab", mods = "CTRL", action = wezterm.action({ ActivateTabRelative = 1 }) },
        { key = "Tab", mods = "CTRL|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
        { key = "x", mods = "CTRL", action = "ActivateCopyMode" },
        { key = "v", mods = "CTRL|SHIFT", action = wezterm.action({ PasteFrom = "Clipboard" }) },
        { key = "c", mods = "CTRL|SHIFT", action = wezterm.action({ CopyTo = "Clipboard" }) },
    },

    font = wezterm.font("CaskaydiaCove Nerd Font"),
    font_size = 16.0,

    automatically_reload_config = true,
    window_decorations = "NONE",
    inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
    window_background_opacity = 0.85,
    window_close_confirmation = "NeverPrompt",

    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    show_tab_index_in_tab_bar = true,
    tab_bar_at_bottom = false,
    use_fancy_tab_bar = false,
    enable_wayland = true,
   colors = {
    tab_bar = {
        -- Neon magenta across the entire bar
        background = "#ff00ff",
        inactive_tab_edge = "#ff00ff",

        active_tab = {
            bg_color = "#ff00ff", -- same as bar
            fg_color = "#000000", -- black text for contrast
            intensity = "Bold",
        },

        inactive_tab = {
            bg_color = "#ff00ff", -- same as bar
            fg_color = "#222222", -- dark gray text so it's visible but subtle
        },

        inactive_tab_hover = {
            bg_color = "#ff66ff", -- lighter magenta glow
            fg_color = "#000000",
            italic = true,
        },

        new_tab = {
            bg_color = "#ff00ff",
            fg_color = "#222222",
        },

        new_tab_hover = {
            bg_color = "#ff66ff",
            fg_color = "#000000",
            italic = true,
        },
    },
},


    window_frame = {
        active_titlebar_bg = "#0a0a0f",
        inactive_titlebar_bg = "#1a1a26",
        font = wezterm.font { family = "Roboto", weight = "Bold" },
        font_size = 12.0,
    },
}

