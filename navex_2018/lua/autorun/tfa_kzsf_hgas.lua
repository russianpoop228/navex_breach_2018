--[[
lua/autorun/tfa_kzsf_hgas.lua
--]]
if SERVER then AddCSLuaFile() end

player_manager.AddValidModel("TFA-KZ-SF-Helghast-Assault", "models/player/tfa_kz_helghast_assault.mdl")
player_manager.AddValidHands("TFA-KZ-SF-Helghast-Assault","models/weapons/c_arms_tfa_kz_helghast_assault.mdl",0,"0000")


local Category = "Killzone: Shadow Fall"

local function AddNPC( t, class )
	list.Set( "NPC", class or t.Class, t )
end

AddNPC( {
	Name = "Helghast Assault ( Friendly )",
	Class = "npc_citizen",
	Category = Category,
	Model = "models/npc/tfa_kz_helghast_assault.mdl",
	KeyValues = { citizentype = CT_UNIQUE, SquadName = "resistance" }
}, "npc_kz_sf_hg_as_f" )

AddNPC( {
	Name = "Helghast Assault ( Enemy )",
	Class = "npc_combine_s",
	Category = Category,
	Model = "models/npc/tfa_kz_helghast_assault_e.mdl",
	Weapons = { "weapon_smg1", "weapon_ar2" },
	KeyValues = { SquadName = "overwatch", Numgrenades = 5 }
}, "npc_kz_sf_hg_as_e" )

local BGT = {
	["TFA-KZ-SF-Helghast-Assault"] = {
	[2] = {
		["key"] = 1,
		[0] = 0,
		[1] = 1
	},
	[3] = {
		["key"] = 2,
		[0] = 0,
		[1] = 1
	}
}
}

hook.Add("PlayerSpawn","Manage_Hands_BGT_TFAKZSFHELGHASTASSAULT", function(ply)
	timer.Simple(0, function()
		if not IsValid(ply) then return end
		local hands = ply:GetHands()
		if not IsValid(hands) then return end
		local pm = player_manager.TranslateToPlayerModelName( ply:GetModel() )
		if BGT[pm] then
			local t = BGT[pm]
			for k,v in pairs(t) do
				local bg = ply:GetBodygroup( k )
				hands:SetBodygroup( v.key, v[bg or 0] or 0)
			end
		end
	end)
end)

