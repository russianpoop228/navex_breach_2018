--[[
gamemodes/breach/entities/weapons/weapon_scp_457_off.lua
--]]
if ( SERVER ) then
	SWEP.Weight          		= 0
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom			= false
end

if ( CLIENT ) then
	SWEP.PrintName			= "Без огня"
	SWEP.Slot				= 0
    SWEP.SlotPos         	= 0
    SWEP.DrawAmmo			= false
	SWEP.ViewModelFOV       = 10
	SWEP.DrawCrosshair		= false
end

SWEP.HoldType				= "normal"
SWEP.Category			    = "Other"

SWEP.Spawnable              = true
SWEP.AdminSpawnable         = true

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "None"
  
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "None"
SWEP.Secondary.Delay        = 10
SWEP.droppable				= false
SWEP.ISSCP 					= true

SWEP.NextAttackH 			= 0
SWEP.NextAttackW 			= 0
SWEP.NextReload 			= 0

function SWEP:Initialize()
	if self.SetHoldType then
		self:SetHoldType( self.HoldType or "normal" )
	else
		self:SetWeaponHoldType( "normal" )
	end
	util.PrecacheSound("scp/navex_457/nofire1.wav")
	util.PrecacheSound("scp/navex_457/nofire2.wav")
	util.PrecacheSound("scp/navex_457/nofire3.wav")
	util.PrecacheSound("scp/navex_457/nofire4.wav")
end

function SWEP:Think()
end

function SWEP:OnDrop()
   --self:Remove()
end

function SWEP:ShouldDropOnDie()
   return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
	if (SERVER) then
		self.Owner:EmitSound( "scp/navex_457/nofire"..math.random(1,4)..".wav" )
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay  )
end

function SWEP:Reload()
end

function SWEP:Deploy()
	if SERVER and IsValid(self.Owner) then
		self.Owner:DrawViewModel(false)
	end
   return true
end

function SWEP:Holster()
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end

