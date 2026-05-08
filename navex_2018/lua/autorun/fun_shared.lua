--[[
lua/autorun/fun_shared.lua
--]]
local sadd = sound.Add
local ups = util.PrecacheSound

local FUN_STUFF_SOUNDS = {}

FUN_STUFF_SOUNDS["CLAW_SCREAM"] = "npc/fast_zombie/fz_alert_close1.wav"
FUN_STUFF_SOUNDS["CLAW_HIT"] = {"physics/flesh/flesh_squishy_impact_hard1.wav","physics/flesh/flesh_squishy_impact_hard2.wav","physics/flesh/flesh_squishy_impact_hard3.wav","physics/flesh/flesh_squishy_impact_hard4.wav"}
FUN_STUFF_SOUNDS["CLAW_SWING"] = "npc/fast_zombie/claw_miss2.wav" 


local tbl = {channel = CHAN_STATIC,
	volume = 1,
	level = 75,
	pitchstart = 100,
	pitchend = 100}

for k, v in pairs(FUN_STUFF_SOUNDS) do
	tbl.name = k
	tbl.sound = v
		
	sadd(tbl)
	
	if type(v) == "table" then
		for k2, v2 in pairs(v) do
			ups(v2)
		end
	else
		ups(v)
	end
end	

