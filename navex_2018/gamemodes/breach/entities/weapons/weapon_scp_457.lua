--[[
gamemodes/breach/entities/weapons/weapon_scp_457.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_457")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Сжигать людей"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-457"
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
SWEP.Primary.Automatic		= false

SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Delay        = 10

SWEP.NextAttackH 			= 0
SWEP.NextAttackW 			= 0
SWEP.NextReload 			= 0

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
	util.PrecacheSound("scp/navex_457/fire1.wav")
	util.PrecacheSound("scp/navex_457/fire2.wav")
	util.PrecacheSound("scp/navex_457/fire3.wav")
	util.PrecacheSound("scp/navex_457/fire4.wav")
	
end

function SWEP:Think()
	if SERVER then
		if self.Owner:GTeam() != TEAM_SPEC then self.Owner:Ignite(0.1,100) end -- FIX 

		for k,v in pairs(ents.FindInSphere( self.Owner:GetPos(), 175 )) do
			if v:IsPlayer() then
				if v:GTeam() != TEAM_SCP and v:GTeam() != TEAM_SPEC then
					v:Ignite(5,250)
					if self.Owner.nextexp == nil then self.Owner.nextexp = 0 end
					if self.Owner.nextexp < CurTime() then
						self.Owner:AddExp(2)
						self.Owner.nextexp = CurTime() + 1
					end
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if SERVER then
		local ent = self.Owner:GetEyeTrace().Entity
		if(ent:GetPos():Distance(self.Owner:GetPos()) < 125) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 1000, self.Owner, self.Owner )
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if (SERVER) then
		self.Owner:EmitSound( "scp/navex_457/fire"..math.random(1,4)..".wav" )
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay  )
end

function SWEP:CanPrimaryAttack()
	return true
end

