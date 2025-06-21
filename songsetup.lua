require("gma_api")

--[[
==============================================================================
grandMA2 LUA Plugin: Song Setup
Description: Plugin to setup pool items, song macros and sequences
Author: Steve Lalonde
Version: 1.0
==============================================================================
]]

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

local function create_pool_item(
    amount --[[int]],
    start_number --[[int]],
    pool_id --[[string]],
    view_screen --[[string]],
    vx_exec --[[string]]

)
  local j = 1
  for i = start_number, start_number + amount do
    if pool_id:find("View") == nil then
      gma.cmd("store " .. pool_id .. " " .. i .. " Song" .. j .. " /o /nc")
    else
      gma.cmd("store " .. pool_id .. " " .. i .. " /screen=" .. view_screen)
      gma.cmd("assign " .. pool_id .. " " .. i .. " /name=" .. "Song" .. j)
    end
    if pool_id:find("Page") ~= nil then
      gma.cmd("assign seq " .. i .. " at exec " .. i .. "." .. vx_exec)
    end
    if pool_id:finc("Macro") ~= nil then
      gma.cmd("store macro 1." .. i .. ".1 thru 2")
      -- store song specific cmdline
    end

    j = j + 1
  end
  --
end



-- Label Macro
-- Label Sequence
-- Label Page
-- Label Timecode
-- Label View


local function main()
  gma.feedback("Starting song setup plugin ... ")

  local song_amount_str = gma.textinput("Enter the amount of songs to setup:", "50")
  if validate_input(song_amount_str) == false then return end

  local first_pool_item_str = gma.textinput("Enter the starting pool item", "6001")
  if validate_input(first_pool_item_str) == false then return end

  local vx_exec = gma.textinput("Enter the video show executor number", "29")
  if validate_input(vx_exec) == false then return end

  local view_screen = gma.textinput("Which screen shall we create the views on?", "3")
  if validate_input(view_screen) == false then return end

  local page_turn_macro = gma.textinput("At what macro number shall we create the page turn macro?", "6000")
  if validate_input(view_screen) == false then return end

  local fixed_page = gma.textinput("What page shall be your fixed executors page?", "6000")
  if validate_input(fixed_page) == false then return end

  gma.cmd("store page " .. fixed_page .. ' "Vx_Fixed"')
  gma.user.setvar("PhilFixed", fixed_page)
  gma.cmd("store macro " .. page_turn_macro .. "/name=PageTurn")
  gma.cmd("store macro 1.PageTurn.1 thru 4")

  -- str to int all the things
  local song_amount = tonumber(song_amount_str)
  local first_pool_item = tonumber(first_pool_item_str)

  gma.user.setvar("PhilShowExec", vx_exec)

  create_pool_item(song_amount, first_pool_item, "Sequence", view_screen, vx_exec)
  create_pool_item(song_amount, first_pool_item, "Macro", view_screen, vx_exec)
  create_pool_item(song_amount, first_pool_item, "Page", view_screen, vx_exec)
  create_pool_item(song_amount, first_pool_item, "Timecode", view_screen, vx_exec)
  create_pool_item(song_amount, first_pool_item, "View", view_screen, vx_exec)




  --
end
return main
