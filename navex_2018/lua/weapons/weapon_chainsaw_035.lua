--[[
lua/weapons/weapon_chainsaw_035.lua
--]]

-----------------------------------------------------
SWEP.ViewModelFOV = 53
SWEP.ViewModel = "models/weapons/v_chainsaw.mdl"
SWEP.WorldModel = "models/weapons/w_chainsaw.mdl"
SWEP.Slot = 0
SWEP.HoldType = "physgun" 
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = false
SWEP.PrintName = "Бензопила"
SWEP.Instructions	= [[ЛКМ - пилить
ПКМ - распилить по полам]]
SWEP.base = "weapon_base"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true

SWEP.Secondary.Ammo = "none"

SWEP.ISSCP 			= true
SWEP.droppable		= false

if CLIENT then
SWEP.WepSelectIcon = surface.GetTextureID("vgui/entities/weapon_chainsaw_new")
killicon.Add( "weapon_chainsaw_new", "vgui/entities/weapon_chainsaw_new", Color( 255, 255, 255, 255 ) )
SWEP.BounceWeaponIcon = false
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self:SetDeploySpeed(0.5)
	self.RSaw_Idle = CreateSound(self,"weapons/melee/chainsaw_idle.wav")
	self.RSaw_Attack = CreateSound(self,"weapons/melee/chainsaw_attack.wav")
	if CLIENT then
		emitter = ParticleEmitter(self:GetPos())
	end
end

function SWEP:Deploy()
	self:EmitSound("weapons/melee/chainsaw_start_01.wav",10)
	self.Owner:SetAnimation(PLAYER_RELOAD)
	timer.Create("rsaw_idlesound_start"..self:EntIndex(),3,1,function()
		if not IsValid(self) then return end
		self.RSaw_Idle:Play()
		self.RSaw_Idle:ChangeVolume(0.10,0.01)
	end)
end

function SWEP:Think()
	if self.Owner and IsValid(self.Owner) then
		if self.Owner:KeyPressed(IN_ATTACK) then
			self.RSaw_Idle:Stop()
			self.RSaw_Attack:Play()
			self.RSaw_Attack:ChangeVolume(0.10,0.01)
		elseif self.Owner:KeyReleased(IN_ATTACK) then
			self.RSaw_Idle:Play()
			self.RSaw_Idle:ChangeVolume(0.10,0.01)
			self.RSaw_Attack:Stop()
		end
	end
end

function SWEP:PrimaryAttack()

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
	
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if ent:IsValid() then
		if SERVER then
			if ent:GetClass() == "func_breakable" or ent:GetClass() == "func_breakable_surf" then
				local bullet = {}
				bullet.Num = self.GunShots
				bullet.Src = self.Owner:GetShootPos()
				bullet.Dir = self.Owner:GetAimVector()
				bullet.Spread = Vector(0,0,0)
				bullet.Tracer = 0
				bullet.Force = 1
				bullet.Damage = 100
				self.Owner:FireBullets( bullet )
			elseif ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				ent:TakeDamage(math.random(5,25),self.Owner)
			end
		end
		if ent:IsPlayer() or ent:IsNPC() then
			self.RSaw_Attack:ChangePitch(50,0.75) 
			local BLOOOD = EffectData()
			BLOOOD:SetOrigin(tr.HitPos)
			BLOOOD:SetMagnitude(math.random(1,3))
			BLOOOD:SetEntity(ent)
			util.Effect("bloodstream",BLOOOD)
		end
	else
		self.RSaw_Attack:ChangePitch(100,0.75)
	end
	
	if tr.HitWorld then
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetMagnitude(1)
		effectdata:SetScale(2)
		effectdata:SetRadius(1)
		util.Effect("Sparks",effectdata)
		sound.Play("npc/manhack/grind"..math.random(1,5)..".wav",tr.HitPos,40,150)
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.01)
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.25 )
end

function SWEP:SecondaryAttack()

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
	
	self:SendWeaponAnim(ACT_VM_MISSCENTER)
	self:EmitSound("weapons/melee/chainsaw_die_01.wav",15.5)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	if ent:IsValid() then
		if SERVER then
			if ent:GetClass() == "func_breakable" or ent:GetClass() == "func_breakable_surf" then
				local bullet = {}
				bullet.Num = self.GunShots
				bullet.Src = self.Owner:GetShootPos()
				bullet.Dir = self.Owner:GetAimVector()
				bullet.Spread = Vector(0,0,0)
				bullet.Tracer = 0
				bullet.Force = 1
				bullet.Damage = 45
				self.Owner:FireBullets( bullet )
			elseif ent:IsPlayer() then
				if ent:GTeam() == TEAM_SCP then return end
				if ent:GTeam() == TEAM_SPEC then return end
				ent:TakeDamage(0,self.Owner)
			end
		end
		if ent:IsPlayer() or ent:IsNPC() then
			local BLOOOD = EffectData()
			BLOOOD:SetOrigin(tr.HitPos)
			BLOOOD:SetMagnitude(math.random(1,3))
			BLOOOD:SetEntity(ent)
			util.Effect("bloodstream",BLOOOD)
			sound.Play("weapons/melee/chainsaw_gore_0"..math.random(1,4)..".wav",tr.HitPos,40,100)
		end
	end
	
	if tr.HitWorld then
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetMagnitude(1)
		effectdata:SetScale(2)
		effectdata:SetRadius(1)
		util.Effect("Sparks",effectdata)
		sound.Play("npc/manhack/grind"..math.random(1,5)..".wav",tr.HitPos,40,150)
	end
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.75)
	self.Weapon:SetNextSecondaryFire( CurTime() + 2 )
end

function SWEP:Holster()
	self:OnRemove()
	if IsValid(self.Owner) then
		self:EmitSound("weapons/melee/chainsaw_die_01.wav",25.5)
	end
	return true
end

function SWEP:OnRemove()
	timer.Destroy("rsaw_idlesound_start"..self:EntIndex())
	if not self.RSaw_Idle then return end
	self.RSaw_Idle:Stop()
	self.RSaw_Attack:Stop()
end

