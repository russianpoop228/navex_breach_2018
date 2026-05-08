--[[
gamemodes/breach/entities/weapons/weapon_scp_004.lua
--]]

AddCSLuaFile()

SWEP.PrintName				= "SCP-004-KS"
SWEP.Category				= "SCP-KS"

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
SWEP.Secondary.Delay        	= 40
SWEP.Secondary.Sound			= "scp/004KS_navex/krik.wav"
SWEP.Damage 			= 50
SWEP.DamageType			= DMG_SLASH
SWEP.HitDistance		= 75
SWEP.HitRate			= 0.2

SWEP.HitSound			= Sound("CLAW_HIT")
SWEP.SwingSound			= Sound("CLAW_SWING")
SWEP.NextReload 			= 0 -- Для звука
SWEP.NextPrimary = 0
SWEP.Freeze = false

SWEP.DrawRed = 0

if CLIENT then
SWEP.DrawWeaponInfoBox	= false
end

function SWEP:Initialize()
	self:SetHoldType("fist") 
	util.PrecacheSound("scp/004KS_navex/krik.wav")
	if CLIENT then
		--self.Lang = GetWeaponLang().SCP_1048A
		--self.Author		= self.Lang.author
		--self.Contact		= self.Lang.contact
		--self.Purpose		= self.Lang.purpose
		--self.Instructions	= self.Lang.instructions
	end
	sound.Add( {
		name = "attack004scp",
		sound = self.Secondary.Sound
	} )
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
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Secondary.Delay
	if SERVER then
		self.Owner:EmitSound( "attack004scp" )
		timer.Create( "Attack004", 1, 5, function()
			if !IsValid( self ) or !IsValid( self.Owner ) then
				timer.Destroy( "Attack004" )
				return
			end
			fent = ents.FindInSphere( self.Owner:GetPos(), 150 )
			for k, v in pairs( fent ) do
				if IsValid( v ) then
					if v:IsPlayer() then
						if v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
							v:TakeDamage( 45, self.Owner, self.Owner )
						end
					else
						if v:GetClass() == "func_breakable" then
							v:TakeDamage( 50, self.Owner, self.Owner )
						end
					end
				end
			end
		end )
	end
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

function SWEP:OnRemove()
	timer.Remove("hitdelay")
	return true
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local specialstatus = ""
	local showtext = ""
	local showtextlook = ""
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)
	if self.NextPrimary > CurTime() then
		specialstatus = "будет готов через " .. math.Round(self.NextPrimary - CurTime()) .. " сек..."
		showcolor = Color(145, 17, 62)
	else
		specialstatus = "готов!"
	end
	showtext = "Специальный навык " .. specialstatus
	if self.DrawRed < CurTime() then
		self.CColor = Color(255,0,0)
		showtextlook = ""
		lookcolor = Color(145, 17, 62)
	else
		self.CColor = Color(0,255,0)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "TimeLeft",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	draw.Text( {
		text = showtextlook,
		pos = { ScrW() / 2, ScrH() - 25 },
		font = "TimeLeft",
		color = lookcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})

	local x = ScrW() / 2.0
	local y = ScrH() / 2.0

	local scale = 0.3
	surface.SetDrawColor( self.CColor.r, self.CColor.g, self.CColor.b, 255 )

	local gap = 5
	local length = gap + 20 * scale
	--surface.DrawLine( x - length, y, x - gap, y )
	--surface.DrawLine( x + length, y, x + gap, y )
	--surface.DrawLine( x, y - length, x, y - gap )
	--surface.DrawLine( x, y + length, x, y + gap )
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


