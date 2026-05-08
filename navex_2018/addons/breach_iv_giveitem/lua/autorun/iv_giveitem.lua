--[[
addons/breach_iv_giveitem/lua/autorun/iv_giveitem.lua
--]]
if SERVER then return end

local ItemsNear = {};
local ItemsWhitelist = {
    ["weapon_crowbar"] = {Name = "Монтировка", Type = "Оружие"},
    ["navex_ammokit"] = {Name = "Ящик с патронами", Type = "Взаимодействие"},
    ["weapon_rex_snav"] = {Name = "Детектор движений", Type = "Прибор"}, 

    ["navex_mrrex_scp420j"] = {Name = "SCP-420-J", Type = "SCP-Объект"},
    ["navex_mrrex_scp1123"] = {Name = "SCP-1123", Type = "SCP-Объект"},

    ["armor_chaosis"] = {Name = "Повстанец Хаоса", Type = "Костюм"},
    ["armor_hazmat"] = {Name = "Защитный костюм", Type = "Костюм"},
    ["armor_mtfcom"] = {Name = "МОГ Командир", Type = "Костюм"},
    ["armor_mtfguard"] = {Name = "МОГ Охранник", Type = "Костюм"},
    ["armor_mtfl"] = {Name = "МОГ Лейтенант", Type = "Костюм"},
    ["armor_mtfmedic"] = {Name = "МОГ Медик", Type = "Костюм"},
    ["armor_ntf"] = {Name = "МОГ Эпсилон-11", Type = "Костюм"},
    ["armor_scientist_med"] = {Name = "Ученый медик", Type = "Костюм"},
    ["armor_security"] = {Name = "Служба Безопасности", Type = "Костюм"},
    ["armor_scientist"] = {Name = "Ученый", Type = "Костюм"},
    ["armor_special"] = {Name = "МОГ Специалист", Type = "Костюм"},

    ["breach_stunstick_z"] = {Name = "Дубинка", Type = "Оружие"},
    ["breach_stunstick"] = {Name = "Дубинка", Type = "Оружие"},

    ["item_eyedrops"] = {Name = "Глазные капли", Type = "Предмет"},
    ["item_medkit"] = {Name = "Индивидуальная аптечка", Type = "Предмет"},
    ["item_nvg"] = {Name = "Прибор Ночного Видения", Type = "Прибор"},
    ["item_radio"] = {Name = "Рация", Type = "Прибор"},
    ["item_ultramedkit"] = {Name = "Большая аптечка", Type = "Предмет"},

    ["keycard_level1"] = {Name = "1 Уровень", Type = "Ключ-Карта"},
    ["keycard_level2"] = {Name = "2 Уровень", Type = "Ключ-Карта"},
    ["keycard_level3"] = {Name = "3 Уровень", Type = "Ключ-Карта"},
    ["keycard_level4"] = {Name = "4 Уровень", Type = "Ключ-Карта"},
    ["keycard_level5"] = {Name = "5 Уровень", Type = "Ключ-Карта"},
    ["keycard_omni"] = {Name = "Омни Уровень", Type = "Ключ-Карта"},

    ["m9k_m92beretta"] = {Name = "M92 Beretta", Type = "Оружие"},
    ["m9k_usp"] = {Name = "USP", Type = "Оружие"},
    ["m9k_magpulpdr"] = {Name = "Magpul PDR", Type = "Оружие"},
    ["m9k_smgp90"] = {Name = "P90", Type = "Оружие"},
    ["m9k_m416"] = {Name = "HK 416", Type = "Оружие"},
    ["m9k_f2000"] = {Name = "F2000", Type = "Оружие"},
    ["m9k_m249lmg"] = {Name = "M249", Type = "Оружие"},
    ["m9k_coltpython"] = {Name = "Colt Python", Type = "Оружие"},
    ["m9k_glock"] = {Name = "Glock 18", Type = "Оружие"},
    ["m9k_famas"] = {Name = "FAMAS", Type = "Оружие"},
    ["m9k_ak47"] = {Name = "AK-47", Type = "Оружие"},
};
local ItemsDistance = 140;

hook.Add("PlayerTick", "IVItemNear_PT", function(Player, MVData)
    local Near = ents.FindInSphere(Player:GetPos(), ItemsDistance);
    table.Empty(ItemsNear);
    for _, v in pairs(Near) do
        if ItemsWhitelist[v:GetClass()] != nil and tostring(v:GetOwner()) == "[NULL Entity]" then
            table.ForceInsert(ItemsNear, v);
        end
    end
end);

hook.Add("HUDPaint", "IVItemNear_HUD", function()
    if LocalPlayer():GTeam() != TEAM_SCP and LocalPlayer():GTeam() != TEAM_SPEC then
        for _, v in pairs(ItemsNear) do
            if !IsValid(v) then return end
            local Position = v:GetPos():ToScreen();
            local Info = ItemsWhitelist[v:GetClass()];
            draw.SimpleText("[" .. Info.Type .. "] " .. Info.Name, "DermaDefaultBold", Position.x, Position.y- 15, Color(255, 255, 255, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
            
            surface.SetDrawColor(255, 255, 255, 100);
            surface.SetMaterial(Material("navex/ui/ico_give.png"));
            surface.DrawTexturedRect(Position.x-16, Position.y-1, 32, 32);
        end
    end
end);

