--[[
gamemodes/breach/entities/weapons/weapon_scp_860.lua
--]]
SWEP.PrintName				= "SCP-860-2"			
SWEP.ViewModelFOV 			= 56
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Instructions	= [[ЛКМ - Накинуться]]

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

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	util.PrecacheSound("weapons/scp096/hit.mp3")
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
			if (ent:GTeam() != TEAM_SPEC) and (ent:GTeam() != TEAM_SCP) then
				ent:TakeDamage(math.random(20, 25), self.Owner, self.Owner)
			end
		else
			if ent:GetClass() == "func_breakable" then
				self.Owner:EmitSound( "weapons/scp096/hit.mp3" )
				ent:TakeDamage(100, self.Owner, self.Owner)
			end
		end
	end
end

SWEP.NextSecondary = 0
function SWEP:SecondaryAttack()
	--[[
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if CurTime() < self.NextSecondary then return end
	self.NextSecondary = CurTime() + self.Secondary.Delay
	if SERVER then
		local fent = ents.FindInSphere(self.Owner:GetPos(), 300)
		local hp = 0
		local totalheal = 0
		for k, v in pairs(fent) do
			if v:IsPlayer() then
				if v:GTeam() != TEAM_SPEC and v != self.Owner then
					hp = v:Health() + math.random(5, 15)
					if hp > v:GetMaxHealth() then hp = v:GetMaxHealth() end
					totalheal = totalheal + (hp - v:Health())
					v:SetHealth(hp)
					hp = 0
				end
			end
		end
		if totalheal > 0 then self.Owner:AddExp(totalheal, false) end
	end
	]]--
	return true;
end

function SWEP:DrawHUD()
	if disablehud == true then return end
end

