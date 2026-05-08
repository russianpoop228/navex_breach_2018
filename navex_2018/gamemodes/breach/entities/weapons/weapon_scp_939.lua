--[[
gamemodes/breach/entities/weapons/weapon_scp_939.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

--[[
if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("vgui/scp_682_wep")
	SWEP.BounceWeaponIcon = false
end
]]--

SWEP.PrintName 				= "SCP-939"
SWEP.ViewModelFOV 			= 56
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Instructions			= [[ЛКМ - укусить
ПКМ - ускориться]]

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

local SCP939fs = 
{
	"weapon/939/talk0.wav",
	"weapon/939/talk1.wav",
	"weapon/939/talk2.wav",
	"weapon/939/talk3.wav",
	"weapon/939/talk4.wav"
}
local _SCP939last = 0;

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
	self.NextReload = CurTime() + 5
	
	if (SERVER) then
		local _random = math.random(1, #SCP939fs);
		if not(_random == _SCP939last) then
			self.Owner:EmitSound( SCP939fs[_random], 75, 100, 0.3)
			_SCP939last = _random;
		else
			self.Owner:EmitSound( SCP939fs[math.random(1, #SCP939fs)], 75, 100, 0.3)
		end
	end
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
				ent:TakeDamage(35,self.Owner)
				self.Owner:SetHealth(self.Owner:Health() + 35 )
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
			
	end
end

function SWEP:SecondaryAttack()

	if self.NextAttackW > CurTime() then 
		self.Owner:PrintMessage(3, "Гипер скорость еще не готова!")
		return
	end
	
	self.NextAttackW = CurTime() + 15

	self.Owner:SetWalkSpeed(400)
	self.Owner:SetRunSpeed(400)
	self.Owner:SetMaxSpeed(400)
	self.Owner:SetJumpPower(150)
	
	local function RemoveBuff()
		if IsValid(self.Owner) then
			self.Owner:SetWalkSpeed(180)
			self.Owner:SetRunSpeed(180)
			self.Owner:SetMaxSpeed(180)
			self.Owner:SetJumpPower(120)
		end
	end
	
	if IsValid(self.Owner) then
		timer.Create("939_remove_buff_"..self.Owner:UniqueID(), 5, 1, RemoveBuff)
	end
end


