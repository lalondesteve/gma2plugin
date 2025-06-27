return {

	uservars = {
		user_suffix = "_vx",
		fixed_page_name = "FixedPage",
		fixed_pool_item_number = 5001,
		moving_pool_gap = 64,
		show_exec_name = "ShowExec",
		page_turn_name = "PageTurn",
		page_turn_macro_number = "",
		view_screen = "",
		main_executor = "29",
	},

	get_label = function(_id)
		return gma.show.getobj.label(gma.show.getobj.handle(_id))
	end,

	validate_input = function(_input)
		if _input == nil or _input == "" then
			gma.feedback("Plugin cancelled by user")
			return false
		end
		return true
	end,

	cmd = function(
		template --[[string]],
		args --[[table]]
	)
		gma.feedback(template)
		gma.feedback(table.unpack(args))
		local s = string.format(template, table.unpack(args))
		gma.feedback("Sending cmd :", s)
		gma.cmd(s)
	end,
}
