--[[
gamemodes/breach/entities/effects/tstunstick_hit/init.lua
--]]

-----------------------------------------------------
function EFFECT:Init( data )
	self.Pos = data:GetOrigin()
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 25
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 2
		dlight.Size = 300
		dlight.Decay = 1000
		dlight.DieTime = CurTime() + 6
        dlight.Style = 0
	end	
end


function EFFECT:Think()
	return false	
end

function EFFECT:Render()

end


