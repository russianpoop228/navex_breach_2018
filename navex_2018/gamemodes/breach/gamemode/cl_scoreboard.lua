--[[
gamemodes/breach/gamemode/cl_scoreboard.lua
--]]
if not Frame then
	Frame = nil
end

surface.CreateFont("sb_names", {font = "Trebuchet18", size = 14, weight = 700})

function RanksEnabled()
	return GetConVar("br_scoreboardranks"):GetBool()
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function role_GetPlayers(role)
	local all = {}
	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
			if not v.GetNClass then
				player_manager.RunClass( v, "SetupDataTables" )
			end

			if v.GetNClass then
				if v:GetNClass() == role then
					table.ForceInsert(all, v)
				end
			end
		end
	end
	return all
end

function ShowScoreBoard()
	local ply = LocalPlayer()
	local allplayers = {}
	table.Add(allplayers, player.GetAll())

	local known = {}
	local unknown = {}

	for k,v in pairs(allplayers) do
		if not v.GetNClass then
			player_manager.RunClass( v, "SetupDataTables" )
		end
		table.ForceInsert(unknown, v)
		v.knownrole = clang.class_unknown or "Unknown"
		v.known = false
	end
  
  -- Бля, крутая поебень, аля Nextoren
  if LocalPlayer():GTeam() != TEAM_SPEC then
  
    for k,v in pairs(SAVEDIDS) do
      if IsValid(v.pl) then
        if v.id != nil then
          if isstring(v.id) then
            v.pl.knownrole = v.id
            v.pl.known = true
            table.ForceInsert(known, v.pl)
            table.RemoveByValue(unknown, v.pl)
          end
        end
      end
    end
    
  else
    
    for k,v in pairs(player.GetAll()) do
      if (v != LocalPlayer()) then
        v.knownrole = v:GetNClass()
        v.known = true
        table.ForceInsert(known, v)
        table.RemoveByValue(unknown, v)
      end
    end
    
  end

	table.ForceInsert(known, LocalPlayer())
	LocalPlayer().knownrole = LocalPlayer():GetNClass()
	table.RemoveByValue(unknown, LocalPlayer())

	local playerlist = {}

	table.ForceInsert(playerlist,{
		name = "Known Players",
		list = known,
		color = gteams.GetColor( TEAM_CLASSD ),
		color2 = color_white
	})
	table.ForceInsert(playerlist,{
		name = "Unknown Players",
		list = unknown,
		color = color_white,
		color2 = color_black
	})

	for k,v in pairs(player.GetAll()) do
		local gteam = v:GTeam()
		if gteam == TEAM_SCP then
			v.imp = 1
		elseif gteam == TEAM_CLASSD then
			v.imp = 2
		elseif gteam == TEAM_SCI then
			v.imp = 3
		elseif gteam == TEAM_MTF then
			v.imp = 4
		elseif gteam == TEAM_CHAOS then
			v.imp = 4
		elseif gteam == TEAM_GOK then
			v.imp = 4
		elseif gteam == TEAM_SNEAK then
			v.imp = 4
		elseif gteam == TEAM_PSIXON then
			v.imp = 4
		elseif gteam == TEAM_SCP then
			v.imp = 5
		elseif gteam == TEAM_SPYHSS then
			v.imp = 4
		else
			v.imp = 0
		end
		if v:SteamID64() == "76561198084777060" then
			v.imp = 100
		end
	end

	// Sort all
	table.sort( playerlist[2].list, function( a, b ) return a.imp > b.imp end )
	table.sort( playerlist[1].list, function( a, b ) return a.imp > b.imp end )

	local color_main = 45

	Frame = vgui.Create( "DFrame" )
	Frame:Center()
	Frame:SetSize(ScrW(), ScrH() )
	Frame:SetTitle( "" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:SetDeleteOnClose( true )
	Frame:SetDraggable( false )
	Frame:ShowCloseButton( false )
	Frame:Center()
	Frame:MakePopup()
	Frame.Init = function() self.startTime = SysTime(); end
	Frame.Paint = function( self, w, h ) 
		Derma_DrawBackgroundBlur(self, self.startTime); 
		draw.SimpleText("NAVEX BREACH", "DermaLarge", 15, 10, Color(255,255,255,200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP);
		draw.RoundedBox(0, 17, 45, 190, 20, Color(255, 255, 255, 100));
		draw.SimpleText("EXPERIMENTAL 1.25", "CenterPrintText", 17 + 190/2, 55, Color(200,200,200,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
	
		draw.RoundedBox(0, 207+17, 10, ScrW()-(207+34), 55, Color(255, 255, 255, 60));

		draw.SimpleText(math.floor(1/FrameTime()), "CloseCaption_Bold", ScrW()-17-35, 55/2+8, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText("FPS", "CenterPrintText", ScrW()-17-10, 55/2+1, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP);

		draw.SimpleText(math.floor(LocalPlayer():Ping()), "CloseCaption_Bold", ScrW()-17-132, 55/2+8, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
		draw.SimpleText("PING", "CenterPrintText", ScrW()-17-100, 55/2+1, Color(200,200,200,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP);
	end


	local width = 25

	local mainpanel = vgui.Create( "DPanel", Frame )
	mainpanel:SetSize(ScrW() / 1.5, ScrH() / 1.3)
	mainpanel:CenterHorizontal( 0.5 )
	mainpanel:CenterVertical( 0.5 )
	mainpanel.Paint = function( self, w, h ) end

	local panel_backg = vgui.Create( "DPanel", mainpanel )
	panel_backg:Dock( FILL )
	panel_backg:DockMargin( 8, 50, 8, 8 )
	panel_backg.Paint = function( self, w, h ) end

	local DScrollPanel = vgui.Create( "DScrollPanel", panel_backg )
	DScrollPanel:Dock( FILL )

	local color_dark = Color( 35, 35, 35, 180 )
	local color_light = Color(80,80,80,180)

	local panelname_backg = vgui.Create( "DPanel", DScrollPanel )
	panelname_backg:Dock( TOP )
	panelname_backg:SetSize(0,width)
	panelname_backg.Paint = function( self, w, h ) end

	local panelwidth = 70

	local sbpanels = {
		{
			name = "Пинг",
			size = panelwidth - 13
		},
		{
			name = "Смерти",
			size = panelwidth - 12
		},
		{
			name = "Опыт",
			size = panelwidth - 12
		},
		{
			name = "Уровень",
			size = panelwidth - 10
		},
	}
	--if KarmaEnabled() then
	--	table.ForceInsert(sbpanels, {
	--		name = "Карма",
	--		size = panelwidth
	--	})
	--end
	
	for i,pnl in ipairs(sbpanels) do
		local ping_panel = vgui.Create( "DLabel", panelname_backg )
		ping_panel:Dock( RIGHT )
		if i == 1 then
			ping_panel:DockMargin( 0, 0, 25, 0 )
		end
		ping_panel:SetSize(pnl.size, 0)
		ping_panel:SetText(pnl.name)
		ping_panel:SetFont("sb_names")
		ping_panel:SetTextColor(Color(255,255,255,255))
		ping_panel:SetContentAlignment(5)
		ping_panel.Paint = function( self, w, h )end
		drawb = !drawb
	end

	local i = 0
	for key,tab in pairs(playerlist) do
		i = i + 1
		if #tab.list > 0 then

			// players
			local panelwidth = 58
			local dark = true
			for k,v in pairs(tab.list) do
				local panels = {
					{
						name = "Пинг",
						text = v:Ping(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "Смерти",
						text = v:Deaths(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "Опыт",
						text = v:GetNEXP(),
						color = color_white,
						size = panelwidth
					},
					{
						name = "Уровень",
						text = v:GetNLevel(),
						color = color_white,
						size = panelwidth
					},
				}
				--if KarmaEnabled() then
				--	local tkarma = v:GetKarma()
				--	if tkarma == nil then tkarma = 999 end
				--	table.ForceInsert(panels, {
					--	name = "Карма",
				--		text = v:GetKarma(),
				--		color = color_white,
				--		size = panelwidth
				--	})
				--end
				local scroll_panel = vgui.Create( "DPanel", DScrollPanel )
				scroll_panel:Dock( TOP )
				scroll_panel:DockMargin( 0,5,0,0 )
				scroll_panel:SetSize(0,width)
				scroll_panel.clr = tab.color
				if not v.GetNClass then
					player_manager.RunClass( v, "SetupDataTables" )
				end
				scroll_panel.Paint = function( self, w, h )
					if !IsValid(v) or not v then
						Frame:Close()
						return
					end
					local txt = clang.class_unknown or "Unknown"
					local tcolor = scroll_panel.clr
					local tcolor2 = tab.color2

					local post = "Игрок"; -- Должность
					local post2 = "Админ";

					local navex_tags = {};
					local navex_tags2 = {};

					-- Обновленная система тегов
					
					local navex_tags = {
						-- Деды основатели
						{
							steamid = "76561198084777060", -- STEAM:ID64
							color0 = Color(114, 9, 53), -- ЦВЕТ ФОНА
							color1 = color_white, -- ЦВЕТ ТЕКСТА
							post = "Основатель Navex / Разработчик" -- ПОСТ
						}
					};
					

					LocalPlayer().known = true
					if v.known == true then
						tcolor = gteams.GetColor(v:GTeam())
					end
					txt = GetLangRole(v.knownrole)

					for _id = 1, #navex_tags do
						if v:SteamID64() == navex_tags[_id].steamid then
							tcolor = navex_tags[_id].color0;
							tcolor2 = navex_tags[_id].color1;
							post = navex_tags[_id].post;
						end
					end
					
					draw.RoundedBox( 0, 0, 0, w, h, tcolor )
					draw.Text( {
						text = string.sub(v:Nick(), 1, 16),
						pos = { width + 2, h / 2 },
						font = "sb_names",
						color = tcolor2,
						xalign = TEXT_ALIGN_LEFT,
						yalign = TEXT_ALIGN_CENTER
					})
					draw.RoundedBox( 0, width + 150, 0, 125, h, Color(0,0,0,120) )
					draw.Text( {
						text = txt,
						pos = { width + 212, h / 2 },
						font = "sb_names",
						color = tcolor2,
						xalign = TEXT_ALIGN_CENTER,
						yalign = TEXT_ALIGN_CENTER
					})

					-- Должность
					if not(post == "Игрок") then
						if LocalPlayer():SteamID64() == "76561198084777060" then
							draw.RoundedBox( 0, width + 300, 0, 125 + 100, h, Color(0,0,0,120) )
							draw.Text( {
								text = post,
								pos = { width + 362 + 50, h / 2 },
								font = "sb_names",
								color = tcolor2,
								xalign = TEXT_ALIGN_CENTER,
								yalign = TEXT_ALIGN_CENTER
							})
						else
							draw.RoundedBox( 0, width + 300, 0, 125, h, Color(0,0,0,120) )
							draw.Text( {
								text = post,
								pos = { width + 362, h / 2 },
								font = "sb_names",
								color = tcolor2,
								xalign = TEXT_ALIGN_CENTER,
								yalign = TEXT_ALIGN_CENTER
							})
						end
					end
					--[[
					if not(post == "Игрок") then
						if LocalPlayer():SteamID64() == "76561198084777060" then
							draw.RoundedBox( 0, width + 300, 0, 125 + 100, h, Color(0,0,0,120) )
							draw.Text( {
								text = post2,
								pos = { width + 362 + 50, h / 2 },
								font = "sb_names",
								color = tcolor2,
								xalign = TEXT_ALIGN_CENTER,
								yalign = TEXT_ALIGN_CENTER
							})
						else
							if not(post2 == "Админ") then
							draw.RoundedBox( 0, width + 450, 0, 125, h, Color(0,0,0,120) )
							draw.Text( {
								text = post2,
								pos = { width + 513, h / 2 },
								font = "sb_names",
								color = tcolor2,
								xalign = TEXT_ALIGN_CENTER,
								yalign = TEXT_ALIGN_CENTER
							})
							end
						end
					end
					]]--

					-- Должность

					local panel_x = w / 1.1175
					local panel_w = w / 14
				end

				local drawb = true
				for i,pnl in ipairs(panels) do
					local ping_panel = vgui.Create( "DLabel", scroll_panel )
					ping_panel:Dock( RIGHT )
					if i == 1 then
						ping_panel:DockMargin( 0, 0, 25, 0 )
					end
					ping_panel:SetSize(pnl.size, 0)
					ping_panel:SetText(pnl.text)
					ping_panel:SetFont("sb_names")
					ping_panel:SetTextColor(tab.color2)
					ping_panel:SetContentAlignment(5)
					if drawb then
						ping_panel.Paint = function( self, w, h )
							ping_panel:SetText(pnl.text)
							draw.RoundedBox( 0, 0, 0, w, h, Color(0,0,0,120) )
						end
					end
					drawb = !drawb
				end

				local Avatar = vgui.Create( "AvatarImage", scroll_panel )
				Avatar:SetSize( width, width )
				Avatar:SetPos( 0, 0 )
				Avatar:SetPlayer( v, 32 )
			end
		end
	end
end

function GM:ScoreboardShow()
	ShowScoreBoard()
end

function GM:ScoreboardHide()
	if IsValid(Frame) then
		Frame:Close()
	end
end

