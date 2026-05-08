--[[
gamemodes/breach/entities/entities/armor_base.lua
--]]

-----------------------------------------------------
AddCSLuaFile()

ENT.PrintName		= "Base Armor"
ENT.Author		    = "Kanade"
ENT.Type			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.ArmorType = "armor_mtfguard"

function ENT:Initialize()
	self.Entity:SetModel("models/mishka/models/vest.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	//self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetAngles( Angle(-90, 180, 0) )
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	//local phys = self.Entity:GetPhysicsObject()

	//if phys and phys:IsValid() then phys:Wake() end
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

function ENT:Use(ply)
	if ply:GTeam() == TEAM_SPEC or ply:GTeam() == TEAM_SCP or ply:Alive() == false then return end
	if ply.UsingArmor != nil then
		ply:PrintMessage(HUD_PRINTTALK, '[Внимание!] На вас уже одет костюм, введите "dropvest"/"снять" в чат чтобы выбросить текущую броню!')
		return
	end
	if SERVER then
		ply:ApplyArmor(self.ArmorType)
		ply:EmitSound("pickitem2.ogg")
		self:EmitSound( Sound("npc/combine_soldier/zipline_clothing".. math.random(1, 2).. ".wav") )
		self:Remove()
	end
	ply.UsingArmor = self.ArmorType
end

function ENT:Draw()
	self:DrawModel()
end


