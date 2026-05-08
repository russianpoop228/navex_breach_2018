--[[
gamemodes/breach/entities/weapons/item_eyedrops.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_eyedrops")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Останавливает моргание на 30 секунд"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/eyedrops.mdl"
SWEP.WorldModel		= "models/vinrax/props/eyedrops.mdl"
SWEP.PrintName		= "Глазные капли"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

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
end
function SWEP:Think()
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
	OnUseEyedrops(self.Owner)
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end

