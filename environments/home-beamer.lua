-- beamer at home
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60.00000",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output="HDMI-A-1",
    mode="1920x1080@29.9",
    position="1920x0",
    scale=1,
})

-- last workspace on the beamer
hl.workspace_rule({ workspace = 10, monitor="HDMI-A-1" })

-- others on the laptop
for i = 1, 9 do
    hl.workspace_rule({ workspace = i, monitor="eDP-1" })
end

-- -- switch audio source to HDMI, 100% volume
local sink = "alsa_output.pci-0000_04_00.1.hdmi-stereo-extra1"
hl.exec_cmd("pactl set-default-sink " .. sink)
hl.exec_cmd("pactl set-sink-mute " .. sink .. " false")
hl.exec_cmd("pactl set-sink-volume " .. sink .. " 20%")
