--[[
gamemodes/breach/entities/weapons/ents_map_viewer.lua
--]]

-----------------------------------------------------

if CLIENT then
	SWEP.WepSelectIcon 	= surface.GetTextureID("breach/wep_keycardomni")
	SWEP.BounceWeaponIcon = false
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/breach/keycard.mdl"
SWEP.WorldModel		= "models/breach/keycard.mdl"
SWEP.PrintName		= "Просмотр всех энити"
SWEP.Author			= "McVipeR"

SWEP.Slot			= 1
SWEP.SlotPos		= 1
SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.HoldType		= "normal"
SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.droppable				= false
SWEP.teams					= {1,2,3,5,6}

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			=  "none"
SWEP.Primary.Automatic		= false

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Ammo			=  "none"
SWEP.Secondary.Automatic	=  false

function SWEP:Deploy()
	self.Owner:DrawViewModel( false )
end

function SWEP:DrawWorldModel()
	if !IsValid(self.Owner) then
		self:DrawModel()
	end
end

function SWEP:Initialize()
	self:SetHoldType("normal")
	self:SetSkin(5)
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + 1)
	
	if SERVER then
	
		local tr = self.Owner:GetEyeTrace()

		if not file.IsDir("ents_map_viewer", "DATA") then
			file.CreateDir("ents_map_viewer")
		end
		
		if ( IsValid( tr.Entity ) ) then
			local MapViewerString = tostring(tr.Entity:GetPos())
			local logfile = "ents_map_viewer/"..os.date("%m_%d_%Y")..".txt"
			
			if !file.Exists( logfile, "DATA" ) then
				file.Write( logfile, "Vector("..MapViewerString..")," )
			else
				file.Append( logfile, "\nVector(" .. MapViewerString..")," )
			end
			
			self.Owner:ChatPrint("Координаты сохранены в лог файл")
			
		end
		
	
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	
	if CLIENT then
		local tr = self.Owner:GetEyeTrace()

		if ( IsValid( tr.Entity ) ) then
			print(tr.Entity:GetPos())
		end
	end
end

function SWEP:DrawHUD()
	
	for k, v in pairs( ents.FindInSphere( LocalPlayer():GetPos(), 500 ) ) do

		local Pos = v:GetPos()
		Pos = Pos:ToScreen()

		if !v.PName and !v.PrintName then
			if v:IsWeapon() then
				DrawInfo(v:GetPos(), v:GetClass(), Color(255,0,0))
				draw.SimpleText(v:GetPos(), "BudgetLabel",Pos.x, Pos.y + 20, Color(255,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			else
				DrawInfo(v:GetPos(), v:GetClass(), Color(100,100,100))
				draw.SimpleText(v:GetPos(), "BudgetLabel",Pos.x, Pos.y + 20, Color(100,100,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		else
			if v:IsWeapon() then
				if !IsValid(v.Owner) then
					DrawInfo(v:GetPos(), v.PName or v.PrintName, Color(0,255,255))
					draw.SimpleText(v:GetPos(), "BudgetLabel",Pos.x, Pos.y + 20, Color(255,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				end
			else
				DrawInfo(v:GetPos(), v.PName or v.PrintName, Color(0,255,0))
				draw.SimpleText(v:GetPos(), "BudgetLabel",Pos.x, Pos.y + 20, Color(255,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			end
		end

	end

end

