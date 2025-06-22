require("gma_api")

local common = require("common")
local uservars = common.uservars
local cmd = common.cmd
local validate_input = common.validate_input

local view = require("view_items")

--[[
==============================================================================
grandMA2 LUA Plugin: Song Setup
Description: Plugin to setup pool items, song macros and sequences
Author: Steve Lalonde
Version: 1.0
==============================================================================
]]

local function create_song_view(song_name, song_pool_number, song_number)
	local xmlfile = view.getXML(
		song_name,
		uservars.fixed_pool_item_number,
		song_pool_number,
		song_pool_number - 1 + song_number * 62
	)
	local xmlpath = gma.show.getvar("path") .. "/importexport/"
	local current_view = "view_" .. song_name
	local filename = xmlpath .. current_view .. ".xml"
	local file, err = io.open(filename, "w")
	if not file then
		err = "Error opening file: " .. err
		return false, err
	end
	file:write(xmlfile)
	file:close()
	gma.cmd("selectdrive 1")
	cmd('import "%s" at view %s /o /nc', { current_view, song_pool_number })
	gma.cmd("delete screen " .. uservars.view_screen)
	local view_cmd = "view " .. song_pool_number .. " /screen=" .. uservars.view_screen
	gma.cmd(view_cmd)
	gma.sleep(0.1)
	gma.cmd("store " .. view_cmd)

	os.remove(filename)
	return true, nil
end

local function create_pool_items(
	amount --[[int]],
	start_number --[[int]]
)
	local j = 1
	for i = start_number, start_number + amount - 1 do
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
		local r, err = create_song_view(song, i, j - 1)
		if not r then
			gma.feedback(err)
			break
		end
		-- cmd("store view %d /screen=%d", { i, uservars.view_screen })
		-- cmd('assign view %d /name="%s"', { i, song })
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

	local fix_pool_item_str = gma.textinput("Enter the fixed pool item number", "5001")
	if validate_input(fix_pool_item_str) == false then
		return
	end
	uservars.fixed_pool_item_number = tonumber(fix_pool_item_str) - 1

	local first_pool_item_str = gma.textinput("Enter the starting songs pool item", "6001")
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
