--[[
lua/ulx/modules/sh/navex.lua
--]]
--[[
    Ебануться, уже версия 3.1
    Как же я люблю исправлять свои же ошибки
    ( ͡° ͜ʖ ͡°)
]]--


------------------- Base module initialization -------------------

local CATEGORY_NAME = "Navex";
local NAVEXSPAWN_FUNCS = {
    [ "Basic" ]   =   function(Player)   Player:UnSpectate();  Player:StripWeapons();  Player:RemoveAllAmmo(); end,

	["SCP-001KS"] =   function(Player)   Player:SetSCP001KS(); end,
	["SCP-002KS"] =   function(Player)   Player:SetSCP002KS(); end,
	["SCP-003KS"] =   function(Player)   Player:SetSCP003KS(); end,
	["SCP-004KS"] =   function(Player)   Player:SetSCP004KS(); end,
    ["SCP-035"]   =   function(Player)   Player:SetSCP035();   end,
    ["SCP-066"]   =   function(Player)   Player:SetSCP066();   end,
    ["SCP-049"]   =   function(Player)   Player:SetSCP049();   end,
    ["SCP-0492"]  =   function(Player)   Player:SetSCP0492();  end,
    ["SCP-106"]   =   function(Player)   Player:SetSCP106();   end,
    ["SCP-076"]   =   function(Player)   Player:SetSCP076();   end,
    ["SCP-082"]   =   function(Player)   Player:SetSCP082();   end,
    ["SCP-173"]   =   function(Player)   Player:SetSCP173();   end,
    ["SCP-457"]   =   function(Player)   Player:SetSCP457();   end,
    ["SCP-682"]   =   function(Player)   Player:SetSCP682();   end,
    ["SCP-939"]   =   function(Player)   Player:SetSCP939();   end,
    ["SCP-953"]   =   function(Player)   Player:SetSCP953();   end,
    ["SCP-966"]   =   function(Player)   Player:SetSCP966();   end,
    ["SCP-999"]   =   function(Player)   Player:SetSCP999();   end,
    ["SCP-1000"]  =   function(Player)   Player:SetSCP1000();  end,
    ["SCP-1048a"] =   function(Player)   Player:SetSCP1048a(); end,
    ["SCP-860"]   =   function(Player)   Player:SetSCP860();   end,

    ["Класс-Д"]                 =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["classds"]["roles"][1]);     end,
    ["Класс-Д Ветеран"]         =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["classds"]["roles"][2]);     end,
    ["Класс-Д Вор"]             =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["classds"]["roles"][3]);     end,
    ["Класс-Д Убийца"]          =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["classds"]["roles"][4]);     end,

    ["Ученый"]                  =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][1]); end,
    ["Ученый Медик"]            =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][2]); end,
    ["Ученый Др. Гирс"]         =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][3]); end,
    ["Ученый Др. Ли"]           =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][4]); end,
    ["Ученый Др. Минг"]         =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][5]); end,
    ["Ученый Др. Фергус"]       =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][6]); end,
    ["Ученый Др. Мейнард"]      =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["researchers"]["roles"][7]); end,

    ["Служба Безопасности"]     =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][1]);    end,
    ["Шеф Службы Безопасности"] =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][2]);    end,
    
    ["МОГ Охранник"]            =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][3]);    end,
    ["МОГ Медик"]               =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][4]);    end,
    ["МОГ Лейтенант"]           =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][5]);    end,
    ["МОГ Специалист"]          =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][6]);    end,
    ["МОГ Командир"]            =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][7]);    end,

    ["Директор Комплекса"]      =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][8]);    end,

    ["Шпион Длани Змеи"]        =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["security"]["roles"][9]);    end,

    ["МОГ Эпсилон-11"]          =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["support"]["roles"][1]);     end,
    ["Повстанцы Хаоса"]         =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["support"]["roles"][2]);     end,
    ["ГОК"]                     =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["support"]["roles"][3]);     end,
    ["Длань Змея"]              =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["support"]["roles"][4]);     end,
    ["Псиксон-KS"]              =   function(Player)    Player:ApplyRoleStats(ALLCLASSES["support"]["roles"][5]);     end
};

local NAVEXSPAWN_ROLES = {
	"SCP-001KS"                 ,
	"SCP-002KS"                 ,
	"SCP-003KS"                 ,
	"SCP-004KS"                 ,
    "SCP-035"                   ,
    "SCP-066"                   ,
    "SCP-049"                   ,
    "SCP-0492"                  ,
    "SCP-106"                   ,
    "SCP-076"                   ,
    "SCP-082"                   ,
    "SCP-173"                   ,
    "SCP-457"                   ,
    "SCP-682"                   ,
    "SCP-939"                   ,
    "SCP-953"                   ,
    "SCP-966"                   ,
    "SCP-999"                   ,
    "SCP-1000"                  ,
    "SCP-1048a"                 ,
    "SCP-860"                   ,
    
    "Класс-Д"                   ,
    "Класс-Д Ветеран"           ,
    "Класс-Д Вор"               ,
    "Класс-Д Убийца"            ,

    "Ученый"                    ,
    "Ученый Медик"              ,
    "Ученый Др. Гирс"           ,
    "Ученый Др. Ли"             ,
    "Ученый Др. Минг"           ,
    "Ученый Др. Фергус"         ,
    "Ученый Др. Мейнард"        ,

    "Служба Безопасности"       ,
    "Шеф Службы Безопасности"   ,

    "МОГ Охранник"              ,
    "МОГ Медик"                 ,
    "МОГ Лейтенант"             ,
    "МОГ Специалист"            ,
    "МОГ Командир"              ,

    "Директор Комплекса"        ,

    "Шпион Длани Змеи"          ,

    "МОГ Эпсилон-11"            ,
    "Повстанцы Хаоса"           ,
    "ГОК"                       ,
    "Длань Змея"                ,
    "Псиксон-KS"
};

------------------ Navex Spawn - Updated to ULX ------------------

function ulx.NavexSpawn(calling_ply, target_from, role)
    if !target_from:Alive() then return end
    if NAVEXSPAWN_FUNCS[role] == nil then return end

    if GetConVarString("gamemode") == "breach" then
        if target_from:IsPlayer() then
            NAVEXSPAWN_FUNCS["Basic"](target_from);
            NAVEXSPAWN_FUNCS[role](target_from);
            if string.sub(string.lower(role), 1, 3) != "scp" then target_from.canblink = true; end
            
            RunConsoleCommand("ulx", "ragdoll", target_from:Nick());
            RunConsoleCommand("ulx", "unragdoll", target_from:Nick());
            target_from:SetPos(target_from:GetPos() + Vector(0, 0, -40));
        end
    else
        calling_ply:ChatPrint("Ты что, совсем охуел юзать Navex Spawn, не на брич, а на " .. GetConVarString("gamemode") .. "?!");
    end

	ulx.fancyLogAdmin( calling_ply, "#A use 'Navex Spawn' for #T", target_from, role)
end

local navexspawn = ulx.command(CATEGORY_NAME, "ulx navexspawn", ulx.NavexSpawn, "!ns");
navexspawn:addParam{ type=ULib.cmds.PlayerArg, target="*" }
navexspawn:addParam{ type=ULib.cmds.StringArg, hint="Select role", ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes=NAVEXSPAWN_ROLES }
navexspawn:defaultAccess(ULib.ACCESS_SUPERADMIN);
navexspawn:help("Full analogue Navex Spawn, only safer.");

