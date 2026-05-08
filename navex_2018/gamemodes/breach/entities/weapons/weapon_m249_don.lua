--[[
gamemodes/breach/entities/weapons/weapon_m249_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/m249")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "ar2"
SWEP.ViewModel		= "models/weapons/v_machinegun249.mdl"
SWEP.WorldModel		= "models/weapons/w_m249_machine_gun.mdl"
SWEP.PrintName		= "M249"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 400
SWEP.Primary.Sound			= Sound("Weapon_249M.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.08

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 12
SWEP.HeadshotMultiplier		= 1.6
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 90
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


