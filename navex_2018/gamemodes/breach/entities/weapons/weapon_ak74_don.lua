--[[
gamemodes/breach/entities/weapons/weapon_ak74_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/hud/m9k_ak74")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 65
SWEP.ViewModelFlip	= true
SWEP.HoldType		= "ar2"
SWEP.ViewModel		= "models/weapons/v_tct_ak47.mdl"
SWEP.WorldModel		= "models/weapons/w_tct_ak47.mdl"
SWEP.PrintName		= "AK-74"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 210
SWEP.Primary.Sound			= Sound("Tactic_AK47.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.35
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.09

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 20
SWEP.HeadshotMultiplier		= 2.2
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 76
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


