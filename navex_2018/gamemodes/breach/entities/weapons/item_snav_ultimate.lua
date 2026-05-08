--[[
gamemodes/breach/entities/weapons/item_snav_ultimate.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_snav_ult")
	SWEP.BounceWeaponIcon = false
end

SWEP.Instructions	= "Нажмите ПКМ чтобы использовать"

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/mishka/models/snav.mdl"
SWEP.WorldModel		= "models/mishka/models/snav.mdl"
SWEP.PrintName		= "Навигатор S-Nav Ultimate"
SWEP.Slot			= 1
SWEP.SlotPos		= 2
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= true
SWEP.teams					= {2,3,5,6,7,8,9,10}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

SWEP.Enabled = false
SWEP.NextChange = 0

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

function SWEP:CalcView( ply, pos, ang, fov )
	if self.Enabled then
		ang = Vector(90,0,0)
		pos = pos + Vector(0,0,2500)
		fov = 90
	end
	return pos, ang, fov
end

SWEP.PlayersToShow = {}
SWEP.WeaponsToShow = {}
SWEP.EntsToShow = {}
SWEP.ScanDelay = 0

function SWEP:Think()
	if CLIENT then
		if self.ScanDelay > CurTime() then return end
		self.ScanDelay = CurTime() + 1
		self.PlayersToShow = {}
		self.WeaponsToShow = {}
		self.EntsToShow = {}
		local lp = LocalPlayer()
		for k,v in pairs(ents.FindInSphere( lp:GetPos(), 5000 )) do
			if v:IsPlayer() then
				if v == lp then continue end
				if v:GTeam() != TEAM_SPEC then
					table.ForceInsert(self.PlayersToShow, v)
				end
			elseif v:IsWeapon() then
				local found = false
				if IsValid(v.Owner) then
					found = true
				end
				if v.ISSCP != nil then
					if v.ISSCP == true then
						found = true
					end
				end
				if !found then
					table.ForceInsert(self.WeaponsToShow, v)
				end
			elseif v.PName or v.PrintName then
				table.ForceInsert(self.EntsToShow, v)
			end
		end
	end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
end

function SWEP:OnRemove()
end

function SWEP:Holster()
	return true
end

function SWEP:SecondaryAttack()
	if SERVER then return end
	if self.NextChange > CurTime() then return end
	self.Enabled = !self.Enabled
	self.NextChange = CurTime() + 0.25
end

function SWEP:CanPrimaryAttack()
end

function SWEP:DrawHUD()

	if self.Enabled then

		local team_color = gteams.GetColor(LocalPlayer():GTeam())
		DrawInfo(LocalPlayer():GetPos(), 'Вы', team_color)
		
		for k,v in pairs(self.WeaponsToShow) do
			if IsValid(v) then
				DrawInfo(v:GetPos(), v:GetPrintName(), Color(0,255,0))
			end
		end
		
		for k,v in ipairs(self.PlayersToShow) do
			if IsValid(v) then
				local team_color2 = gteams.GetColor(v:GTeam())
				DrawInfo(v:GetPos(), GetLangRole(v:GetNClass()), team_color2)
			end
		end
		
		for k,v in ipairs(self.EntsToShow) do
			if IsValid(v) then
				DrawInfo(v:GetPos(), v.PName or v.PrintName, Color(0,255,0))
			end
		end
		
	end
	
end





