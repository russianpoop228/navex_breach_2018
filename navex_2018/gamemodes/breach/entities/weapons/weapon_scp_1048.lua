--[[
gamemodes/breach/entities/weapons/weapon_scp_1048.lua
--]]
AddCSLuaFile()

SWEP.PrintName			= "SCP-1048"

SWEP.ViewModelFOV 		= 56
SWEP.Spawnable 			= false
SWEP.AdminOnly 			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Delay        	= 8
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo			= "None"
SWEP.Primary.Sound			= "scp/1048A_navex/scream.wav"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Delay			= 5
SWEP.Secondary.Ammo			= "None"

SWEP.ISSCP 					= true
SWEP.droppable				= false
SWEP.CColor					= Color(0,255,0)
SWEP.teams					= {1}

SWEP.Weight					= 3
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot					= 0
SWEP.SlotPos					= 4
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= false
SWEP.ViewModel				= ""
SWEP.WorldModel			= ""
SWEP.IconLetter				= "w"
SWEP.HoldType 				= "normal"

SWEP.NextReload 			= 0 -- Для звука

SWEP.Lang = nil

function SWEP:Initialize()
	util.PrecacheSound("scp/1048A_navex/scream.wav")
	if CLIENT then
		--self.Lang = GetWeaponLang().SCP_1048A
		--self.Author		= self.Lang.author
		--self.Contact		= self.Lang.contact
		--self.Purpose		= self.Lang.purpose
		--self.Instructions	= self.Lang.instructions
	end
	self:SetHoldType(self.HoldType)
	sound.Add( {
		name = "attack1048scp",
		channel = CHAN_VOICE, --CHAN_STATIC
		volume = 1.0,
		level = 150,
		pitch = 100,
		sound = self.Primary.Sound
	} )
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
		self.Owner:DrawWorldModel( false )
		self.Owner:DrawViewModel( false )
	end
end

function SWEP:Holster()
	return true
end

SWEP.Freeze = false

SWEP.DrawRed = 0;
function SWEP:Think()
	if !SERVER then return end
	if preparing and (self.Freeze == false) then
		self.Freeze = true
		--self.Owner:SetJumpPower(0)
		--self.Owner:SetCrouchedWalkSpeed(0)
		--self.Owner:SetWalkSpeed(0)
		--self.Owner:SetRunSpeed(0)
	end
	if preparing or postround then return end
	if self.Freeze == true then
		self.Freeze = false
		--self.Owner:SetCrouchedWalkSpeed(0.6)
		--self.Owner:SetJumpPower(200)
		--self.Owner:SetWalkSpeed(250)
		--self.Owner:SetRunSpeed(300)
	end

	if CLIENT then
		self.DrawRed = CurTime() + 0.1
	end
end

SWEP.NextPrimary = 0

function SWEP:PrimaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	if self.NextPrimary > CurTime() then return end
	self.NextPrimary = CurTime() + self.Primary.Delay
	if SERVER then
		self.Owner:EmitSound( "scp/1048A_navex/scream.wav" )
		self.Owner:EmitSound( "attack1048scp" )
		timer.Create( "Attack1048", 0.4, 15, function()
			if !IsValid( self ) or !IsValid( self.Owner ) then
				timer.Destroy( "Attack1048" )
				return
			end
			fent = ents.FindInSphere( self.Owner:GetPos(), 100 )
			for k, v in pairs( fent ) do
				if IsValid( v ) then
					if v:IsPlayer() then
						if v:GTeam() != TEAM_SPEC and v:GTeam() != TEAM_SCP then
							v:TakeDamage( 7, self.Owner, self.Owner )
						end
					else
						if v:GetClass() == "func_breakable" then
							v:TakeDamage( 8, self.Owner, self.Owner )
						end
					end
				end
			end
		end )
	end
end

function SWEP:SecondaryAttack()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	--
end

function SWEP:Reload()
	if preparing or postround then return end
	if not IsFirstTimePredicted() then return end
	--
	if self.NextReload > CurTime() then return end
	self.NextReload = CurTime() + 5

	if (SERVER) then
		self.Owner:EmitSound( "scp/1048A_navex/scream.wav", 75, 100, 0.3)
	end
end

function SWEP:DrawHUD()
	--[[
	if disablehud == true then return end

	local showtext = self.Lang.HUD.attackReady
	local showcolor = Color(0,255,0)

	if self.NextPrimary > CurTime() then
		showtext = self.Lang.HUD.attackCD.." ".. math.Round(self.NextPrimary - CurTime())
		showcolor = Color(255,0,0)
	end

	draw.Text( {
		text = showtext,
		pos = { ScrW() / 2, ScrH() - 30 },
		font = "173font",
		color = showcolor,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	})
	]]--
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

