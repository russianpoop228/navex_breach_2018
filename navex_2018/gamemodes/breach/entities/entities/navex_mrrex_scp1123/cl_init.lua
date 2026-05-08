--[[
gamemodes/breach/entities/entities/navex_mrrex_scp1123/cl_init.lua
--]]
include("shared.lua");

function ENT:Draw()
  self:DrawModel();
  local ply = LocalPlayer()
	if ply:GetPos():Distance(self:GetPos()) > 150 then
		return
	end
	if IsValid(self) then
		if DrawInfo != nil then
			cam.Start2D()
				DrawInfo(self:GetPos() + Vector(0,0,15), "SCP-1123", Color(255,255,255, 75))
			cam.End2D()
		end
	end
end


