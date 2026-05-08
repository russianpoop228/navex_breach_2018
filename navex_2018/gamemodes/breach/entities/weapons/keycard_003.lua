--[[
gamemodes/breach/entities/weapons/keycard_003.lua
--]]

-----------------------------------------------------

--if CLIENT then
--	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycardomni")
--	SWEP.BounceWeaponIcon = false
--end

SWEP.Purpose		= "Связка ключей"
SWEP.Instructions	= "Дает вам возможность открывать двери любого уровня"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/breach/keycard.mdl"
SWEP.WorldModel		= "models/breach/keycard.mdl"
SWEP.PrintName		= "Связка ключей"
SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

function SWEP:GetBetterOne()
	local r = math.random(1,100)
	if r < 25 then
		return "keycard_omni"
	else
		return "keycard_omni"
	end
end
SWEP.droppable				= false
SWEP.clevel					= 5
SWEP.teams					= {1}
SWEP.ISSCP = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false
SWEP.Primary.Delay        = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false
SWEP.Secondary.Delay        = 4

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
	--self:SetSkin(5)
	util.PrecacheSound("scp/003KS_navex/voice1.wav")
	util.PrecacheSound("scp/003KS_navex/voice2.wav")
	util.PrecacheSound("scp/003KS_navex/voice3.wav")
	util.PrecacheSound("scp/003KS_navex/voice4.wav")
end
function SWEP:Think()
end
function SWEP:Reload()
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
				if self.Owner:Health() > 2700 then return end
				ent:TakeDamage(10,self.Owner)
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
			
	end
end
function SWEP:SecondaryAttack()
	if (SERVER) then
		self.Owner:EmitSound( "scp/003KS_navex/voice"..math.random(1,4)..".wav" )
	end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay  )
end
function SWEP:CanPrimaryAttack()
end

--function SWEP:DrawHUD()
--	local coordx = ScrW()-256-194-100;
--	local coordy = ScrH()-15-128;
--	surface.SetDrawColor(255, 255, 255);
--	surface.SetMaterial(Material("navex098/keycard/key0.png"));
--	surface.DrawTexturedRect(coordx, coordy, 256, 128);
--end

