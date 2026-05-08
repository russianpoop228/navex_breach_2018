--[[
gamemodes/breach/gamemode/cl_hud.lua
--]]
-- Локальные переменные
local navex_haveradio = false;
local navex_radiochannel = "0";
local navex_ply = LocalPlayer();

-- Глобальные переменные
SetGlobalBool("NVX_USEBLUR", true);

hud_r = 5;
hud_r_size = {0, 2, 5, 10};

-- Локальная функция проверки наличия рации
local function navex_check_radio()
  navex_haveradio = false;
  for k, v in pairs(LocalPlayer():GetWeapons()) do
      if (v:GetPrintName() == "Рация") then
        navex_haveradio = true;
        if (v.Enabled == false) then
          navex_radiochannel = "OFF";
        else
          navex_radiochannel = tostring(v.Channel) .. " КН";
        end
      end
  end
end

-----------------------------------------------------
--- >> СИСТЕМА ПОДСКАЗОК << --

local ClearUI = {};

ClearUI.Materials = {
	["TIP_HEARPHONES"] = Material("navex/ui/tip_hearphones.png");
};

function ClearUI.HalfRichTip(x, y, size_x, size_y, icon, text)
	draw.SimpleText(text, "HudHintTextLarge", x + size_x + 8, y + size_y/2-1, Color(243, 247, 251, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    surface.SetDrawColor(255, 255, 255, 210);
    surface.SetMaterial(ClearUI.Materials["TIP_HEARPHONES"]);
    surface.DrawTexturedRect(x + size_x/6, y + size_y/6, size_x/4*3-1, size_y/4*3-1);
    surface.SetDrawColor(243, 247, 251, 210);
    surface.DrawOutlinedRect(x, y, size_x, size_y);
end

function ClearUI.HalfTip(x, y, size_x, size_y, button, text)
    draw.SimpleText(text, "HudHintTextLarge", x + size_x + 8, y + size_y/2-1, Color(243, 247, 251, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    draw.SimpleText(button, "DermaDefaultBold", x + size_x/2, y + size_y/2-1, Color(255, 255, 255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    surface.SetDrawColor(243, 247, 251, 210);
    surface.DrawOutlinedRect(x, y, size_x, size_y);
end

function StartGameTips()
	if shoulddrawinfo then
		ClearUI.HalfRichTip(13, ScrH()-115-32, 32, 32, nil, "Советуем играть в наушниках.");
		ClearUI.HalfTip(13, ScrH()-120-64, 32, 32, "F2", "Показать список всех игровых ролей.");
		ClearUI.HalfTip(13, ScrH()-125-96, 32, 32, "TAB", "Показать рейтинговую таблицу.");
	end
end

-----------------------------------------------------

function DrawAngleOnBox(x, y, width, height)
	local _Color = Color(255, 255, 255, 25);

	draw.RoundedBox(0, x, y, 10, 1, _Color);
	draw.RoundedBox(0, x, y+1, 1, 9, _Color);

	draw.RoundedBox(0, (x+width)-10, y, 10, 1, _Color);
	draw.RoundedBox(0, (x+width)-1, y+1, 1, 9, _Color);

	draw.RoundedBox(0, x, (height+y)-10, 1, 10, _Color);
	draw.RoundedBox(0, x+1, (y+height)-1, 9, 1, _Color);

	draw.RoundedBox(0, (x+width)-1, (height+y)-10, 1, 10, _Color);
	draw.RoundedBox(0, (x+width)-10, (height+y)-1, 9, 1, _Color);
end

-----------------------------------------------------

-- Локальные переменые
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	--CHudCrosshair = true,
	CHudSecondaryAmmo = true,
	CHudDeathNotice = true
};
local stamina_anim_tick = 0;

-- Создание шрифтов
surface.CreateFont("ImpactBig", {font = "Impact",
                                  size = 45,
								  weight = 700});
								  
surface.CreateFont("ImpactSmall", {font = "Impact",
                                  size = 30,
                                  weight = 700});

surface.CreateFont("RadioFont", {
	font = "Impact",
	extended = false,
	size = 26,
	weight = 7000,
	blursize = 0,
	scanlines = 0});

-----------------------------------------------------

-- Обработка события показа смерти (статы)
function GM:DrawDeathNotice(x,  y) end

-- Отключение всех элементов HUD (которые не нужны)
hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if (hide[name]) then return false end
end)

-- Переменная конечной статы (в конце игры)
endmessages = {
	{
		main = clang.lang_end1,
		txt = clang.lang_end2,
		clr = gteams.GetColor(TEAM_SCP)
	},
	{
		main = clang.lang_end1,
		txt = clang.lang_end3,
		clr = gteams.GetColor(TEAM_SCP)
	}
}

-- Отрисовка информации
function DrawInfo(pos, txt, clr)
	pos = pos:ToScreen()
	draw.TextShadow({
		text = txt,
		pos = {pos.x, pos.y},
		font = "HealthAmmo",
		color = clr,
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}, 2, 255);
end

-----------------------------------------------------

-- Обработка событий за Tick
hook.Add("Tick", "966check", function()
	local hide = true;
	if LocalPlayer().GTeam == nil then return end
	if LocalPlayer():GTeam() == TEAM_SCP then
		hide = false;
	end
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
			hide = false;
		end
	end
	for k,v in pairs(player.GetAll()) do
		if not v.GetNClass then
			player_manager.RunClass(v, "SetupDataTables");
		end
		if v.GetNClass == nil then return end
		if v:GetNClass() == ROLES.ROLE_SCP966 then
			v:SetNoDraw(hide);
		end
	end
end )

local wtf = 12.5; -- Default: 15 [Не изменять]

-- Функция отрисовки блюра
function DrawBlurRect(x, y, w, h, a)
	if GetGlobalBool("NVX_USEBLUR", false) then
		local X, Y = 0, 0;
		local blur = Material("pp/blurscreen");
		local scrW, scrH = ScrW(), ScrH();

		surface.SetDrawColor(255, 255, 255);
		surface.SetMaterial(blur);

		for i = 1, 3 do
			blur:SetFloat("$blur", (i / 3) * (a or 6))
			blur:Recompute();
			render.UpdateScreenEffectTexture();
			render.SetScissorRect(x, y, x+w, y+h, true);
			surface.DrawTexturedRect(X * -1, Y * -1, scrW, scrH);
			render.SetScissorRect(0, 0, 0, 0, false);
		end
   
   		draw.RoundedBox(0,x,y,w,h,Color(0,0,0,190));
	else
		draw.RoundedBox(0,x,y,w,h,Color(0,0,0,190));
	end
end

local Settings = {};
Settings.HintsPos = {
    {Position = Vector(4152.909180, -664.268860, 28.031250), Name = "SCP-079"},
    {Position = Vector(-448.047668, 4760.025391, 28.031250), Name = "Ворота А"},
    {Position = Vector(-2367.854004, 3731.020508, 28.031250), Name = "Комната Управления"},
    {Position = Vector(-3650.900146, 2539.692139, 28.031250), Name = "Ворота Б"},
};

-- Обработка события отрисовки HUD
hook.Add( "HUDPaint", "Breach_DrawHUD", function()

	if GetGlobalBool("NVX_WORLDHINTS", false) then
        for _, v in pairs(Settings.HintsPos) do
            local ToScreen = v.Position:ToScreen();
            local Distance = math.floor(LocalPlayer():GetPos():Distance(v.Position));
            if Distance > 200 and Distance < 2750 then
                draw.SimpleText(v.Name, "DermaDefaultBold", ToScreen.x, ToScreen.y-25, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
                draw.SimpleText("[Дистанция: " .. Distance .. " м]", "DermaDefault", ToScreen.x, ToScreen.y-13, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
                draw.SimpleText("V", "DermaDefaultBold", ToScreen.x, ToScreen.y, Color(255, 255, 255, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
            end
        end
    end

	if GetGlobalBool("NVX_COLDEFFECT") then
        surface.SetDrawColor(255,255,255,20);
		surface.SetMaterial(Material("navexui/navexui_effect1.png"));
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH());

		surface.SetDrawColor(255,255,255,255);
		surface.SetMaterial(Material("navexui/navexui_effect.png"));
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH());
    end

  	navex_check_radio();

	if navex_haveradio then
		DrawBlurRect(ScrW()-60, 10, 50, 60, 4);
		surface.SetDrawColor(Color(255,255,255,75));
		surface.DrawOutlinedRect(ScrW()-60, 10, 50, 60);

		surface.SetMaterial(Material("navex/hud/radioicon.png"));
		surface.SetDrawColor(255, 255, 255);
		surface.DrawTexturedRect(ScrW()-50, 15, 35, 35);
		draw.SimpleText(navex_radiochannel, "DermaDefault", ScrW()-35, 58, Color(255,255,255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	end

	if disablehud == true then return end
	if POS_914B_BUTTON != nil and isstring(buttonstatus) then
		if LocalPlayer():GetPos():Distance(POS_914B_BUTTON) < 200 then
			DrawInfo(POS_914B_BUTTON, buttonstatus, Color(255,255,255));
		end
	end

	-- ПНВ
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
			local nvgOffsetW = ScrW();
			local nvgOffsetH = ScrH();

			surface.SetDrawColor(255, 255, 255, 255);
			surface.SetMaterial(Material("effects/nvg_effect"));
			surface.DrawTexturedRect(0, 0, nvgOffsetW, nvgOffsetH);
		end
	end

	-- SCP-714
	if shoulddrawinfo == true then
		local getrl = LocalPlayer():GetNClass()
		for k,v in pairs(ROLES) do
			if v == getrl then
				getrl = k;
			end
		end
		for k,v in pairs(clang.starttexts) do
			if k == getrl then
				getrl = v;
				break
			end
		end
		local align = 32;
		local tcolor = gteams.GetColor(LocalPlayer():GTeam())
		if LocalPlayer():GTeam() == TEAM_CHAOS then
			tcolor = Color(29, 81, 56);
		end

		DrawBlurRect(ScrW() / 2 - 420, 75, 840, 50 + #getrl[2] * 36, 4);

		if getrl[1] != nil then
			draw.TextShadow( {
				text = getrl[1],
				pos = {ScrW() / 2, 100},
				font = "HUDRoleH1",
				color = Color(tcolor.r, tcolor.g, tcolor.b, 200),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255);
		end

		for i,txt in ipairs(getrl[2]) do
			draw.TextShadow( {
				text = txt,
				pos = {ScrW() / 2, 100 + 10 + (align * i)},
				font = "HUDRoleH2",
				color = Color(255, 255, 255, 200),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255);
		end
	end
	if isnumber(drawendmsg) then
		DrawBlurRect(ScrW() / 2 - 250, 75, 500, 100 + #endinformation * 36, 4);

		local ndtext = clang.lang_end2;
		if drawendmsg == 2 then
			ndtext = clang.lang_end3;
		end
			shoulddrawinfo = false;
			draw.TextShadow({
				text = clang.lang_end1,
				pos = {ScrW() / 2, 100},
				font = "HUDRoleH1",
				color = Color(0, 255, 0),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255);

			draw.TextShadow( {
				text = ndtext,
				pos = {ScrW() / 2, 130},
				font = "HUDRoleH3",
				color = Color(255, 255, 255),
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
			}, 2, 255);

			draw.RoundedBox(0, ScrW() / 2 - 150, 150, 300, 1, Color(255, 255, 255, 200));

			for i,txt in ipairs(endinformation) do
				draw.TextShadow({
					text = txt,
					pos = {ScrW() / 2, 160 + (35 * i)},
					font = "HUDRoleH3",
					color = color_white,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255);
			end
	else
		if isnumber(shoulddrawescape) then
			if CurTime() > lastescapegot then
				shoulddrawescape = nil;
			end
			if clang.escapemessages[shoulddrawescape] then
				local tab = clang.escapemessages[shoulddrawescape];
				draw.TextShadow( {
					text = tab.main,
					pos = {ScrW() / 2, ScrH() / 2.25},
					font = "HUDRoleH1",
					color = tab.clr,
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255);

				draw.TextShadow({
					text = string.Replace( tab.txt, "{t}", string.ToMinutesSecondsMilliseconds(esctime) ),
					pos = {ScrW() / 2, ScrH() / 2},
					font = "HUDRoleH2",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255);

				draw.TextShadow({
					text = tab.txt2,
					pos = {ScrW() / 2, ScrH() / wtf + 75},
					font = "HUDRoleH2",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255);
			end
		end
	end
	local ply = LocalPlayer()
	if ply:Alive() == false then return end

	if ply:GTeam() == TEAM_SPEC then
		local ent = ply:GetObserverTarget();
		if IsValid(ent) then
			if ent:IsPlayer() then
				local sw = 350;
				local sh = 35;
				local sx =  ScrW() / 2 - (sw / 2);
				local sy = 0;
				draw.TextShadow({
					text = string.sub(ent:Nick(), 1, 17),
					pos = {sx + sw / 2, 60},
					font = "HUDRoleH3",
					color = Color(255,255,255),
					xalign = TEXT_ALIGN_CENTER,
					yalign = TEXT_ALIGN_CENTER,
				}, 2, 255);
			end
		end
	end

	local wep = nil;
	local ammo = -1;
	local ammo2 = -1;

	local width = 350;
	local height = 120;
	local role_width = width - 25;

	local x,y;
	x = 10;
	y = ScrH() - height - 10;
	local hl = math.Clamp(LocalPlayer():Health(), 1, LocalPlayer():GetMaxHealth()) / LocalPlayer():GetMaxHealth();
	if hl < 0.06 then hl = 0.06; end

	local name = "None";
	if not ply.GetNClass then
		player_manager.RunClass(ply, "SetupDataTables");
	elseif LocalPlayer():GTeam() != TEAM_SPEC then
		name = GetLangRole(ply:GetNClass());
	else
		local obs = ply:GetObserverTarget()
		if IsValid(obs) then
			if obs.GetNClass != nil then
				name = GetLangRole(obs:GetNClass());
				ply = obs;
			else
				name = GetLangRole(ply:GetNClass());
			end
		else
			name = GetLangRole(ply:GetNClass());
		end
	end
	local color = gteams.GetColor(ply:GTeam());
	if ply:GTeam() == TEAM_CHAOS then
		color = Color(29, 81, 56);
	end

if ply:GTeam() != TEAM_SPEC and ply:GTeam() != TEAM_SCP and ply:GetNWBool( "HaveLense" ) != true then
  
	local bledW = 194;
	local bledH = 25;
	local bledMarg = 25;

	local vledOffsetW = ScrW() - bledW - bledMarg;
	local vledOffsetH = ScrH() - bledH - bledMarg;

	local eye_anim = {Material("navex/hud/eyeicon.png"), Material("navex/hud/eyeicon_r.png")};
	local eye = eye_anim[1];

	DrawBlurRect(vledOffsetW - 48, vledOffsetH - 10, bledW + 60, bledH + 20, 4);

	surface.SetDrawColor(Color(0,0,0,150));
	surface.DrawRect(vledOffsetW, vledOffsetH, bledW, bledH);

	surface.SetDrawColor(Color(255,255,255,100));
	surface.DrawOutlinedRect(vledOffsetW - 1, vledOffsetH - 1, bledW + 2, bledH + 2);

	if (BledLastBlink) then
		local bledDelay = GetConVar("br_time_blinkdelay"):GetInt();
		local bledSub = (BledLastBlink - CurTime() + bledDelay)/bledDelay - 0.05;
		local loool = math.ceil(60*bledSub*16/160); if loool <= 0 then loool = 0; end
		if (bledSub < 0) then eye = eye_anim[2]; else eye = eye_anim[1]; end

		surface.SetDrawColor(Color(255,255,255,100));
		draw.SimpleText(loool .. " сек", "HudHintTextLarge", vledOffsetW + 2+190/2, vledOffsetH + 12, Color(255,255,255,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		draw.RoundedBox(0, vledOffsetW + 2, vledOffsetH + 2, (190*bledSub*16/16), bledH - 4, Color(255, 255, 255, 40));
	end

	surface.SetDrawColor(Color(255,255,255,255));
	surface.SetMaterial(eye);
	surface.DrawTexturedRect(vledOffsetW - bledH - 10, vledOffsetH, bledH, bledH);

	DrawAngleOnBox(vledOffsetW - 48, vledOffsetH - 10, bledW + 60, bledH + 20);

	-- =====БЕГ=====
	-- Сделано под Navex Breach 1.0.0
	local _player = LocalPlayer()
	if !LocalPlayer().Stamina then LocalPlayer().Stamina = 100; end
	local stamina = math.Round(LocalPlayer().Stamina);

	local staminab = math.Round(stamina / 100 * 15);
	if staminab > 15 then staminab = 15; end

	local sprintW = 194;
	local sprintH = 25;
	local sprintM = 25;

	local _vledOffsetW = ScrW() - sprintW - sprintM;
	local _vledOffsetH = ScrH() - sprintH - sprintM;

	DrawBlurRect(_vledOffsetW - 48, _vledOffsetH - 60, sprintW + 60, sprintH + 20, 4);

	surface.SetDrawColor(Color(0,0,0,150));
	surface.DrawRect(_vledOffsetW, _vledOffsetH - 50, sprintW, sprintH);

	surface.SetDrawColor(Color(255,255,255,100));
	surface.DrawOutlinedRect(_vledOffsetW - 1, _vledOffsetH - 50, sprintW + 2, sprintH + 2);

	local mat_stamina = Material("navex/hud/staminaicon_0.png");
	local stamina_anim_run = false;
	local stamina_anim = {Material("navex/hud/staminaicon_0.png"), Material("navex/hud/staminaicon_3.png"),
						  Material("navex/hud/staminaicon_1.png"), Material("navex/hud/staminaicon_2.png")};

	if (LocalPlayer():KeyDown(IN_SPEED)) then
		stamina_anim_run = true;
	else
		stamina_anim_run = false;
	end

	if (LocalPlayer():KeyReleased(IN_JUMP) or LocalPlayer():KeyDown(IN_FORWARD) or 
		LocalPlayer():KeyDown(IN_BACK) or LocalPlayer():KeyDown(IN_MOVELEFT) or
		LocalPlayer():KeyDown(IN_MOVERIGHT)) then

	if (not stamina_anim_run) then
		stamina_anim_tick = stamina_anim_tick + 1;
		if (stamina_anim_tick <= 32) then
			mat_stamina = stamina_anim[1];
		elseif (stamina_anim_tick >= 32 and stamina_anim_tick <= 64) then
			mat_stamina = stamina_anim[2];
		end
		if (stamina_anim_tick >= 64) then stamina_anim_tick = 0; end
	end
	end
	if (LocalPlayer():KeyDown(IN_JUMP) or LocalPlayer():KeyDown(IN_FORWARD) or 
			LocalPlayer():KeyDown(IN_BACK) or LocalPlayer():KeyDown(IN_MOVELEFT) or
			LocalPlayer():KeyDown(IN_MOVERIGHT)) and (LocalPlayer():KeyDown(IN_SPEED)) then

		stamina_anim_tick = stamina_anim_tick + 1;
		if (stamina_anim_tick <= 32) then
			mat_stamina = stamina_anim[3];
		elseif (stamina_anim_tick >= 32 and stamina_anim_tick <= 64) then
			mat_stamina = stamina_anim[4];
		end
		if (stamina_anim_tick >= 64) then stamina_anim_tick = 0; end
	end

	surface.SetDrawColor(Color(255,255,255,255))
	surface.SetMaterial(mat_stamina)
	surface.DrawTexturedRect(_vledOffsetW - sprintH - 10, _vledOffsetH - 49, sprintH, sprintH)

	draw.SimpleText(stamina .. " %", "HudHintTextLarge", _vledOffsetW + 2+190/2, _vledOffsetH - 37, Color(255,255,255,100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	draw.RoundedBox(0, _vledOffsetW + 2, _vledOffsetH - 47, (200 - 9)/100 * stamina, sprintH - 4, Color(255, 255, 255, 40));

	DrawAngleOnBox(_vledOffsetW - 48, _vledOffsetH - 60, sprintW + 60, sprintH + 20);
end

	local bledW = 194;
	local bledH = 25;
	local bledMarg = 25;

	local vledOffsetW = ScrW() - bledW - bledMarg;
	local vledOffsetH = ScrH() - bledH - bledMarg;

	local sprintW = 194;
	local sprintH = 25;
	local sprintM = 25;

	local _vledOffsetW = ScrW() - sprintW - sprintM;
	local _vledOffsetH = ScrH() - sprintH - sprintM;

	-- Обновленный health бар

  	if not(ply:GTeam() == TEAM_SPEC) then
		DrawBlurRect(13, vledOffsetH - 10, bledW + 60, bledH + 20, 4);

		surface.SetDrawColor(Color(0,0,0,150));
		surface.DrawRect(61, vledOffsetH, bledW, bledH);

		surface.SetDrawColor(Color(255,255,255,255));
		surface.SetMaterial(Material("navex/hud/healthicon.png"));
		surface.DrawTexturedRect(60 - bledH - 10, vledOffsetH, bledH, bledH);

		surface.SetDrawColor(Color(255,255,255,100));
		surface.DrawOutlinedRect(60, vledOffsetH - 1, bledW + 2, bledH + 2);

		local width = 350

		draw.RoundedBox(0, 75-12, y + 82, (width - 160) * hl, 21, Color(255, 0, 0, 75));
		draw.SimpleText(math.floor(LocalPlayer():Health()) .. " HP", "HudHintTextLarge", role_width / 2 + 8-12, y + 42*2.175, Color(255,255,255, 175), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	  
		DrawAngleOnBox(13, vledOffsetH - 10, bledW + 60, bledH + 20);
	end

	-- Обновленный role бар
  	local scale_role_time = 0;
  
  	if (ply:GTeam() == TEAM_SPEC) then scale_role_time = bledH + 20; else scale_role_time = 0; end

	DrawBlurRect(13, vledOffsetH - 60 + scale_role_time, bledW + 60, bledH + 20, 4);

	surface.SetDrawColor(Color(0,0,0,150));
	surface.DrawRect(61, vledOffsetH - 50 + scale_role_time, bledW, bledH);

	surface.SetDrawColor(Color(255,255,255,255));
	surface.SetMaterial(Material("navex/hud/roleicon.png"));
	surface.DrawTexturedRect(60 - bledH - 10, vledOffsetH - 50 + scale_role_time, bledH, bledH);

	surface.SetDrawColor(Color(255,255,255,100));
	surface.DrawOutlinedRect(60, vledOffsetH - 51 + scale_role_time, bledW + 2, bledH + 2);
  
  	surface.SetDrawColor(255,255,255,255);
	surface.SetMaterial(Material("navex/hud/white.png"));
  	surface.DrawTexturedRect(75-12, y + 32 + scale_role_time, (width - 160), 21);
  
	draw.RoundedBox(0, 75-12, y +32 + scale_role_time, role_width -135, 21, Color(color.r, color.g, color.b, 220));

	draw.SimpleText(name, "ChatFont", role_width / 2 + 7-12, y + 42 + scale_role_time+1, Color(255,255,255,225), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	DrawAngleOnBox(13, vledOffsetH - 60 + scale_role_time, bledW + 60, bledH + 20);

	-- Осталось живых

	if (ply:GTeam() == TEAM_SPEC) then
		DrawBlurRect(13, vledOffsetH - 60 - 5, 199, bledH + 20, 4);
		draw.SimpleText("ИГРОКОВ ЖИВО", "Trebuchet18", 13 + 12, vledOffsetH - 65 + (bledH + 20)/2, Color(243,247,251,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
		surface.SetDrawColor(255, 255, 255, 140);
		surface.DrawOutlinedRect(165, vledOffsetH - 60, 35, 35);
		draw.SimpleText(GetGlobalInt("AliveIV_7D9F", 0), "HudHintTextLarge", 165 + 35/2, vledOffsetH - 66 + (bledH + 20)/2, Color(243,247,251,160), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
		DrawAngleOnBox(13, vledOffsetH - 60 - 5, 199, bledH + 20);
	end

	-- Обновленный time бар
	DrawBlurRect(ScrW()/2-65, 10, 130, 40, 4);
	surface.SetDrawColor(255, 255, 255, 40);
	surface.DrawOutlinedRect(ScrW()/2-65, 10, 130, 40);
	surface.DrawRect(ScrW()/2-200, 29, 125, 1);
	surface.DrawRect(ScrW()/2+75, 29, 125, 1);

	draw.SimpleText(tostring(string.ToMinutesSeconds(cltime)), "DermaLarge", ScrW()/2, 31, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	
	-- TIPS
	StartGameTips();

	-- ПАТРОНЫ
	local ammotext = nil;
	local wep = nil;

	if ply:GetActiveWeapon() != nil and #ply:GetWeapons() > 0 then
		wep = ply:GetActiveWeapon();
		if wep then
			if wep.Clip1 == nil then return end
			if wep:Clip1() > -1 then
				ammo1 = wep:Clip1();
				ammo2 = ply:GetAmmoCount(wep:GetPrimaryAmmoType());
				ammotext = ammo1 .. " / ".. ammo2;
			end
		end
	end

	if not ammotext then return end
	local am = math.Clamp(wep:Clip1(), 0, wep:GetMaxClip1()) / wep:GetMaxClip1();

	DrawBlurRect(285, vledOffsetH - 10, bledW + 60-100, bledH + 20, 4);

	surface.SetDrawColor(Color(255,255,255,255));
	surface.SetMaterial(Material("navex/hud/ammoicon.png"));
	surface.DrawTexturedRect(332 - bledH - 10, vledOffsetH, bledH, bledH);

	draw.TextShadow({
		text = ammotext,
		pos = {285 + 40 + 115/2, y + 42*2.175},
		font = "Trebuchet24",
		color = Color(255,255,255, 175),
		xalign = TEXT_ALIGN_CENTER,
		yalign = TEXT_ALIGN_CENTER,
	}, 2, 255);

	DrawAngleOnBox(285, vledOffsetH - 10, bledW + 60-100, bledH + 20, 4);
end);


