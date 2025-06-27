function rename_songs()

local objects_to_rename = {
  "macro",
  "page",
  "view",
  "page",
  "timecode"
}
j = 1
for i=5001,5050 do
  local h = gma.show.getobj.handle("seq "..i)
  local label = gma.show.getobj.label(h)
  gma.echo("Current label: ", label)
  gma.user.setvar("philsong"..j, string.format("%s", label))
  for _,v in pairs(objects_to_rename) do
    local cmd = ""
    if v == "view" then
      cmd = "label " .. v .. " " .. i+1000 .. " \"" .. label .."\""
    else
      cmd = "label " .. v .. " " .. i .. " \"" .. label .. "\""
    end
    -- gma.echo("Sending command: "..cmd)
    gma.cmd(cmd)
  end
  j = j + 1
end


end