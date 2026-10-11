
-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    -- Add networkmanager applet to tray in waybar
    hl.exec_cmd("nm-applet --indicator")

    -- background
    hl.exec_cmd("wpaperd")

    -- status bar
    hl.exec_cmd("waybar")

    hl.exec_cmd("mako")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

    -- Clipboard Manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")  -- Stores only text data
    hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Stores only image data

    -- Use gtk-settings
    hl.exec_cmd("apply-gsettings")

    -- Select Kitty font size once from monitor resolution.
    hl.exec_cmd("~/.local/bin/kitty-font-autosize.sh")

    -- Hypr Ecosystem
    -- hypridle
    hl.exec_cmd("hypridle")

    -- bluetooth
    hl.exec_cmd("blueman-applet")
end)


-----------------------------
---- DYNAMIC ENVIRONMENT ----
-----------------------------

hl.on('monitor.added', function(monitor)
    local configurations = {
        ["AOC Q32G1WG4 0x000012FC"] = "~/.config/hypr/environments/home-office.lua",
        ["ONKYO Corporation HT-R494"] = "~/.config/hypr/environments/home-beamer.lua",
    }
    local environment_file = configurations[monitor.description]
    if environment_file then
        require(environment_file)
    end
end)

hl.on('monitor.removed', function(monitor)
    require('~/.config/hypr/environments/standalone.lua')
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- some env variables
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- we usually prefer things to be set up through script
-- have a look at hyprstart file


-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/
-- For kb_model check /usr/share/X11/xkb/rules/base.lst
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "altgr-intl",
        kb_model   = "pc105",
        kb_options = "",
        kb_rules   = "",

        numlock_by_default = true,
        follow_mouse       = 1,

        touchpad = {
            natural_scroll       = false,
            tap_to_click         = true,
            disable_while_typing = true,
        },

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },

    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(8f00ffee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,

        blur = {
            enabled = true,
            size    = 5,
            passes  = 3,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    master = {
        new_status = "master",
    },

    dwindle = {
        preserve_split = true, -- you probably want this
    },

    misc = {
        disable_hyprland_logo = true,
    },

    -- Performance Tweaks (For less power consumption without sacrificing performance)
    -- See : https://wiki.hyprland.org/Configuring/Performance/
    -- Hyprland 0.55+ uses debug.vfr. It defaults to true; keep it explicit here.
    debug = {
        vfr = true,
    },
})

-- Apply blur universally to all layer-shell surfaces
hl.layer_rule({
    name = "blur-all-layers",

    match = {
        namespace = ".*",
    },

    blur         = true,
    blur_popups  = true,
    ignore_alpha = 0.10,
})

-- Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

-- Gestures
hl.gesture({
    fingers   = 3,
    direction = "up",
    action    = function()
        hl.exec_cmd("garuda-toolbox")
    end,
})

hl.gesture({
    fingers   = 3,
    direction = "down",
    action    = function()
        hl.exec_cmd("nwg-drawer -mb 10 -mr 10 -ml 10 -mt 10")
    end,
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
hl.window_rule({
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    match = { title = "rofi" },
    stay_focused = true,
})

-- layer config
-- NOTE: layer rules match namespace, not class/float. Kept the useful waybar rule below.

-- status bar
hl.layer_rule({
    match        = { namespace = "waybar" },
    ignore_alpha = 0.5,
})

hl.layer_rule({
    match       = { namespace = "rofi" },
    blur        = false,
    dim_around  = true,
})

hl.layer_rule({
    match      = { namespace = ".*nwgbar.*" },
    blur       = true,
    dim_around = false,
})

---------------------
---- KEYBINDINGS ----
---------------------

local function bind_exec(keys, cmd, opts)
    hl.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
local mainMod = "SUPER"

--- Applications
bind_exec(mainMod .. " + T", "kitty")
bind_exec(mainMod .. " + E", "thunar")
bind_exec(mainMod .. " + S", "kitty nvim")
bind_exec(mainMod .. " + F", "firefox")

--- System bindings
bind_exec("XF86PowerOff", "wlogout -c 30 -r 30 -s")
bind_exec(mainMod .. " + SPACE", "pkill rofi || rofi -show drun", { release = true })
bind_exec(mainMod .. " + SHIFT + D", "nwg-drawer -mb 10 -mr 10 -ml 10 -mt 10")
bind_exec(mainMod .. " + SHIFT + R", "hyprctl reload")
bind_exec(mainMod .. " + V", "cliphist list | wofi --dmenu | cliphist decode | wl-copy")
bind_exec(mainMod .. " + SHIFT + C", "killall -9 wpaperd && wpaperd")

-- laptop-specific keys
-- volume
bind_exec('code:122', 'pamixer --decrease 5; notify-send " Volume: "$(pamixer --get-volume) -t 500')
bind_exec('code:123', 'pamixer --increase 5; notify-send " Volume: "$(pamixer --get-volume) -t 500')
bind_exec('code:121', 'pamixer --toggle-mute; notify-send " Volume: Toggle-mute" -t 500')
bind_exec('XF86AudioMicMute', 'pactl set-source-mute @DEFAULT_SOURCE@ toggle; notify-send "System Mic: Toggle-mute" -t 500')
-- brightness
bind_exec("code:232", "brightnessctl -c backlight set 5%-")
bind_exec("code:233", "brightnessctl -c backlight set +5%")

-- screenshot
hl.bind("Print", hl.dsp.exec_cmd("grimblast save screen && notify-send Screenshot captured"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast save area && notify-send Selected\\ area captured"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("grimblast save active && notify-send Active\\ window captured"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("grimblast output active && notify-send Output captured"))

--- Window bindings
hl.bind(  mainMod .. " + Q", hl.dsp.window.close())
hl.bind(  mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" })) -- 65 = Spacebar
hl.bind(  mainMod .. " + SHIFT + P", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(  mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- Move focus with mainMod + arrow keys
hl.bind(  mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(  mainMod .. " + H",     hl.dsp.focus({ direction = "l" }))
hl.bind(  mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(  mainMod .. " + L",     hl.dsp.focus({ direction = "r" }))
hl.bind(  mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(  mainMod .. " + K",     hl.dsp.focus({ direction = "u" }))
hl.bind(  mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))
hl.bind(  mainMod .. " + J",     hl.dsp.focus({ direction = "d" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(  mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(  mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- for resizing window
hl.bind(  mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    -- sets repeatable binds for resizing the active window
    hl.bind("right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
    hl.bind("L",     hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
    hl.bind("left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
    hl.bind("H",     hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })
    hl.bind("K",     hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })
    hl.bind("J",     hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })

    -- use reset to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- to move window
hl.bind(  mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(  mainMod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "u" }))
hl.bind(  mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "d" }))
hl.bind(  mainMod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "d" }))
hl.bind(  mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(  mainMod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "l" }))
hl.bind(  mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(  mainMod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "r" }))


--- Workspace bindings
-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
end

-- Move to workspace with focused container with ALT + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("ALT + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
end

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(  mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(  mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
