---@module 'hl'

--###############
--## MONITORS ###
--###############
-- See https://wiki.hypr.land/Configuring/Monitors/

hl.monitor({
	output = "DP-2",
	mode = "2560x1440@120",
	position = "-2560x0",
	scale = 1,
})

hl.monitor({
	output = "DP-3",
	mode = "2560x1440@120",
	position = "0x0",
	scale = 1,
	transform = 2, -- upside down
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "2560x1440@120",
	position = "2560x0",
	scale = 1,
})
