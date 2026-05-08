--[[
gamemodes/breach/entities/weapons/weapon_chaos_famas.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/famas")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "ar2"
SWEP.ViewModel 		= "models/weapons/v_tct_famas.mdl"
SWEP.WorldModel		= "models/weapons/w_tct_famas.mdl"
SWEP.PrintName		= "FAMAS"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.betterone = "weapon_chaos_ak47"
SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Sound			= Sound("Weapon_FAMTC.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.9
SWEP.Primary.Cone			= 0.0035
SWEP.Primary.Delay			= 0.06

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 18
SWEP.HeadshotMultiplier		= 1.6
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= true
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 90
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


