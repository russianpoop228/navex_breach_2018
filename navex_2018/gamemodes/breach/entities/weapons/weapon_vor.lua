--[[
gamemodes/breach/entities/weapons/weapon_vor.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	--SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/scp_682_wep")
	SWEP.BounceWeaponIcon = false
end

SWEP.PrintName 				= "Украсть предмет"
SWEP.ViewModelFOV 			= 56
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Instructions			= [[ЛКМ - Украсть]]

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 			= "none"

SWEP.Secondary.ClipSize	 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.Weight 				= 5
SWEP.AutoSwitchTo 			= true
SWEP.AutoSwitchFrom 		= false
SWEP.Slot 					= 1
SWEP.SlotPos 				= 2
SWEP.DrawAmmo 				= false
SWEP.DrawCrosshair 			= false
SWEP.IdleAnim 				= true

SWEP.ViewModel				= "models/breach/keycard.mdl"
SWEP.WorldModel				= "models/breach/keycard.mdl"

SWEP.HoldType 				= "normal"

SWEP.NextAttackH 			= 0
SWEP.NextAttackW 			= 0
SWEP.NextReload 			= 0

SWEP.ISSCP 					= true
SWEP.droppable				= false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:Initialize()
	
	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

function SWEP:Reload()
	if self.NextReload > CurTime() then return end
	self.NextReload = CurTime() + 1
end

function SWEP:PrimaryAttack()
	if self.NextAttackH > CurTime() then return end
	self.NextAttackH = CurTime() + 1

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
		
		if IsValid(ent) then
			if ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				ent:TakeDamage(100,self.Owner)
				self.Owner:SetHealth(self.Owner:Health() + 100 )
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
			
	end
end

function SWEP:SecondaryAttack()

end


