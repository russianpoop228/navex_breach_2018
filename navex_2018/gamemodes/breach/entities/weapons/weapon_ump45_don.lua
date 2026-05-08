--[[
gamemodes/breach/entities/weapons/weapon_ump45_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/ump45")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= true
SWEP.HoldType		= "smg"
SWEP.ViewModel 		= "models/weapons/v_hk_ump_45.mdl"
SWEP.WorldModel		= "models/weapons/w_hk_ump45.mdl"
SWEP.PrintName		= "UMP-45"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 280
SWEP.Primary.Sound			= Sound("m9k_hk_ump45.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 0.09

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 11
SWEP.HeadshotMultiplier		= 2.35
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 105
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


