--[[
gamemodes/breach/entities/weapons/breach_stunstick_z.lua
--]]

-----------------------------------------------------

AddCSLuaFile()

SWEP.PrintName = "Плетка Тимона"
SWEP.Instructions = "ЛКМ: Ударить"
SWEP.Author = ""
SWEP.base = "weapon_base"
SWEP.Category = "Breach"

SWEP.DrawCrosshair = false
SWEP.Weight = 5
SWEP.ViewModel = "models/weapons/c_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.HoldType = "melee"
SWEP.ViewModelFOV = 54

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.AutoSwitchTo = true
SWEP.FiresUnderwater = true
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.UseHands = true

SWEP.AutoSwitchFrom = false
SWEP.DrawAmmo = false

SWEP.Primary.Recoil				= 0
SWEP.Primary.Damage				= 0
SWEP.Primary.NumShots			= 0
SWEP.Primary.Cone				= 0	
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= true
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Recoil			= 0
SWEP.Secondary.Damage			= 0
SWEP.Secondary.NumShots			= 0
SWEP.Secondary.Cone		  		= 0
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic   		= true

SWEP.Secondary.Ammo         	= "none"

SWEP.droppable				= false
SWEP.teams					= {2, 3, 5, 6}

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	self:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
end

function SWEP:PrimaryAttack()
	
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Weapon:SetNextPrimaryFire(CurTime() + .7)

	local trace = self.Owner:GetEyeTrace()

	if trace.Entity then
		trace.Entity:SetVelocity(self.Owner:GetAimVector()*100000)
	end
	
	if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then
						
		bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 50
		bullet.Damage = 0
	
        self.Owner:FireBullets(bullet)
        self.Owner:SetAnimation( PLAYER_ATTACK1 );
		self.Weapon:EmitSound( "Weapon_StunStick.Melee_Hit" )
		
		if SERVER then
		
		local spark = ents.Create("env_spark")
		spark:SetPos( self.Owner:GetEyeTrace().HitPos )
		spark:Spawn()
		spark:SetKeyValue("Magnitude",1)
		spark:SetKeyValue("TrailLength",1)
		spark:Fire( "SparkOnce","",0.0 )
		spark:SetParent( self.Entity )
		spark:Fire("kill","",0.2)
		
		local light = ents.Create("env_sprite")
		light:SetPos( self.Owner:GetEyeTrace().HitPos )
		light:Spawn()
		light:SetKeyValue("model","sprites/glow02.vmt")
		light:SetKeyValue("rendermode",5)
		light:SetKeyValue("scale",0.25)
		light:SetKeyValue("TrailLength",1)
		light:Fire( "ShowSprite","",0.0 )
		light:SetParent( self.Entity )
		light:Fire("kill","",0.5)
		
		end
		
	else

		self.Weapon:EmitSound( "Weapon_StunStick.Swing" )
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)	
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
	end

end

function SWEP:Throw_Attack (Model, Sound, Angle)
	local tr = self.Owner:GetEyeTrace()
	if (!SERVER) then return end
	local ent = ents.Create ("sent_stunstick_z")
	ent:SetPos (self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
	ent:SetAngles (self.Owner:EyeAngles())
	--ent:SetOwner(self.Owner)
	ent:Spawn()
	local phys = ent:GetPhysicsObject()
	local shot_length = tr.HitPos:Length()
	local velocity = self.Owner:GetAimVector()
	velocity = velocity * 5300
	velocity = velocity + ( VectorRand() * 20 ) -- a random element
	phys:ApplyForceCenter( velocity )
	phys:AddAngleVelocity( VectorRand() * 1000 ) 
	--self.Owner:StripWeapon("breach_stunstick_z")
end

function SWEP:SecondaryAttack()
	self:TakePrimaryAmmo(self.Secondary.TakeAmmo)
	self.Weapon:SetNextPrimaryFire( CurTime() + .3 )
	self.Weapon:SetNextSecondaryFire( CurTime() + .5 )
	self.Weapon:EmitSound ( "Weapon_StunStick.Swing" )
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	timer.Simple(.1, function()
		self:Throw_Attack (self.Secondary.Model, self.Primary.Sound, self.Secondary.AngVelocity)
	end)
end

function SWEP:Deploy()  
	self.Weapon:EmitSound( "Weapon_StunStick.Activate" )  
	self.DeploySound = true
	return true
end
function SWEP:Holster()
	if (self.DeploySound) then
		self.Weapon:EmitSound( "Weapon_StunStick.Deactivate" )  
		self.DeploySound = false
	end
	return true
end

function SWEP:Reload()
	return
end


