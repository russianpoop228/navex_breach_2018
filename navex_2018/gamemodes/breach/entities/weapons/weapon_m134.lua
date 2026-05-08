--[[
gamemodes/breach/entities/weapons/weapon_m134.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/hud/m9k_minigun")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 65
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "shotgun"
SWEP.ViewModel		= "models/weapons/v_minigunvulcan.mdl"
SWEP.WorldModel		= "models/weapons/w_m134_minigun.mdl"
SWEP.PrintName		= "M134"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 500
SWEP.Primary.DefaultClip	= 1500
SWEP.Primary.Sound			= Sound("BlackVulcan.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.5
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.025

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 16
SWEP.HeadshotMultiplier		= 1.8
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 90
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


