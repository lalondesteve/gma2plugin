---@class GMAObject
---@field type string
---@field label? string
---@field number? number either 15 as in group 15 or 15.14 as in preset 15.14 or 1.1.1 as in macroline
---@field setlabel fun(self: table, label: string)
---@field get_handle fun(self: table): handle | nil
---@field create fun(self: table)
_M = {}

_M.setlabel = function(self, label)
	if self.number == nil then
		gma.gui.msgbox("Error", "Missing number field to properly identify and label object")
		return
	end
	self.label = label
	local cmd = string.format('label %s %d "%s"', self.type, self.number, label)
	gma.cmd(cmd)
end

_M.get_handle = function(self)
	if self.label == nil and self.number == nil then
		gma.gui.msgbox("Error", "Missing field(s) to properly identify object and get handle")
		return
	end
	if self.number then
		return gma.show.getobj.handle(self.type .. " " .. self.number)
	end
	if self.label then
		return gma.show.getobj.handle(self.type .. " " .. self.label)
	end
end

_M.create = function(self)
	local cmd = ""
	if self.label then
		cmd = string.format('store %s %d "%s"', self.type, self.number, self.label)
	elseif self.number then
		cmd = string.format("store %s %d", self.type, self.number)
	else
		gma.gui.msgbox("Error", "Missing field to properly store object")
	end
	gma.cmd(cmd)
end

return _M
