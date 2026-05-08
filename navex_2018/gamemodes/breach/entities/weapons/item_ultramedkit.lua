--[[
gamemodes/breach/entities/weapons/item_ultramedkit.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_medkit")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Лечите себя либо других"
SWEP.Instructions	= [[ЛКМ - лечить себя
ПКМ - лечить игрока]]

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.WorldModel		= "models/mishka/models/firstaidkit.mdl"
SWEP.PrintName		= "Большая аптечка"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.Uses					= 3
SWEP.droppable				= true
SWEP.teams					= {2,3,5,6,7,8,9,10}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetSkin(2)
end
function SWEP:Think()
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
	if self.Owner:GTeam() == TEAM_SCP then return end
	if self.Owner:Health() / self.Owner:GetMaxHealth() <= 0.8 then
		self.Uses = self.Uses - 1
		if SERVER then
			self.Owner:SetHealth(self.Owner:GetMaxHealth())
			if self.Uses < 1 then
				self.Owner:StripWeapon("item_ultramedkit")
			end
		end
	else
		if CLIENT then
			if !(IsFirstTimePredicted()) then return end
			chat.AddText("Вы не нуждаетесь в лечении")
		end
	end
end
function SWEP:SecondaryAttack()
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			if(ent:GetPos():Distance(self.Owner:GetPos()) < 95) then
				if ent:Health() / ent:GetMaxHealth() <= 0.8 then
					ent:SetHealth(ent:GetMaxHealth())
					self.Uses = self.Uses - 1
					if self.Uses < 1 then
						self.Owner:StripWeapon("item_ultramedkit")
					end
				else
					self.Owner:PrintMessage(HUD_PRINTTALK, ent:Nick() .. " не требует лечения")
				end
			end
		end
	end
end
function SWEP:CanPrimaryAttack()
end

