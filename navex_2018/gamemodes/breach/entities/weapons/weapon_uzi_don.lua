--[[
gamemodes/breach/entities/weapons/weapon_uzi_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/hud/m9k_uzi")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "smg"
SWEP.ViewModel		= "models/weapons/v_imi_uzi01.mdl"
SWEP.WorldModel		= "models/weapons/w_uzi_imi.mdl"
SWEP.PrintName		= "UZI"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Sound			= Sound("Weapon_uzi.single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.4
SWEP.Primary.Cone			= 0.027
SWEP.Primary.Delay			= 0.055

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 16
SWEP.HeadshotMultiplier		= 2.45
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 120
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


