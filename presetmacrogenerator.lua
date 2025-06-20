require(gma)


--[[
==============================================================================
grandMA2 LUA Plugin: Preset Macro Generator
Description: Plugin to create media macro automatically from presets
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

local function get_name(_id)
  return gma.show.getobj.label(gma.show.getobj.handle(_id))
end

local function get_name_and_cmdline(preset_bank, preset_number)
  local _bank_name = get_name("presettype " .. preset_bank)
  local _preset = 'Preset "' .. _bank_name .. '".' .. preset_number
  local _name = get_name(_preset)
  if _name == nil or _name == "" then
    return nil
  end
  local _new_name = _name:gsub(" ", "_")
  gma.cmd("label " .. _preset .. ' "' .. _new_name .. '"')
  return _new_name
  --
end
local function main()
  gma.feedback("Starting Preset Macro Generator...")
  local preset_bank = gma.textinput("Enter preset bank number", "15")
  if validate_input(preset_bank) == false then
    return
  end
  local start_preset_str = gma.textinput("Enter first media preset number:", "19")
  if validate_input(start_preset_str) == false then
    return
  end
  local last_preset_str = gma.textinput("Enter last media preset:", "50")
  if validate_input(last_preset_str) == false then
    return
  end
  local macro_num_str = gma.textinput("Enter the starting macro number", "5403")
  if validate_input(macro_num_str) == false then
    return
  end

  local start_preset = tonumber(start_preset_str)
  local last_preset = tonumber(last_preset_str)
  local macro_num = tonumber(macro_num_str)

  if start_preset == nil or last_preset == nil or macro_num == nil or last_preset < start_preset then
    gma.feedback("Error: Invalid input. Please enter valid numbers.")
    return
  end

  local current_macro = macro_num
  for preset = start_preset, last_preset do
    local _new_name = get_name_and_cmdline(preset_bank, preset)
    if _new_name == nil then
      goto continue
    end
    local _macro = "macro 1." .. current_macro
    gma.cmd("delete " .. _macro)
    gma.cmd("store " .. _macro .. ' "' .. _new_name:gsub("_", " ") .. '"')
    gma.cmd("store " .. _macro .. ".1 thru 2")
    gma.cmd("assign " .. _macro .. '.1 /cmd="at preset ' .. preset_bank .. "." .. _new_name .. '"')
    gma.cmd("assign " .. _macro .. '.2/cmd="feature source.2"')
    current_macro = current_macro + 1
    ::continue::
  end
  --
end
return main
