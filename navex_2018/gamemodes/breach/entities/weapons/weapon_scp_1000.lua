--[[
gamemodes/breach/entities/weapons/weapon_scp_1000.lua
--]]

AddCSLuaFile()

SWEP.PrintName				= "Когти"
SWEP.Category				= "CLAWS"

SWEP.Slot				= 1
SWEP.SlotPos				= 0

SWEP.Spawnable				= true

SWEP.ViewModel				= Model( "models/weapons/v_models/V_demhands.mdl" )
SWEP.ViewModel				= Model( "models/weapons/v_models/V_demhands.mdl" )
SWEP.DrawWorldModel			= false
SWEP.ViewModelFOV			= 60
SWEP.UseHands				= true
SWEP.droppable				= false
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Anim 					= 0
SWEP.ISSCP 					= true

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"
SWEP.Damage 			= 25
SWEP.DamageType			= DMG_SLASH
SWEP.HitDistance		= 75
SWEP.HitRate			= 0.2

SWEP.HitSound			= Sound("CLAW_HIT")
SWEP.SwingSound			= Sound("CLAW_SWING")

if CLIENT then
SWEP.DrawWeaponInfoBox	= false
end

function SWEP:Initialize()
	self:SetHoldType( "fist") 
end

function SWEP:PrimaryAttack()
if SERVER then
	local vm = self.Owner:GetViewModel()
	if self.Anim == 1 then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "attack1" )) 
		self.Anim = 0
	else
		vm:SendViewModelMatchingSequence( vm:LookupSequence( "attack2" ))
		self.Anim = 1
	end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
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
		
	if IsValid(ent) then
		if ent:IsPlayer() then
			if ent:GTeam() == TEAM_SCP then return end
			if ent:GTeam() == TEAM_SPEC then return end
			self.Weapon:SetNextPrimaryFire( CurTime() + self.HitRate )
			self.Weapon:SetNextSecondaryFire( CurTime() + self.HitRate )
			self.Owner:EmitSound(self.SwingSound, 75, 100)
			timer.Create("hitdelay", 0.1, 1, function() self.HitWait(self) end)
			timer.Start( "hitdelay" )
		else
			if ent:GetClass() == "func_breakable" then
				ent:TakeDamage( 100, self.Owner, self.Owner )
			end
		end
	end
end
end

function SWEP:SecondaryAttack()
self:PrimaryAttack()
end

function SWEP:OnDrop()
	
end

function SWEP.HitWait(self)
	local tr = util.TraceHull( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 75 ),
		filter = self.Owner,
		mins = Vector( -10, -10, -10 ),
		maxs = Vector( 10, 10, 10 ),
		mask = MASK_SHOT_HULL 
	} )
 
	if ( tr.Hit ) then
		tr.Entity:EmitSound(self.HitSound, 150, 100)
		--if tr.Entity:Health() > self.Damage then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self.Owner) 
			dmginfo:SetInflictor(self) 
			dmginfo:SetDamage(self.Damage) 
			dmginfo:SetDamageType(self.DamageType) 
			tr.Entity:TakeDamageInfo(dmginfo)
		--end
	end
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "idle" ) ) 
end

function SWEP:Reload()
end

function SWEP:Holster()
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {} 
 
	self.AmmoDisplay.Draw = true //draw the display?
 
		self.AmmoDisplay.PrimaryClip = self:Clip1() //amount in clip
 
	return self.AmmoDisplay //return the table
end

function SWEP:OnRemove()
	timer.Remove("hitdelay")
	return true
end

