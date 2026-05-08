--[[
gamemodes/breach/gamemode/cl_mtfmenu.lua
--]]
local countOfButtons = 0;

if not MTFMenuFrame then
	MTFMenuFrame = nil
end

nextmenudelete = 0
showmenu = false

function GM:KeyPress( ply, key )
	if ( key == IN_ZOOM ) then
		OpenMenu()
	end
end

function GM:KeyRelease( ply, key )
	if ( key == IN_ZOOM ) then
		CloseMTFMenu()
	end
end

function CloseMTFMenu()
	if ispanel(MTFMenuFrame) then
		if MTFMenuFrame.Close then
			MTFMenuFrame:Close()
		end
	end
end

function OpenMenu()
  if (LocalPlayer():GetNClass() == ROLES.ROLE_CHAOS or LocalPlayer():GetNClass() == ROLES.ROLE_MTFNTF) then
    countOfButtons = 7;
  else
    countOfButtons = 7;
  end
  
	if IsValid(MTFMenuFrame) then return end
	local ply = LocalPlayer()
	if !(ply:GTeam() == TEAM_GUARD or ply:GTeam() == TEAM_CHAOS or ply:GTeam() == TEAM_GOK or ply:GTeam() == TEAM_PSIXON or ply:GTeam() == TEAM_SNEAK) then return end
	local clevel = LocalPlayer():CLevelGlobal()
	
	MTFMenuFrame = vgui.Create( "DFrame" )
	MTFMenuFrame:SetTitle( "" )
	MTFMenuFrame:SetSize( 265, 40 * countOfButtons +24+57 )
	MTFMenuFrame:Center()
	MTFMenuFrame:SetDraggable( true )
	MTFMenuFrame:SetDeleteOnClose( true )
	MTFMenuFrame:SetDraggable( false )
	MTFMenuFrame:ShowCloseButton( false )
	MTFMenuFrame:MakePopup()
	MTFMenuFrame.Paint = function( self, w, h )
    	Derma_DrawBackgroundBlur( self, self.startTime );
    
    	surface.SetDrawColor(Color(255,255,255, 170));
    	surface.SetMaterial(Material("hud_scp/scp_hud.png"));
    	surface.DrawTexturedRect(0, 0, w, h);

    	surface.SetDrawColor(Color(255,255,255, 5));
    	surface.DrawOutlinedRect(0, 0, w, h);
	end
	
	local maininfo = vgui.Create( "DLabel", MTFMenuFrame )
	maininfo:SetText("ПАНЕЛЬ ДЕЙСТВИЙ");
	maininfo:Dock( TOP )
  	maininfo:SetTextColor(Color(0,0,0));
	maininfo:SetFont("MTF_2Main")
	maininfo:SetContentAlignment( 5 )
	maininfo:SetSize(0,32)
	maininfo.Paint = function( self, w, h )
		surface.SetDrawColor(Color(255,255,255, 170));
    	surface.SetMaterial(Material("hud_scp/white.png"));
    	surface.DrawTexturedRect(0, 5, w, h-10);

    	draw.RoundedBox(0, 0, 5, w, h-10, Color(100, 100, 255, 55));

    	surface.SetDrawColor(Color(255,255,255, 10));
    	surface.DrawOutlinedRect(0, 5, w, h-10);
	end
	
	if (ply:GetNClass() == ROLES.ROLE_CHAOS or ply:GetNClass() == ROLES.ROLE_MTFNTF) then
		if clevel > 3 then
			local button_gatea = vgui.Create( "DButton", MTFMenuFrame )
			button_gatea:SetText( "Попросить показать ID карту" )
			button_gatea:Dock( TOP )
			button_gatea:SetFont("MTF_Main")
			button_gatea:SetContentAlignment( 5 )
			button_gatea:DockMargin( 0, 5, 0, 0	)
			button_gatea:SetSize(0,32)
			button_gatea.DoClick = function()
				RunConsoleCommand("br_sound_idcard")
				MTFMenuFrame:Close()
			end
			button_gatea:SetTextColor(Color(0,0,0));
			button_gatea.Paint = but_navex_design;
		end
	end
	
	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Начать эвакуацию" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_requestescort")
		MTFMenuFrame:Close()
	end

	button_escort:SetTextColor(Color(0,0,0));
	button_escort.Paint = but_navex_design;

	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Звук: Рандом" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_random")
		MTFMenuFrame:Close()
	end

	button_escort:SetTextColor(Color(0,0,0));
	button_escort.Paint = but_navex_design;

	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Звук: Поиск" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_searching")
		MTFMenuFrame:Close()
	end
	
	button_escort:SetTextColor(Color(0,0,0));
	button_escort.Paint = but_navex_design;

	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Звук: Цель обнаружена" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_classd")
		MTFMenuFrame:Close()
	end

	button_escort:SetTextColor(Color(0,0,0));
	button_escort.Paint = but_navex_design;

	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Звук: Стоп!" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_stop")
		MTFMenuFrame:Close()
	end

	button_escort:SetTextColor(Color(0,0,0));
	button_escort.Paint = but_navex_design;

	local button_escort = vgui.Create( "DButton", MTFMenuFrame )
	button_escort:SetText( "Звук: Цель потеряна" )
	button_escort:Dock( TOP )
	button_escort:SetFont("MTF_Main")
	button_escort:SetContentAlignment( 5 )
	button_escort:DockMargin( 0, 5, 0, 0	)
	button_escort:SetSize(0,32)
	button_escort.DoClick = function()
		RunConsoleCommand("br_sound_lost")
		MTFMenuFrame:Close()
	end

	button_escort:SetTextColor(Color(0,0,0));
	button_escort.Paint = but_navex_design;
end

function but_navex_design(self, w, h)
	surface.SetDrawColor(Color(255,255,255, 195));
	if (self:IsDown()) then surface.SetDrawColor(Color(255,255,255, 90)); end
    surface.SetMaterial(Material("hud_scp/white.png"));
    surface.DrawTexturedRect(0, 0, w, h);

    surface.SetDrawColor(Color(255,255,255, 10));
    surface.DrawOutlinedRect(0, 0, w, h);
end






