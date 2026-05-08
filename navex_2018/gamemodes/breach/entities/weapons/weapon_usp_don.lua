--[[
gamemodes/breach/entities/weapons/weapon_usp_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/usp45")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "pistol"
SWEP.ViewModel 		= "models/weapons/v_pist_fokkususp.mdl"
SWEP.WorldModel		= "models/weapons/w_pist_fokkususp.mdl"
SWEP.PrintName		= "USP"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 2
SWEP.Spawnable		= true

SWEP.betterone = "weapon_mtf_deagle"
SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= 120
SWEP.Primary.Sound			= Sound("Weapon_fokkususp.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 1.8
SWEP.Primary.Cone			= 0.01
SWEP.Primary.Delay			= 0.17

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 13
SWEP.HeadshotMultiplier		= 1.6
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= true
SWEP.CSMuzzleX				= true

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 125
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


