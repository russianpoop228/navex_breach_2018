--[[
gamemodes/breach/entities/weapons/br_id_hs.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_id")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Ваш фальшивый личный ID идентификатор под МОГ"
SWEP.Instructions	= [[Покажите свою ID карту другому игроку чтобы 
идентифицировать свою личность]]

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.Base 			= "id_card_base_hs"
SWEP.ViewModel		= "models/breach/keycard.mdl"
SWEP.WorldModel		= "models/breach/keycard.mdl"
SWEP.PrintName		= "Фальшивая ID Карта"
SWEP.Slot			= 0
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "pistol"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false
SWEP.UseHands = true

SWEP.droppable				= false
SWEP.teams					= {2,3,5,6,7,8,9,10}

SWEP.ShowWorldModel 		= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:PrimaryAttack()
end

function SWEP:Holster()
	return true
end

function SWEP:SecondaryAttack()
end

function SWEP:CanPrimaryAttack()
end

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

SWEP.WElements = {
	["id_card"] = { type = "Model", model = "models/breach/keycard.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 4, -1), angle = Angle(179, -90, 90), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 5 }
}

