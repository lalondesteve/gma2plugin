function rename_songs()
	local objects_to_rename = {
		"seq",
		"macro",
		"page",
		"view",
		"page",
		"timecode",
	}
	local j = 1
	local source = gma.textinput("Rename from sequence or macro? (write s or m)")
	source = source:lower()
	if source and source ~= "s" or source ~= "m" then
		gma.gui.msgbox("Error", "Bad input provided, only the letters s and m are allowed")
	else
		return
	end
	if source == "s" then
		source = "seq"
	else
		source = "macro"
	end

	for i = 5001, 5050 do
		local h = gma.show.getobj.handle(source .. " " .. i)
		local label = gma.show.getobj.label(h)
		gma.echo("Current label: ", label)
		gma.user.setvar("philsong" .. j, string.format("%s", label))
		for _, v in pairs(objects_to_rename) do
			if v == source then
				goto continue
			end
			local cmd = ""
			if v == "view" then
				cmd = string.format('label %s %d "%s"', v, i + 1000, label)
				-- cmd = "label " .. v .. " " .. i + 1000 .. ' "' .. label .. '"'
			else
				cmd = string.format('label %s %d "%s"', v, i, label)
				-- cmd = "label " .. v .. " " .. i .. ' "' .. label .. '"'
			end
			-- gma.echo("Sending command: "..cmd)
			gma.cmd(cmd)
			::continue::
		end
		j = j + 1
	end
end

