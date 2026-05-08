--[[
gamemodes/breach/entities/weapons/keycard_level1.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycard1")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Карта доступа"
SWEP.Instructions	= "Дает вам возможность открывать двери 1 уровня"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/breach/keycard.mdl"
SWEP.WorldModel		= "models/breach/keycard.mdl"
SWEP.PrintName		= "Карта доступа 1 уровень"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.clevel					= 1
SWEP.teams					= {2,3,5,6,7,8,9,10}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:GetBetterOne()
	local r = math.random(1,100)
	if buttonstatus == 3 then
		if r < 50 then
			return "keycard_level2"
		else
			return "keycard_level1"
		end
	elseif buttonstatus == 4 then
		if r < 20 then
			return "keycard_level3"
		elseif r < 40 then
			return "keycard_level2"
		else
			return "keycard_level1"
		end
	end
	return "keycard_level1"
end
function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end
function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
  local ply = LocalPlayer()
	if ply:GetPos():Distance(self:GetPos()) > 150 then
		return
	end
end
function SWEP:Initialize()
	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetSkin(0)
end
function SWEP:Think()
end
function SWEP:Reload()
end
function SWEP:PrimaryAttack()
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end

