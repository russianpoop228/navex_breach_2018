--[[
gamemodes/breach/entities/weapons/keycard_level3.lua
--]]

-----------------------------------------------------
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycard3")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Карта доступа"
SWEP.Instructions	= "Дает вам возможность открывать двери 3 уровня"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/breach/keycard.mdl"
SWEP.WorldModel		= "models/breach/keycard.mdl"

SWEP.PrintName		= "Карта доступа 3 уровень"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.clevel					= 3
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
			return "keycard_level4"
		else
			return "keycard_level3"
		end
	elseif buttonstatus == 4 then
		if r < 20 then
			return "keycard_level5"
		elseif r < 40 then
			return "keycard_level4"
		else
			return "keycard_level3"
		end
	end
	return "keycard_level3"
end
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
end
function SWEP:SecondaryAttack()
end
function SWEP:CanPrimaryAttack()
end

function SWEP:DrawHUD()
	local coordx = ScrW()-256-194-100;
	local coordy = ScrH()-15-128;
	surface.SetDrawColor(255, 255, 255);
	surface.SetMaterial(Material("navex098/keycard/key3.png"));
	surface.DrawTexturedRect(coordx, coordy, 256, 128);
end

