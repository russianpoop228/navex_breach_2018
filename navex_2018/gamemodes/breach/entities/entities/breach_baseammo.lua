--[[
gamemodes/breach/entities/entities/breach_baseammo.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

ENT.Type = "anim"
ENT.AmmoID = 0
ENT.AmmoType = "Pistol"
ENT.PName = "Патроны для пистолета"
ENT.AmmoAmount = 1
ENT.MaxUses = 1
ENT.Model = Model( "models/items/boxsrounds.mdl" )

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
  
  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if activator:GTeam() != TEAM_SPEC and activator:GTeam() != TEAM_SCP then
		--local gotawep = false
		--for k,v in pairs(activator:GetWeapons()) do
		--	if v.Primary != nil then
		--		if v.Primary.Ammo == self.AmmoType then
		--			gotawep = true
		--		end
		--	end
		--end
		--if gotawep == false then
		--	activator:PrintMessage(HUD_PRINTCENTER, "У вас нету подходящего оружия")
		--	return
		--end
		if activator.MaxUses != nil then
			if self.AmmoID > #activator.MaxUses then
				for i=1, self.AmmoID do
					if activator.MaxUses[i] == nil then
						if i == self.AmmoID then
							table.ForceInsert(activator.MaxUses, 1)
							activator:EmitSound("pickitem1.ogg")
							activator:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
							self:Remove()
						else
							table.ForceInsert(activator.MaxUses, 0)
						end
					end
				end
			else
				if activator.MaxUses[self.AmmoID] >= self.MaxUses then
					activator:PrintMessage(HUD_PRINTCENTER, "Вы не можете поднять больше патронов")
					return
				else
					activator.MaxUses[self.AmmoID] = activator.MaxUses[self.AmmoID] + 1
					activator:EmitSound("pickitem1.ogg")
					activator:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
					self:Remove()
				end
			end
		else
			activator.MaxUses = {}
			if self.AmmoID != 1 then
				for i=1, self.AmmoID do
					if i == self.AmmoID then
						table.ForceInsert(activator.MaxUses, 1)
					else
						table.ForceInsert(activator.MaxUses, 0)
					end
				end
			else
				table.ForceInsert(activator.MaxUses, 1)
			end
			activator:EmitSound("pickitem1.ogg")
			activator:GiveAmmo(self.AmmoAmount, self.AmmoType, false)
			self:Remove()
		end
	end
end


function ENT:Draw()
	self:DrawModel()
	local ply = LocalPlayer()
	if ply:GetPos():Distance(self:GetPos()) > 150 then
		return
	end
	if IsValid(self) then
		if DrawInfo != nil then
			cam.Start2D()
				DrawInfo(self:GetPos() + Vector(0,0,15), self.PName, Color(255,255,255, 75))
			cam.End2D()
		end
	end
end



