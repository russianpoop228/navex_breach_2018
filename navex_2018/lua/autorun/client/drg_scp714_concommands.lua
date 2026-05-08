--[[
lua/autorun/client/drg_scp714_concommands.lua
--]]
concommand.Add("drop714", function()
  if not GetConVar("scp714_removable"):GetBool() then
    chat.AddText("The ring seems to be stuck to your finger.")
  elseif LocalPlayer():GetNWBool("Wearing714") then
    net.Start("Drop714")
    net.SendToServer()
  else
    chat.AddText("You are not wearing SCP-714.")
  end
end)


