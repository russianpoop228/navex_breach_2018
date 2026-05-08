--[[
gamemodes/breach/entities/weapons/weapon_scp_166.lua
--]]
SWEP.PrintName				= "SCP-001-KS"			
SWEP.ViewModelFOV 			= 56
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Instructions	= [[ЛКМ - лечить
ПКМ - нанести урон]]

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        = 2
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "None"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo		= "None"

SWEP.ISSCP 				= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}

SWEP.Weight				= 3
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false
SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.IconLetter			= "w"
SWEP.HoldType 			= "normal"

SWEP.NextAttackH 			= 0
SWEP.NextAttackW 			= 0
SWEP.NextReload 			= 0

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self:SendWeaponAnim( ACT_VM_DRAW )
	end
	return true
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end


function SWEP:Holster()
	return true;
end

function SWEP:Think()
	if postround then return end
	--
end

SWEP.NextPrimary = 0
function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextPrimary then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if SERVER then
		local tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 150,
			maxs = Vector(10, 10, 10),
			mins = Vector(-10, -10, -10),
			filter = self.Owner,
			mask = MASK_SHOT
		})
		local ent = tr.Entity
		if !IsValid(ent) then return end
		if ent:IsPlayer() then
			if ent:GTeam() != TEAM_SPEC then
				if ent:GTeam() == TEAM_SCP then
					if ent:Health() == ent:GetMaxHealth() then return end
					local hp = ent:Health() + math.random(20, 30)
					if hp > ent:GetMaxHealth() then hp = ent:GetMaxHealth() end
					self.Owner:AddExp(30, false)
					ent:SetHealth(hp)
				else
					if ent:Health() < 100 then
						if ent:Health() == ent:GetMaxHealth() then return end
						local hp = ent:Health() + math.random(20, 30)
						if hp > ent:GetMaxHealth() then hp = ent:GetMaxHealth() end
						self.Owner:AddExp(30, false)
						ent:SetHealth(hp)
					end
				end
			end
		else
			if ent:GetClass() == "func_breakable" then
				ent:TakeDamage(100, self.Owner, self.Owner)
			end
		end
	end
end

SWEP.NextSecondary = 0
function SWEP:SecondaryAttack()
	if self.NextAttackH > CurTime() then return end
	self.NextAttackH = CurTime() + 1
	
	if (SERVER) then
	
		local ent = nil
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
			filter = self.Owner,
			mins = Vector( -10, -10, -10 ),
			maxs = Vector( 10, 10, 10 ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				if self.Owner:Health() > 4500 then return end
				ent:TakeDamage(10,self.Owner)
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
			
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end
    
end

