--[[
lua/weapons/m9k_machete/shared.lua
--]]
-- Variables that are used on both client and server
SWEP.Gun = ("m9k_machete") -- must be the name of your swep but NO CAPITALS!
if (GetConVar(SWEP.Gun.."_allowed")) != nil then
	if not (GetConVar(SWEP.Gun.."_allowed"):GetBool()) then SWEP.Base = "bobs_blacklisted" SWEP.PrintName = SWEP.Gun return end
end
SWEP.Category				= "M9K Specialties"
SWEP.Author				= ""
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.PrintName				= "Machete"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 0				-- Slot in the weapon selection menu
SWEP.SlotPos				= 25			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "melee"		-- how others view you carrying the weapon
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_machete.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_fc2_machete.mdl"	-- Weapon world model
SWEP.Base				= "bobs_gun_base"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false
SWEP.droppable				= false
SWEP.ISSCP = true
SWEP.NextAttackH 			= 0
SWEP.NextAttackW 			= 0
SWEP.NextReload 			= 0
SWEP.Primary.RPM			= 75			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.4		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= ""			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.DrawRed = 0

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.Damage		= 80	-- Base damage per bullet

//Enter iron sight info and bone mod info below
-- SWEP.IronSightsPos = Vector(-2.652, 0.187, -0.003)
-- SWEP.IronSightsAng = Vector(2.565, 0.034, 0) 		//not for the knife
-- SWEP.SightsPos = Vector(-2.652, 0.187, -0.003)		//just lower it when running
-- SWEP.SightsAng = Vector(2.565, 0.034, 0)
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-25.577, 0, 0)

-- SWEP.Primary.Sound	= Sound("Weapon_Knife.Slash") //woosh
-- SWEP.KnifeShink = ("Weapon_Knife.HitWall")
-- SWEP.KnifeSlash = ("Weapon_Knife.Hit")
-- SWEP.KnifeStab = ("Weapon_Knife.Stab")

SWEP.Primary.Sound	= Sound("weapons/blades/woosh.mp3") //woosh
SWEP.KnifeShink = Sound("weapons/blades/hitwall.mp3")
SWEP.KnifeSlash = Sound("weapons/blades/slash.mp3")
SWEP.KnifeStab = Sound("weapons/blades/nastystab.mp3")

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	self.Weapon:EmitSound("weapons/knife/knife_draw_x.mp3", 50, 100)
	return true
end


function SWEP:PrimaryAttack()
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
						vm = self.Owner:GetViewModel()
						self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
						self.Owner:ViewPunch(Angle(-10,0,0))
						if self:CanPrimaryAttack() and self.Owner:IsPlayer() then
							self.Weapon:EmitSound(self.Primary.Sound)
							if SERVER then
								if !self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_RELOAD) then 
									vm:SetSequence(vm:LookupSequence("stab"))
									timer.Create("hack-n-slash", .23, 1, function() if not IsValid(self) then return end
									if IsValid(self.Owner) and
									IsValid(self.Weapon) then 
										if self.Owner:Alive() and self.Owner:GetActiveWeapon():GetClass() == self.Gun then 
											self:HackNSlash() end end end)
									self.Owner:SetAnimation( PLAYER_ATTACK1 )
									self.Weapon:SetNextPrimaryFire(CurTime()+1/(self.Primary.RPM/60))
							end
							end
						end
				else
					if ent:GetClass() == "func_breakable" then
						ent:TakeDamage( 100, self.Owner, self.Owner )
					end
				end
			end
	end
end

