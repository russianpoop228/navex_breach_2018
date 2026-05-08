--[[
gamemodes/breach/entities/weapons/breach_crowbar.lua
--]]

-----------------------------------------------------

AddCSLuaFile()

SWEP.PrintName = "Монтировка"
SWEP.Instructions = "ЛКМ: Ударить"
SWEP.Author = "McVipeR"
SWEP.base = "weapon_base"
SWEP.Category = "Breach"

SWEP.DrawCrosshair = false
SWEP.Weight = 5
SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 54

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.AutoSwitchTo = true
SWEP.FiresUnderwater = true
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.UseHands = true

SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false

SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= 0
SWEP.Primary.NumShots			= 0
SWEP.Primary.Cone				= 0	
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= true
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 0
SWEP.Secondary.NumShots			= 0
SWEP.Secondary.Cone		  		= 0
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic   		= true

SWEP.Secondary.Ammo         	= "none"

SWEP.droppable				= true
SWEP.teams					= {2, 3, 5, 6}

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
end

function SWEP:PrimaryAttack()
	
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:SetNextPrimaryFire(CurTime() + .5)

	local trace = self.Owner:GetEyeTrace()

	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
	
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 25
		bullet.Damage = 35
	
        self.Owner:FireBullets(bullet)
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:EmitSound( "Weapon_Crowbar.Melee_Hit" )

	else
	
		self.Weapon:EmitSound( "Weapon_Crowbar.Single" )
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)	
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
	end
	
end

function SWEP:SecondaryAttack()
	return true
end

function SWEP:Deploy()  
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	return
end


