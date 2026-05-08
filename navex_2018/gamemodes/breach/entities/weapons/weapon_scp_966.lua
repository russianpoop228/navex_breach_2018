--[[
gamemodes/breach/entities/weapons/weapon_scp_966.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_966")
	SWEP.BounceWeaponIcon = false
end

SWEP.Instructions	= [[ЛКМ - чтобы лишать людей сна]] 

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-966"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

function SWEP:Initialize()
	
	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
end

SWEP.AttackDelay			= 1
SWEP.NextAttackW			= 0

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
		local ent = nil
		local hullsize = 20
		local tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 160 ),
			filter = self.Owner,
			mins = Vector( -hullsize, -hullsize, -hullsize ),
			maxs = Vector( hullsize, hullsize, hullsize ),
			mask = MASK_SHOT_HULL
		} )
		ent = tr.Entity
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SPEC then return end
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GetNWBool("SCP714Enabled") then self.Owner:ChatPrint("Игрок под воздействием SCP-714") return end
				if ent:Alive() then
					ent:TakeDamage( math.random(25,50), self.Owner, self.Owner )
				end
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:SecondaryAttack()
end

