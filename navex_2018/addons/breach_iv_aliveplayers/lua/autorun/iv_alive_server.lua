--[[
addons/breach_iv_aliveplayers/lua/autorun/iv_alive_server.lua
--]]
local TimerName = "AliveIV_A3477F";
local TimerStep = 1;
local IDName = "AliveIV_7D9F";

SetGlobalInt(IDName, 0);

hook.Add("Initialize", "IV_AliveModule", function()
    if timer.Exists(TimerName) then timer.Stop(TimerName); timer.Destroy(TimerName); end
    timer.Create(TimerName, TimerStep, 0, function()
        local Alive = 0;
        local Players = player.GetAll();
        for _, v in pairs(Players) do
            if IsValid(v) and v:IsPlayer() and v:Alive() and v:GTeam() != TEAM_SPEC then
                Alive = Alive + 1;
            end
        end
        SetGlobalInt(IDName, Alive);
    end);
end);

