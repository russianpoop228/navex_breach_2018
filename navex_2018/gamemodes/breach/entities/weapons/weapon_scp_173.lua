--[[
gamemodes/breach/entities/weapons/weapon_scp_173.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_173")
	SWEP.BounceWeaponIcon = false
end

SWEP.Purpose		= "Убивать людей"
SWEP.Instructions	= [[ЛКМ - сломать шею
ПКМ - ослепить игроков]]

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/vinrax/props/keycard.mdl"
SWEP.WorldModel		= "models/vinrax/props/keycard.mdl"
SWEP.PrintName		= "SCP-173"
SWEP.Slot			= 0
SWEP.SlotPos		= 0
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.AttackDelay			= 0.15
SWEP.ISSCP = true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.SnapSound				= Sound( "snap.wav" )
SWEP.teams					= {1}
SWEP.Primary.Ammo			= "none"
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false

SWEP.SpecialDelay			= 30
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.NextAttackW			= 0
 
function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:DrawWorldModel()
end

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
	self.Watched = false
end

function SWEP:IsLookingAt(ply)
	local yes = ply:GetAimVector():Dot( ( self.Owner:GetPos() - ply:GetPos() + Vector( 70 ) ):GetNormalized() )
	return (yes > 0.39)
end
 
function SWEP:Watch(watching)
	self.Watched = watching
	self.Owner:Freeze(watching)
end

SWEP.DrawRed = 0
function SWEP:Think()
	if postround then self.Watched = false return end
	
	if !IsValid(self.Owner) then return end
	
	local opos = self.Owner:GetPos()
	local up = Vector(0, 0, 64)
	
	for k, v in ipairs(player.GetAll()) do
		local vpos = v:GetPos()
		
		--if vpos:DistToSqr(opos) < 12000000 then
			if v.canblink and v:Alive() and v.isblinking == false and v:GTeam() != TEAM_SPEC then
				local tr_eyes = util.TraceLine( {
					start = vpos + up,
					endpos = opos + up,
					filter = v
				} )
				if tr_eyes.Entity == self.Owner then
					if self:IsLookingAt(v) then
						if !self.Watched then
							self:Watch(true)
						end
						
						return
					end
				end
			end
		--end
		
	end
	
	if CLIENT then
		self.DrawRed = CurTime() + 0.1
	end
	
	if self.Watched then
		self:Watch(false)
	end
end

function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
end

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextAttackW > CurTime() then return end
	self.NextAttackW = CurTime() + self.AttackDelay
	if SERVER then
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
				if ent:GetNWBool("SCP714Enabled") then self.Owner:ChatPrint("Игрок под воздействием SCP-714") return end
				
				ent:Kill()
				self.Owner:AddExp(15, true)
				roundstats.snapped = roundstats.snapped + 1
				ent:EmitSound( self.SnapSound, 500, 100 )
			else
				if ent:GetClass() == "func_breakable" then
					ent:TakeDamage( 100, self.Owner, self.Owner )
				end
			end
		end
	end
end

function SWEP:Holster()
	self.Owner:SetWalkSpeed(1)
	self.Owner:SetRunSpeed(1)
	self.Owner:SetJumpPower(1)
	self.Owner:Freeze(false)
	return true
end

SWEP.NextSpecial = 0
function SWEP:SecondaryAttack()
	local time = 5
	if self.NextSpecial > CurTime() then return end
	self.NextSpecial = CurTime() + self.SpecialDelay
	if CLIENT then
		surface.PlaySound("Horror2.ogg")
	end
	local findents = ents.FindInSphere( self.Owner:GetPos(), 850 )
	local foundplayers = {}
	for k,v in pairs(findents) do
		if v:IsPlayer() then
			if !(v:GTeam() == TEAM_SCP or v:GTeam() == TEAM_SPEC) then
				if v.usedeyedrops == false then
					table.ForceInsert(foundplayers, v)
				end
			end
		end
	end
	if #foundplayers > 0 then
		local fixednicks = "Ослеплены: "
		if CLIENT then return end
		local numi = 0
		for k,v in pairs(foundplayers) do
			numi = numi + 1
			
			if numi == 1 then
				fixednicks = fixednicks .. v:Nick()
			elseif numi == #foundplayers then
				fixednicks = fixednicks .. " и " .. v:Nick()
			else
				fixednicks = fixednicks .. ", " .. v:Nick()
			end
			v:SendLua( 'surface.PlaySound("Horror2.ogg")' )
			net.Start("PlayerBlink")
				net.WriteFloat(time)
			net.Send(v)
			v.isblinking = true
			v.blinkedby173 = true
		end
		self.Owner:PrintMessage(HUD_PRINTTALK, fixednicks)
		timer.Create("UnBlinkTimer173", time + 0.2, 1, function()
			for k,v in pairs(player.GetAll()) do
				if v.blinkedby173 then
					v.isblinking = false
					v.blinkedby173 = false
				end
			end
		end)
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:DrawHUD()
	if disablehud == true then return end
	local specialstatus = ""
	local showtext = ""
	local showtextlook = "Никто не смотрит"
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)
	if self.NextSpecial > CurTime() then
		specialstatus = "будет готов через " .. math.Round(self.NextSpecial - CurTime()) .. " сек"
		showcolor = Color(145, 17, 62)
	else
		specialstatus = "готов"
	end
	showtext = "Спец навык " .. specialstatus
	if self.DrawRed < CurTime() then
		self.CColor = Color(255,0,0)
		showtextlook = "Вы в поле зрения"
		lookcolor = Color(145, 17, 62)
	else
		self.CColor = Color(0,255,0)
	end
	
	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 50 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	
	draw.Text( { 
		text = showtextlook,
		pos = { ScrW() / 2, ScrH() - 25 },
		font = "173font",
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




