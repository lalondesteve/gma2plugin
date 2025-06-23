---@class ViewTypes
local M = {
	effect = 0x454e4749,
	filter = 0x46494c54,
	form = 0x464f524d,
	group = 0x47524f55,
	image = 0x494d4750,
	layout = 0x4c415950,
	macro = 0x4d414352,
	mask = 0x5346494c,
	executor = 0x50414745,
	sequence = 0x53455155,
	timecode = 0x54434f44,
	view = 0x56494557,
	-- presets
	all = 0x50524500,
	dimmer = 0x50524501,
	position = 0x50524502,
	gobo = 0x50524503,
	color = 0x50524504,
	beam = 0x50524505,
	focus = 0x50524506,
	control = 0x50524507,
	shapers = 0x50524508,
	video = 0x50524509,
}

function M:get_type_number(preset_number)
	if type(preset_number) ~= "number" then
		return nil
	end
	return string.format("%08x", M.all + preset_number)
end

return M
