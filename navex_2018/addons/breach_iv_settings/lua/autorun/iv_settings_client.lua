--[[
addons/breach_iv_settings/lua/autorun/iv_settings_client.lua
--]]
--[[--------------------
--|| NAVEX SETTINGS ----
--]]--------------------

if SERVER then return end

local Settings = {};
Settings.Commands = {"!настройки", "!settings"};
Settings.IsOpen = false;

Settings.Config = {
    Cold = true,
    Contrast = true,
    Effects = true,
    UI = true,
    Fog = false,
    Hints = false
};

SetGlobalBool("NVX_USEBLUR", Settings.Config.UI);
SetGlobalBool("NVX_COLDEFFECT", Settings.Config.Cold);
SetGlobalBool("NVX_WORLDHINTS", Settings.Config.Hints);

surface.CreateFont("NavexSettings_Group", {font = "DermaLarge", extended = false, size = 20, weight = 1000});
surface.CreateFont("NavexSettings_Text", {font = "DermaDefault", extended = false, size = 20, weight = 500});

----- >> Функция отрисовки иконок << -----
function Settings.Ico(Source, Pos)
    surface.SetDrawColor(255, 255, 255);
    surface.SetMaterial(Material(Source));
    surface.DrawTexturedRect(Pos[1], Pos[2], Pos[3], Pos[4])
end

-- ClearUI : Button

local ClearUI = {};

