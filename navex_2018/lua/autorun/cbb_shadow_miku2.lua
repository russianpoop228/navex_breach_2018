--[[
lua/autorun/cbb_shadow_miku2.lua
--]]
--Add Playermodel
player_manager.AddValidModel( "Tda Hatsune Miku Shadow (v2)", "models/captainbigbutt/vocaloid/shadow_miku_append.mdl" )
player_manager.AddValidModel( "Tda Hatsune Miku Shadow Competitive (v2)", "models/captainbigbutt/vocaloid/shadow_miku_append_competitive.mdl" )
player_manager.AddValidHands( "Tda Hatsune Miku Shadow (v2)", "models/captainbigbutt/vocaloid/c_arms/shadow_miku_append.mdl", 0, "00000000" )
player_manager.AddValidHands( "Tda Hatsune Miku Shadow Competitive (v2)", "models/captainbigbutt/vocaloid/c_arms/shadow_miku_append.mdl", 0, "00000000" )

--Add NPC
local NPC =
{
	Name = "Tda Hatsune Miku Shadow (v2)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/captainbigbutt/vocaloid/npc/shadow_miku_append.mdl",
	Category = "Vocaloid"
}

list.Set( "NPC", "npc_cbb_shadowmikuappend2", NPC )

local NPC =
{
	Name = "Tda Hatsune Miku Shadow Competitive(v2)",
	Class = "npc_citizen",
	KeyValues = { citizentype = 4 },
	Model = "models/captainbigbutt/vocaloid/npc/shadow_miku_append_competitive.mdl",
	Category = "Vocaloid"
}

list.Set( "NPC", "npc_cbb_shadowmikuappendcomp2", NPC )


-- Send this to clients automatically so server hosts don't have to
if SERVER then
	resource.AddWorkshop("312489252")
end

