--[[
gamemodes/breach/entities/weapons/weapon_m60_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/hud/m9k_m60")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 65
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "ar2"
SWEP.ViewModel		= "models/weapons/v_m60machinegun.mdl"
SWEP.WorldModel		= "models/weapons/w_m60_machine_gun.mdl"
SWEP.PrintName		= "M60"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 400
SWEP.Primary.Sound			= Sound("Weapon_M_60.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.055

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 18
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


