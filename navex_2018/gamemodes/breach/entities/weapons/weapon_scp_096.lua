--[[
gamemodes/breach/entities/weapons/weapon_scp_096.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if (CLIENT) then
	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/entities/weapon_scp096" )
	killicon.Add( "kill_icon_scp096", "vgui/icons/kill_icon_scp096", Color( 255, 255, 255, 255 ) )
end

SWEP.PrintName				= "SCP-096"			
SWEP.ViewModelFOV 			= 56
SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false
SWEP.Instructions	= [[ЛКМ - ударить
ПКМ - нервничать]]

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay          =  0.8
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay        = 10
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false
SWEP.Slot					= 0
SWEP.SlotPos				= 4
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false
SWEP.IdleAnim				= true

SWEP.ViewModel				= "models/weapons/v_arms_scp096.mdl"
SWEP.WorldModel				= "models/breach/keycard.mdl"

SWEP.IconLetter				= "w"
SWEP.Primary.Sound 			= ("weapons/scp96/attack1.wav") 
SWEP.HoldType 				= "normal"

SWEP.ISSCP					= true
SWEP.droppable				= false

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetSkin(0)
	
	util.PrecacheSound("weapons/scp096/attack1.wav")
	util.PrecacheSound("weapons/scp096/attack2.wav")
	util.PrecacheSound("weapons/scp096/attack3.wav")
	util.PrecacheSound("weapons/scp096/attack4.wav")
	util.PrecacheSound("weapons/scp096/chase096.wav")
	util.PrecacheSound("weapons/scp096/hit.mp3")
	
	self.Watched = false
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

function SWEP:IsLookingAt(ply)
	local yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() + Vector( 70 ) ):GetNormalized() )
	return (yes > 0.39)
end

function SWEP:Think()
	if postround then self.Watched = true return end
	
	if !IsValid(self.Owner) then return end
	
	local opos = self.Owner:GetPos()
	local up = Vector(0, 0, 64)
	
	local watch = false
	
	for k, v in ipairs(player.GetAll()) do
		local vpos = v:GetPos()
		
		--if vpos:DistToSqr(opos) < 12000000 then
			if v:Alive() and v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
				local tr_eyes = util.TraceLine( {
					start = vpos + up,
					endpos = opos + up,
					filter = v
				} )
				if tr_eyes.Entity == self.Owner then
					if self:IsLookingAt(v) then
						watch = true
						break
					end
				end
			end
		--end
	end
	
	self.Watched = watch
end

function SWEP:PrimaryAttack()
	if self.Watched then
		if (SERVER) then
			self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
			self.Owner:GetViewModel():SetPlaybackRate( 1 )
			self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)
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
					self.Owner:EmitSound( "weapons/scp096/hit.mp3" )
					ent:TakeDamage(math.random(50,85),self.Owner)
				elseif ent:GetClass() == "func_breakable" then
					self.Owner:EmitSound( "weapons/scp096/hit.mp3" )
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
			
			self.Owner:EmitSound( "weapons/scp096/attack"..math.random(1,4)..".wav" )
		end
		
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end

function SWEP:SecondaryAttack()
	if self.Watched then
		if (SERVER) then
			self.Owner:EmitSound( "weapons/scp096/chase096.wav" )
		end
		
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay  )
	end
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local showtextlook = "Никто не смотрит"
	local lookcolor = Color(145, 17, 62)

	if self.Watched then
		showtextlook = "Вы в поле зрения"
		lookcolor = Color(0,255,0)
	end
	
	draw.Text( { 
		text = showtextlook,
		pos = { ScrW() / 2, ScrH() - 25 },
		font = "173font",
		color = lookcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
end

