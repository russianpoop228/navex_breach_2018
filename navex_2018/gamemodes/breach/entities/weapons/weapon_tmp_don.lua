--[[
gamemodes/breach/entities/weapons/weapon_tmp_don.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/gfx/vgui/tmp")
	SWEP.BounceWeaponIcon = false
end

SWEP.Author			= "McVipeR"

SWEP.ViewModelFOV	= 60
SWEP.ViewModelFlip	= true
SWEP.HoldType		= "smg"
SWEP.ViewModel 		= "models/weapons/v_b_t_mp9.mdl"
SWEP.WorldModel		= "models/weapons/w_brugger_thomet_mp9.mdl"
SWEP.PrintName		= "TMP"
SWEP.Base			= "weapon_breach_base"
SWEP.DrawCrosshair	= false
SWEP.Slot			= 3
SWEP.Spawnable		= true

SWEP.Primary.ClipSize		= 40
SWEP.Primary.DefaultClip	= 280
SWEP.Primary.Sound			= Sound("Weapon_mp9.Single")
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 2.15
SWEP.Primary.Cone			= 0.022
SWEP.Primary.Delay			= 0.07

SWEP.Secondary.Ammo			= "none"
SWEP.DeploySpeed			= 1
SWEP.Damage					= 7
SWEP.HeadshotMultiplier		= 2.35
SWEP.UseHands				= true

SWEP.CSMuzzleFlashes 		= false
SWEP.CSMuzzleX				= false

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}
SWEP.IDK					= 120
SWEP.ZoomFov				= 90
SWEP.HasScope				= false
SWEP.DrawCustomCrosshair	= false


