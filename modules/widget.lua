local ViewTypes = require("modules/view_types")

--- @class Widget
--- @field index? number
--- @field scroll? number
--- @field offset? number | nil
--- @field x? number | string
--- @field y? number
--- @field rows? number
--- @field cols? number
--- @field type string
--- @field symbol_size number
--- @field data string
---
local M = {}

M.parameters = {
	"$index",
	"$type",
	"$x",
	"$y",
	"$rows",
	"$cols",
	"$offset",
	"$scroll",
	"$data",
}

M.template =
	'<Widget index="$index" type="$type" display_nr="1" $x y="$y" anz_rows="$rows" anz_cols="$cols" scroll_offset="$offset" scroll_index="$scroll">$data</Widget> '

M.get_data = function(symbol_size)
	local data_template = [[
			<Data>
				<Data>0</Data>
        <Data>$symbol_size</Data>
				<Data>0</Data>
				<Data>3</Data>
			</Data>
    ]]
	return string.gsub(data_template, "$symbol_size", symbol_size)
end

--- @param view Widget
M.get_widget = function(view)
	if view.type == nil then
		-- got garbage value
		gma.echo("Err with type: " .. view.index)
		return
	end

	-- normalize string
	view.type = string.lower(view.type)
	local preset_hex_value = ""

	if string.find(view.type, "preset") or tonumber(view.type) ~= nil then
		-- check if preset number or in the "Preset15" type or variation
		local preset = view.type:gsub("preset", "")
		preset_hex_value = ViewTypes.get_type_number(tonumber(preset)) or ""
	elseif ViewTypes[view.type] == nil or view.type == "" then
		return nil, "Item type does not exist"
	else
		preset_hex_value = string.format("%x", ViewTypes[view.type])
	end

	view.index = view.index or 0
	view.scroll = view.scroll or 1
	view.x = view.x and string.format('has_focus="true" has_scrollfocus="true" x="%d"', view.x) or ""
	view.y = view.y or 1
	view.rows = view.rows or 1
	view.cols = view.cols or 16
	view.offset = view.offset ~= nil and (view.scroll - view.offset) or view.scroll

	local symbol_size = tonumber(view.type, 16) >= ViewTypes.all
	local data = M.get_data((symbol_size and "1" or "0"))
	local result = M.template

	view.type = preset_hex_value
	view.data = data
	for _, v in pairs(M.parameters) do
		result = result:gsub(v, view[v:sub(2)])
	end
	return result
end
-- local v = { index = 0, type = "all", y = 3 }
-- print(M.get_widget(v))
return M
