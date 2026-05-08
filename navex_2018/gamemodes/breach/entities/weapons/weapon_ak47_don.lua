--[[
gamemodes/breach/entities/weapons/weapon_ak47_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/ak47")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= true
SWEP.HoldType		= "ar2"
SWEP.ViewModel		= "models/weapons/v_dot_ak47.mdl"
SWEP.WorldModel		= "models/weapons/w_ak47_m9k.mdl"
SWEP.PrintName		= "AK-47"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 180
SWEP.Primary.Sound			= Sound("47ak.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.55
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.1

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 16
SWEP.HeadshotMultiplier		= 1.6
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 76
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


