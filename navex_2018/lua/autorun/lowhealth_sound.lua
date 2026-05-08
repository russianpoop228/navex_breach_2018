--[[
lua/autorun/lowhealth_sound.lua
--]]
-- Addon by Kiritron Stablecore
-- Addon special for server NavexRP

if SERVER then
	resource.AddFile("sound/lowhpsound/heartbeat.wav")
end

AddCSLuaFile()

if CLIENT then
	
	local hpwait, hpalpha = 0, 0
	
	local LHPS = {
		lowhpthreshold = 25,
		playHeartbeatSound = true,
		muffleSounds = true,
		muffleSoundsOnHealth = 5
	}

	local function LowHPsound()
		
		local ply = LocalPlayer()
		local hp = ply:Health()
		
		if LHPS.muffleSounds then
			if ply:Health() <= LHPS.muffleSoundsOnHealth then
				if not ply.lastDSP then
					ply:SetDSP(14)
					ply.lastDSP = 14
				end
			else
				if ply.lastDSP then
					ply:SetDSP(0)
					ply.lastDSP = nil
				end
			end
		end
			
			if ply:Alive() then
				
				if LHPS.playHeartbeatSound then
					if ply:Health() <= LHPS.lowhpthreshold then
						ply:EmitSound("sound/lowhpsound/heartbeat.wav")
						hpwait = CurTime() + 0.1
					end
				end
			end
		end	
    	hook.Add("HUDPaint", "LowHPsound", LowHPsound)
	end
	