function SWEP:HackNSlash()

	pos = self.Owner:GetShootPos()
	ang = self.Owner:GetAimVector()
	damagedice = math.Rand(.85,1.25)
	pain = self.Primary.Damage * damagedice
	self.Owner:LagCompensation(true)
	local slash = {}
	slash.start = pos
	slash.endpos = pos + (ang * 42)
	slash.filter = self.Owner
	slash.mins = Vector(-8, -10, 0)
	slash.maxs = Vector(8, 10, 5)
	local slashtrace = util.TraceHull(slash)
	
	if IsValid(self.Owner) and IsValid(self.Weapon) then
		if self.Owner:Alive() then if self.Owner:GetActiveWeapon():GetClass() == self.Gun then
			local slash = {}
			slash.start = pos
			slash.endpos = pos + (ang * 42)
			slash.filter = self.Owner
			slash.mins = Vector(-8, -10, 0)
			slash.maxs = Vector(8, 10, 5)
			local slashtrace = util.TraceHull(slash)
			self.Owner:ViewPunch(Angle(20,0,0))
			if slashtrace.Hit then
				targ = slashtrace.Entity
				if targ:IsPlayer() or targ:IsNPC() then
					//find a way to splash a little blood
					self.Weapon:EmitSound(self.KnifeSlash)//stab noise
					paininfo = DamageInfo()
					paininfo:SetDamage(pain)
					paininfo:SetDamageType(DMG_SLASH)
					paininfo:SetAttacker(self.Owner)
					paininfo:SetInflictor(self.Weapon)
					paininfo:SetDamageForce(slashtrace.Normal *35000)
					targ:TakeDamageInfo(paininfo)
				else
					self.Weapon:EmitSound(self.KnifeShink)//SHINK!
					look = self.Owner:GetEyeTrace()
					util.Decal("ManhackCut", look.HitPos + look.HitNormal, look.HitPos - look.HitNormal )
				end
			end
		end end
	end
	self.Owner:LagCompensation(false)
end


function SWEP:SecondaryAttack()
	if self.NextAttackW > CurTime() then 
		self.Owner:PrintMessage(3, "Гипер скорость еще не готова!")
		return
	end
	
	self.NextAttackW = CurTime() + 30

	self.Owner:SetWalkSpeed(450)
	self.Owner:SetRunSpeed(450)
	self.Owner:SetMaxSpeed(450)
	self.Owner:SetJumpPower(200)
	
	local function RemoveBuff()
		if IsValid(self.Owner) then
			self.Owner:SetWalkSpeed(160)
			self.Owner:SetRunSpeed(160)
			self.Owner:SetMaxSpeed(160)
			self.Owner:SetJumpPower(100)
		end
	end
	
	if IsValid(self.Owner) then
		timer.Create("082_remove_buff_"..self.Owner:UniqueID(), 5, 1, RemoveBuff)
	end
end		

function SWEP:DrawHUD()
	if disablehud == true then return end
	local specialstatus = ""
	local showtext = ""
	local showtextlook = ""
	local lookcolor = Color(0,255,0)
	local showcolor = Color(17, 145, 66)
	if self.NextAttackW > CurTime() then
		specialstatus = "будет готово через " .. math.Round(self.NextAttackW - CurTime()) .. " сек..."
		showcolor = Color(145, 17, 62)
	else
		specialstatus = "готово!"
	end
	showtext = "Ускорение " .. specialstatus
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

function SWEP:IronSight()

	if !self.Owner:IsNPC() then
	if self.ResetSights and CurTime() >= self.ResetSights then
	self.ResetSights = nil
	
	if self.Silenced then
		self:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
	else
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
	end end
	
	if self.CanBeSilenced and self.NextSilence < CurTime() then
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_ATTACK2) then
			self:Silencer()
		end
	end
	
	if self.SelectiveFire and self.NextFireSelect < CurTime() then
		if self.Owner:KeyDown(IN_USE) and self.Owner:KeyPressed(IN_RELOAD) then
			self:SelectFireMode()
		end
	end
	
	if self.Owner:KeyDown(IN_SPEED) and not (self.Weapon:GetNWBool("Reloading")) then		-- If you are running
	self.Weapon:SetNextPrimaryFire(CurTime()+0.3)				-- Make it so you can't shoot for another quarter second
	self.IronSightsPos = self.RunSightsPos					-- Hold it down
	self.IronSightsAng = self.RunSightsAng					-- Hold it down
	self:SetIronsights(true, self.Owner)					-- Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								

	if self.Owner:KeyReleased (IN_SPEED) then	-- If you release run then
	self:SetIronsights(false, self.Owner)					-- Set the ironsight true
	self.Owner:SetFOV( 0, 0.3 )
	end								-- Shoulder the gun
	
end


if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end

