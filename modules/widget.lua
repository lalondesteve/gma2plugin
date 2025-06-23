local ViewTypes = require("modules/view_types")
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
}

M.template =
	'<Widget index="$index" type="$type" display_nr="1" $x y="$y" anz_rows="$rows" anz_cols="$cols" scroll_offset="$offset" scroll_index="$scroll">'

M.footer = [[
			<Data>
				<Data>0</Data>
          <Data>$symbol_size</Data>
				<Data>0</Data>
				<Data>3</Data>
			</Data>
		</Widget>
    ]]

--- @class Widget
--- @field index? number
--- @field scroll? number
--- @field offset? number | nil
--- @field x? number | string
--- @field y? number
--- @field rows? number
--- @field cols? number
--- @field type string

--- @param view Widget
M.get_widget = function(view)
	if view.type == nil then
		gma.echo("Err with type: " .. view.index)
	end
	view.type = string.lower(view.type)
	if string.find(view.type, "preset") then
		local preset = view.type:gsub("preset", "")
		view.type = ViewTypes:get_type_number(tonumber(preset, 16)) or ""
	end
	if ViewTypes[view.type] == nil or view.type == "" then
		return nil, "Item type does not exist"
	end
	view.type = string.format("%x", ViewTypes[view.type])
	view.index = view.index or 0
	view.scroll = view.scroll or 1
	view.x = view.x and string.format('has_focus="true" has_scrollfocus="true" x="%d"', view.x) or ""
	view.y = view.y or 1
	view.rows = view.rows or 1
	view.cols = view.cols or 16
	view.offset = view.offset or view.scroll or 1
	local symbol_size = tonumber(view.type, 16) >= ViewTypes.all
	local foot = M.footer:gsub("$symbol_size", (symbol_size and "1" or "0"))
	local result = M.template
	for _, v in pairs(M.parameters) do
		result = result:gsub(v, view[v:sub(2)])
	end
	return result .. "\n" .. foot
end
-- local v = { index = 0, type = "all", y = 3 }
-- print(M.get_widget(v))
return M