function ClearUI.Button(b, text, w, h, s)
	if !b:IsDown() then
		surface.SetDrawColor(243, 247, 251, 200);
		surface.DrawOutlinedRect(0, 0, w, h);
		if s then
			draw.SimpleText(text, "DermaDefaultBold", w/2, h/2-1, Color(255,255,255,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(text, "DermaDefault", w/2, h/2-1, Color(255,255,255,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end
	else
		surface.SetDrawColor(243, 247, 251, 200);
		surface.DrawRect(0, 0, w, h);
		if s then
			draw.SimpleText(text, "DermaDefaultBold", w/2, h/2-1, Color(0,0,0,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		else
			draw.SimpleText(text, "DermaDefault", w/2, h/2-1, Color(0,0,0,230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		end
	end
end

function ClearUI.CheckBox(c, w, h)
    surface.SetDrawColor(255, 255, 255, 240);
    surface.DrawOutlinedRect(0, 0, w, h);

    if c:GetChecked() then
        draw.SimpleText("✔", "DermaDefaultBold", w/2, h/2, Color(255, 255, 255, 230), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end
end

----- >> Окно настроек << -----
function Settings.Start()
    Window = vgui.Create("DFrame");
    Window:SetSize(400, 301);
    Window:Center();
    Window:SetTitle("");
    Window:ShowCloseButton(false);
    Window:SetDraggable(false);
    function Window:Paint(w, h)
        surface.SetDrawColor(255, 255, 255, 200)
        surface.SetMaterial(Material("navex_settings_20/background.png"));
        surface.DrawTexturedRect(0, 25, w, h);

        draw.RoundedBox(0, 0, 0, w, 25, Color(0, 0, 0, 253));
        draw.RoundedBox(0, 0, 25, w, h-25, Color(0, 0, 0, 200));
        draw.SimpleText("Navex Breach: Настройки", "DermaDefault", 5, 5, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
    
        draw.RoundedBox(0, 5, 41, 20, 2, Color(255, 255, 255, 200));
        draw.RoundedBox(0, 205, 41, w-210, 2, Color(255, 255, 255, 200));
        draw.SimpleText("Визульные эффекты", "NavexSettings_Group", 30, 30, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
        
        Settings.Ico("navex_settings_20/ico_cold.png", {7, 62, 16, 16});
        draw.SimpleText("Эффект холода", "NavexSettings_Text", 60, 59, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

        Settings.Ico("navex_settings_20/ico_contrast.png", {7, 92, 16, 16});
        draw.SimpleText("Более тусклые цвета", "NavexSettings_Text", 60, 89, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

        Settings.Ico("navex_settings_20/ico_weap.png", {7, 122, 16, 16});
        draw.SimpleText("Эффекты оружия", "NavexSettings_Text", 60, 119, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

        Settings.Ico("navex_settings_20/ico_ui.png", {7, 152, 16, 16});
        draw.SimpleText("Качественный интерфейс", "NavexSettings_Text", 60, 149, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
    
        draw.RoundedBox(0, 5, 191, 20, 2, Color(255, 255, 255, 200));
        draw.RoundedBox(0, 206, 191, w-211, 2, Color(255, 255, 255, 200));
        draw.SimpleText("Экспериментальные", "NavexSettings_Group", 30, 180, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

        Settings.Ico("navex_settings_20/ico_fog.png", {7, 152 + 60, 16, 16});
        draw.SimpleText("Ограничение прорисовки", "NavexSettings_Text", 60, 209, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

        Settings.Ico("navex_settings_20/ico_ui.png", {7, 152 + 90, 16, 16});
        draw.SimpleText("Подсказки на карте", "NavexSettings_Text", 60, 239, Color(255,255,255, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);

        Settings.Ico("navex_settings_20/ico_graph.png", {7, 152 + 90+30, 16, 16});
        Settings.Ico("navex_settings_20/ico_warning.png", {240, 152 + 90 + 1+30, 16, 16});
        draw.SimpleText("Рекомендуемо для AMD", "Default", 260, 152 + 92+30, Color(255,50,50, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
    end

    ------- >> Кнопка закрытия
    local CClose = vgui.Create("DButton", Window);
    CClose:SetPos(400-25, 2);
    CClose:SetSize(20, 20);
    CClose:SetText("");
    function CClose:Paint(w, h) 
        Settings.Ico("navex_motd_20/close.png", {0, 0, w, h}); 
        if self:IsDown() then draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 100)); end
    end
    function CClose:DoClick() Window:Close(); surface.PlaySound("garrysmod/ui_click.wav"); end

    ------- >> Эффект холода
    local Effects_Cold = vgui.Create("DCheckBox", Window);
    Effects_Cold:SetPos(31, 61);
    Effects_Cold:SetSize(20, 20);
    Effects_Cold:SetValue(Settings.Config.Cold);
    function Effects_Cold:OnChange(Value) 
        Settings.Config.Cold = Value;
        SetGlobalBool("NVX_COLDEFFECT", Value);
        surface.PlaySound("garrysmod/ui_return.wav"); 
    end
    function Effects_Cold:Paint(w, h) ClearUI.CheckBox(self, w, h); end

    ------- >> Более тусклые цвета
    local Effects_Colors = vgui.Create("DCheckBox", Window);
    Effects_Colors:SetPos(31, 91);
    Effects_Colors:SetSize(20, 20);
    Effects_Colors:SetValue(Settings.Config.Contrast);
    function Effects_Colors:OnChange(Value) 
        Settings.Config.Contrast = Value;
        LocalPlayer():ConCommand("br_livecolors");
        surface.PlaySound("garrysmod/ui_return.wav"); 
    end
    function Effects_Colors:Paint(w, h) ClearUI.CheckBox(self, w, h); end

    ------- >> Эффекты оружия
    local Effects_Weapons = vgui.Create("DCheckBox", Window);
    Effects_Weapons:SetPos(31, 121);
    Effects_Weapons:SetSize(20, 20);
    Effects_Weapons:SetValue(Settings.Config.Effects);
    function Effects_Weapons:OnChange(Value) 
        Settings.Config.Effects = Value;
        local _k = {[true] = 1, [false] = 0};
        LocalPlayer():ConCommand("M9KGasEffect " .. _k[Value]);
        surface.PlaySound("garrysmod/ui_return.wav"); 
    end
    function Effects_Weapons:Paint(w, h) ClearUI.CheckBox(self, w, h); end

    ------- >> Качественный интерфейс
    local Effects_UI = vgui.Create("DCheckBox", Window);
    Effects_UI:SetPos(31, 151);
    Effects_UI:SetSize(20, 20);
    Effects_UI:SetValue(Settings.Config.UI);
    function Effects_UI:OnChange(Value) 
        Settings.Config.UI = Value;
        SetGlobalBool("NVX_USEBLUR", Value);
        surface.PlaySound("garrysmod/ui_return.wav"); 
    end
    function Effects_UI:Paint(w, h) ClearUI.CheckBox(self, w, h); end

    ------- >> Ограничение прорисовки
    local Experemental_Fog = vgui.Create("DCheckBox", Window);
    Experemental_Fog:SetPos(31, 151 + 60);
    Experemental_Fog:SetSize(20, 20);
    Experemental_Fog:SetValue(Settings.Config.Fog);
    function Experemental_Fog:OnChange(Value) 
        Settings.Config.Fog = Value;
        surface.PlaySound("garrysmod/ui_return.wav"); 
    end
    function Experemental_Fog:Paint(w, h) ClearUI.CheckBox(self, w, h); end

    ------- >> Метки на карте
    local Experimental_Hints = vgui.Create("DCheckBox", Window);
    Experimental_Hints:SetPos(31, 151 + 90);
    Experimental_Hints:SetSize(20, 20);
    Experimental_Hints:SetValue(Settings.Config.Hints);
    function Experimental_Hints:OnChange(Value) 
        Settings.Config.Hints = Value;
        SetGlobalBool("NVX_WORLDHINTS", Value);
        surface.PlaySound("garrysmod/ui_return.wav"); 
    end
    function Experimental_Hints:Paint(w, h) ClearUI.CheckBox(self, w, h); end

    ------- >> Оптимизация
    local Experemental_Optimize = vgui.Create("DButton", Window);
    Experemental_Optimize:SetPos(32, 151 + 120);
    Experemental_Optimize:SetSize(200, 20);
    Experemental_Optimize:SetText("");
    function Experemental_Optimize:Paint(w, h) ClearUI.Button(self, "Оптимизировать FPS", w, h, true); end
    function Experemental_Optimize:DoClick()
        LocalPlayer():ConCommand("gmod_mcore_test 1; mat_queue_mode -1; cl_threaded_bone_setup 1");
        surface.PlaySound("garrysmod/save_load2.wav");
        Window:Close();
    end

    Window:MakePopup();
end

----- >> Вызов меню настроек << -----
hook.Add("OnPlayerChat", "NavexSettings_Call", function(Player, Text, Team, Dead)
    if Player != LocalPlayer() then return end
    if Text != Settings.Commands[1] and Text != Settings.Commands[2] then return end
    if Settings.IsOpen then return end
    Settings.Start();
end);

hook.Add("SetupWorldFog", "NavexSettings_SWF", function()
    if Settings.Config.Fog then 
        render.FogMaxDensity(1);
        render.FogColor(0, 0, 0);
        render.FogStart(300);
        render.FogEnd(700);
        render.FogMode(MATERIAL_FOG_LINEAR);
    end

    return true
end);

