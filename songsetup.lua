require("gma_api")

--[[
==============================================================================
grandMA2 LUA Plugin: Song Setup
Description: Plugin to setup pool items, song macros and sequences
Author: Steve Lalonde
Version: 1.0
==============================================================================
]]

local uservars = {
	user_suffix = "_vx",
	fixed_page_name = "FixedPage",
	show_exec_name = "ShowExec",
	page_turn_name = "PageTurn",
	page_turn_macro_number = "",
	view_screen = "",
	main_executor = "29",
	objects_to_setup = { "Sequence", "Macro", "Page", "Timecode", "View" },
}

local function validate_input(_input)
	if _input == nil or _input == "" then
		gma.feedback("Plugin cancelled by user")
		return false
	end
	return true
end

local function get_label(_id)
	return gma.show.getobj.label(gma.show.getobj.handle(_id))
end

local function cmd(
	template --[[string]],
	args --[[table]]
)
	gma.feedback(template)
	gma.feedback(table.unpack(args))
	local s = string.format(template, table.unpack(args))
	gma.feedback("Sending cmd", s)
	gma.cmd(s)
	return nil
end

local function create_pool_items(
	amount --[[int]],
	start_number --[[int]]
)
	local j = 1
	for i = start_number, start_number + amount do
		local song = "Song" .. j .. uservars.user_suffix
		for _, pool_id in pairs(uservars.objects_to_setup) do
			if pool_id:lower() ~= "view" then
				cmd('store %s %d "%s" /o /nc', { pool_id, i, song })
				if pool_id:lower() == "page" then
					cmd("assign seq %d at exec %d.%d", { i, i, uservars.main_executor })
				end
				if pool_id:lower() == "macro" then
					cmd("store macro 1.%d.1 thru 2", { i })
				end
			end
		end
		cmd("store view %d /screen=%d", { i, uservars.view_screen })
		cmd('assign view %d /name="%s"', { i, song })
		j = j + 1
	end
	return nil
end

local function main()
	gma.feedback("Starting song setup plugin ... ")

	-- get user input
	local song_amount_str = gma.textinput("Enter the amount of songs to setup:", "50")
	if validate_input(song_amount_str) == false then
		return
	end

	local first_pool_item_str = gma.textinput("Enter the starting pool item", "6001")
	if validate_input(first_pool_item_str) == false then
		return
	end

	local user_exec = gma.textinput("Enter the main executor number", "29")
	if validate_input(user_exec) == false then
		return
	end
	uservars.main_executor = user_exec

	local view_screen = gma.textinput("Which screen shall we create the views on?", "3")
	if validate_input(view_screen) == false then
		return
	end

	uservars.view_screen = view_screen

	local page_turn_macro = gma.textinput("At what macro number shall we create the page turn macro?", "6000")
	if validate_input(view_screen) == false then
		return
	end

	uservars.page_turn_macro = page_turn_macro

	local fixed_page = gma.textinput("What page shall be your fixed executors page?", "6000")
	if validate_input(fixed_page) == false then
		return
	end

	-- static stuff
	gma.feedback("Setting up fixed page and pageturn macro")
	gma.user.setvar(uservars.fixed_page_name, fixed_page)
	gma.user.setvar(uservars.show_exec_name, user_exec)
	cmd("store page %d %s", { fixed_page, uservars.fixed_page_name .. uservars.user_suffix })
	cmd('store macro %d "%s"', { uservars.page_turn_macro, uservars.page_turn_name .. uservars.user_suffix })
	-- check if a page turn already exists with the same name?
	cmd("store macro 1.%d.1 thru 4", { uservars.page_turn_macro })

	-- str to int all the things
	local song_amount = tonumber(song_amount_str)
	local first_pool_item = tonumber(first_pool_item_str)

	-- create all the stuff
	gma.feedback("Starting to create the per song objects")
	create_pool_items(song_amount, first_pool_item)
end
return main
