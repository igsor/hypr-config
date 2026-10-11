-- home office
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60.00000",
    position = "2560x0",
    scale    = 1,
    vrr      = 0,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "2560x1440@59.95",
    position = "0x0",
    scale    = 1,
    vrr      = 0,
})

-- odd workspaces on the big screen
for i = 1, 5 do
    hl.workspace_rule({ workspace = i * 2 - 1, monitor="HDMI-A-1" })
end

-- even workspaces on the laptop
for i = 1, 5 do
    hl.workspace_rule({ workspace = i * 2, monitor="eDP-1" })
end

-- switch audio source to HDMI
local sink = "alsa_output.pci-0000_04_00.1.hdmi-stereo-extra1"
hl.exec_cmd("pactl set-default-sink " .. sink)
hl.exec_cmd("pactl set-sink-mute " .. sink .. " false")
