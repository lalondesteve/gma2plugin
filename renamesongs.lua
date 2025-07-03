function rename_songs()
	local user_suffix = " _vx"
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
		gma.gui.msgbox("Error", "Bad input provided, only the lowercase letters s and m are allowed")
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
		local seq_label = label .. user_suffix
		gma.user.setvar("philsong" .. j, string.format("%s", seq_label))
		for _, v in pairs(objects_to_rename) do
			local cmd = 'label %s %d "%s"'
			if v == "view" then
				cmd = cmd:format(v, i + 1000, label)
			elseif v == "seq" then
				cmd = cmd:format(v, i, seq_label)
			else
				cmd = cmd:format(v, i, label)
			end
			-- gma.echo("Sending command: "..cmd)
			gma.cmd(cmd)
		end
		j = j + 1
	end
end
