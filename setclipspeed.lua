function set_clip_speed(clip_tempo)
	if tonumber(clip_tempo) == nil then
		gma.gui.msgbox("Invalid Input", "You must enter a numeric value")
		return
	end

	local speed = gma.user.getvar("PhilTempo") / clip_tempo
	-- gma.feedback('Speed: ', speed)
	gma.cmd('Attribute "speed" at ' .. speed)
end
