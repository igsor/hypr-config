-- standalone
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1200@60.00000",
    position = "0x0",
    scale    = 1,
    vrr      = 0,
})

-- set default sink to built-in speakers, mute them
local sink = "alsa_output.pci-0000_04_00.6.analog-stereo"
hl.exec_cmd("pactl set-default-sink " .. sink)
hl.exec_cmd("pactl set-sink-volume " .. sink .. " 0")
hl.exec_cmd("pactl set-sink-mute " .. sink .. " true")
