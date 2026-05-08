--[[
gamemodes/breach/entities/weapons/weapon_scp_008_2.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_zombie")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName				= "SCP-008-2"			
SWEP.ViewModelFOV			= 75
SWEP.ViewModelFlip			= false
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Instructions			= [[ЛКМ - ударить]]

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay          =  0.8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay        = 0.8
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/v_zombiearms.mdl"
SWEP.WorldModel				= ""

SWEP.IconLetter				= "w"
SWEP.HoldType 				= "normal"

SWEP.ISSCP					= true
SWEP.droppable				= false

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self:SendWeaponAnim( ACT_VM_DRAW )
	end
	return true
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

function SWEP:PrimaryAttack()
	
	if (SERVER) then
	
	local ent = nil
	local tr = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 ),
		filter = self.Owner,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		mask = MASK_SHOT_HULL
	} )
	ent = tr.Entity
	
		self.Owner:GetViewModel():SetPlaybackRate( 2.5 )
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		self.Owner:GetViewModel():SetPlaybackRate( 2.5 )
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)
	
	local Chuma008Protect = {
		"armor_special",
		"armor_hazmat",
		"armor_goc",
	}
	
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				self.Owner:EmitSound( "npc/zombie/claw_strike"..math.random(1,3)..".wav" )
				ent:TakeDamage(math.random(5,15),self.Owner)
				if math.random(1,2) == 1 then
					if ent:GTeam() != TEAM_SPEC and ent:GTeam() != TEAM_SCP and ent:Alive() and !table.HasValue(Chuma008Protect, ent.UsingArmor) then
						ent:SetSCP0082()
					end
				end
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
		self.Owner:EmitSound( "npc/zombie/claw_miss1.wav" )
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay  )
end

function SWEP:SecondaryAttack()
end

