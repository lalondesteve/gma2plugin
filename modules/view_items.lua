local M = {}

local widget = require("modules/widget")

local getView = function(fixed_number, song_pool_number, pool_number)
	-- song_pool_number needs to replace the pool number for views
	-- for views on the same y values, an x needs to be provided and one of them requires the ha_focus and has_scrollfocus
	-- hence the weird table manipulation.
	-- todo, make this better functions and something more straightforward
	return {
		view0 = {
			type = "view",
			scroll = fixed_number,
			y = 7,
			cols = 8,
		},
		view1 = {
			type = "view",
			scroll = song_pool_number,
			y = 7,
			x = 8,
			cols = 8,
			offset = 3,
		},
		all = { type = "all", scroll = pool_number, y = 5, rows = 2, cols = 16 },
		group0 = { type = "group", scroll = pool_number, y = 3, cols = 9 },
		group1 = { type = "group", scroll = fixed_number, y = 3, x = 9, cols = 7 },
		group2 = { type = "group", scroll = pool_number + 8, y = 4, cols = 16 },
		media = { type = "preset15", scroll = pool_number, y = 2, cols = 16 },
		effect0 = { type = "effect", scroll = pool_number, y = 1, cols = 16 },
		effect1 = { type = "effect", scroll = fixed_number, y = 0, cols = 16 },
	}
end

local buildViewFile = function(view_name, widgets)
	local footer = " </View> </MA>"
	local header = [[

<?xml version="1.0" encoding="utf-8"?>
<MA xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.malighting.de/grandma2/xml/MA" xsi:schemaLocation="http://schemas.malighting.de/grandma2/xml/MA http://schemas.malighting.de/grandma2/xml/3.9.60/MA.xsd" major_vers="3" minor_vers="9" stream_vers="60">
	<View index="0" name="%s"  display_mask="1">
		<BitMap>
      <Image />
		</BitMap>

    ]]

	return string.format(header, view_name) .. widgets .. footer
end

function M.getXML(view_name, fixed_number, song_pool_number, pool_items_number)
	local views = getView(fixed_number, song_pool_number, pool_items_number)
	local widgets = ""
	local index = 0
	for _, v in pairs(views) do
		v.index = index
		local this_widget = widget.get_widget(v)
		if this_widget == nil then
			gma.feedback("Nil widget received...", v.type, this_widget)
		else
			widgets = widgets .. "\n" .. this_widget
		end
		index = index + 1
	end
	return buildViewFile(view_name, widgets)
end

return M
