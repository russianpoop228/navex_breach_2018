--[[
addons/breach_iv_motd/lua/autorun/iv_motd_server.lua
--]]
------------------------
--[[ NAVEX MOTD 2.0 ]]--
------------------------

if CLIENT then return end

SetGlobalBool("NAVEX_MOTD_USEUPDATE", false);

concommand.Add("navex_newupdate", function(Player, CMD, Args)
    if Player:IsAdmin() and (Player:SteamID64() == "76561198084777060") then
        SetGlobalBool("NAVEX_MOTD_USEUPDATE", !GetGlobalBool("NAVEX_MOTD_USEUPDATE", false));
        Player:ChatPrint("[Navex MOTD 2.0] Param <N_M_USERUPDATE> now is " .. tostring(GetGlobalBool("NAVEX_MOTD_USEUPDATE", false)));
    else
        Player:ChatPrint("[Navex MOTD 2.0] Access denied");
    end
end);

