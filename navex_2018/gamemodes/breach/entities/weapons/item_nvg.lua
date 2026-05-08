--[[
gamemodes/breach/entities/weapons/item_nvg.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_nvg")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Дает возможность обнаружить SCP-966"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/nvg.mdl"
SWEP.WorldModel		= "models/mishka/models/nvg.mdl"
SWEP.PrintName		= "Обычный ПНВ"
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
	if IsValid(self.Owner) then
		self.Owner:EmitSound( "nvg/snapon.wav", 50, 100 )
	end
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end
function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetSkin(3)
end
function SWEP:Think()
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
end
function SWEP:OnRemove()
	if IsValid(self.Owner) then
		-- self.Owner:EmitSound( "nvg/snapoff.wav", 50, 100 )
	end
end
function SWEP:Holster()
	if IsValid(self.Owner) then
		self.Owner:EmitSound( "nvg/snapoff.wav", 50, 100 )
	end
	return true
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end




