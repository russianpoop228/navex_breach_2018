--[[
gamemodes/breach/gamemode/cl_init.lua
--]]
include("shared.lua")
include("gteams.lua")
include("fonts.lua")
include("class_breach.lua")
include("classes.lua")
include("cl_classmenu.lua")
include("sh_player.lua")
include("cl_mtfmenu.lua")
include("cl_scoreboard.lua")
include( "cl_sounds.lua" )
include( "cl_targetid.lua" )
include( "cl_headbob.lua" )

surface.CreateFont( "173font", {
	font = "TargetID",
	extended = false,
	size = 22,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
} )

surface.CreateFont( "SCPPointFont", {
	font = "UiBold",
	size = 22,
	weight = 1500,
    shadow = false,
	outline = false,
	antialias = false,
})

surface.CreateFont( "SCPPointFont2", {
	font = "UiBold",
	size = 22,
	weight = 1500,
    shadow = false,
	outline = false,
	antialias = false,
	blursize = 5,
})

SAVEDIDS = {}
function CheckIDCard()

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

	table.ForceInsert(known, LocalPlayer())
	LocalPlayer().knownrole = LocalPlayer():GetNClass()
	table.RemoveByValue(unknown, LocalPlayer())

end

lastidcheck = 0
function AddToIDS(ply)
	if lastidcheck > CurTime() then return end
	local sid = nil
	local wep = ply:GetActiveWeapon()
	if not ply.GetNClass then
		player_manager.RunClass( ply, "SetupDataTables" )
	end
	if ply:GTeam() == TEAM_SCP then
		sid = ply:GetNClass()
	else
		if IsValid(wep) then
			if wep:GetClass() == "br_id" then
				sid = ply:GetNClass()
				CheckIDCard()
			end
		end
		
		if IsValid(wep) then
			if wep:GetClass() == "br_id_hs" then
				sid = ply:GetNClass()
				CheckIDCard()
			end
		end

	end
	if sid == ROLES.ROLE_HSSPY then
		if (LocalPlayer():GTeam() == TEAM_SCI) or (LocalPlayer():GTeam() == TEAM_GUARD) then
			sid = ROLES.ROLE_MTFGUARD
		end
	end
	for k,v in pairs(SAVEDIDS) do
		if v.pl == ply then
			if v.id == sid then
				lastidcheck = CurTime() + 0.5
				return
			end
		end
	end
	table.ForceInsert(SAVEDIDS, {pl = ply, id = sid})

	// messaging
	if sid == nil then
		sid = "unknown id"
	else
		sid = "id: " .. sid
	end
	local sname = "Added new id: " .. ply:Nick() .. " with " .. sid
	print(sname)
	lastidcheck = CurTime() + 0.7
end

buttonstatus = "Режим: Грубо"

clang = nil
ALLLANGUAGES = {}

local files, dirs = file.Find(GM.FolderName .. "/gamemode/languages/*.lua", "LUA" )
for k,v in pairs(files) do
	local path = "languages/"..v
	if string.Right(v, 3) == "lua" then
		include( path )
		print("Loading language: " .. path)
	end
end

langtouse = CreateClientConVar( "br_language", "english", true, false ):GetString()

cvars.AddChangeCallback( "br_language", function( convar_name, value_old, value_new )
	langtouse = value_new
	if ALLLANGUAGES[langtouse] then
		clang = ALLLANGUAGES[langtouse]
	end
end )

print("langtouse:")
print(langtouse)

if ALLLANGUAGES[langtouse] then
	clang = ALLLANGUAGES[langtouse]
else
	clang = ALLLANGUAGES.english
end

mapfile = "mapconfigs/" .. game.GetMap() .. ".lua"
include(mapfile)

include("cl_hud.lua")

RADIO4SOUNDSHC = {
	{"chatter1", 39},
	{"chatter2", 72},
	{"chatter4", 12},
	{"franklin1", 8},
	{"franklin2", 13},
	{"franklin3", 12},
	{"franklin4", 19},
	{"ohgod", 25}
}

RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)

disablehud = false
livecolors = false

function DropCurrentVest()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		net.Start("DropCurrentVest")
		net.SendToServer()
	end
end

--SCPS_ENTS
function DropSCP714()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		net.Start("DropSCP714")
		net.SendToServer()
	end
end

function DropSCP178()
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		net.Start("DropSCP178")
		net.SendToServer()
	end
end

-- concommand.Add( "br_spectate", function( ply, cmd, args )
	-- net.Start("SpectateMode")
	-- net.SendToServer()
-- end )

concommand.Add( "br_roundrestart_cl", function( ply, cmd, args )
	if ply:IsSuperAdmin() then
		net.Start("RoundRestart")
		net.SendToServer()
	end
end )

concommand.Add( "br_dropvest", function( ply, cmd, args )
	DropCurrentVest()
end )

concommand.Add( "br_disableallhud", function( ply, cmd, args )
	disablehud = !disablehud
end )

concommand.Add( "br_livecolors", function( ply, cmd, args )
	if livecolors then
		livecolors = false
		chat.AddText("livecolors disabled")
	else
		livecolors = true
		chat.AddText("livecolors enabled")
	end
end )

gamestarted = false
cltime = 0
drawinfodelete = 0
shoulddrawinfo = false
drawendmsg = nil
timefromround = 0

local navex_kostil_cltime = 780;

timer.Create("HeartbeatSound", 2, 0, function()
	if not LocalPlayer().Alive then return end
	if LocalPlayer():Alive() and LocalPlayer():GTeam() != TEAM_SPEC then
		if LocalPlayer():Health() < 30 then
			LocalPlayer():EmitSound("heartbeat.ogg")
		end
	end
end)

function OnUseEyedrops(ply) end

function StartTime()
	timer.Destroy("UpdateTime")
	timer.Create("UpdateTime", 1, 0, function()
		if cltime > 0 then
			cltime = cltime - 1
      navex_kostil_cltime = navex_kostil_cltime - 1;
		end
	end)
end

endinformation = {}

net.Receive( "Update914B", function( len )
	local sstatus = net.ReadInt(6)
	if sstatus == 0 then
		buttonstatus = "Режим: Грубо"
	elseif sstatus == 1 then
		buttonstatus = "Режим: Очень Грубо"
	elseif sstatus == 2 then
		buttonstatus = "Режим: 1 к 1"
	elseif sstatus == 3 then
		buttonstatus = "Режим: Тонко"
	elseif sstatus == 4 then
		buttonstatus = "Режим: Очень Тонко"
	end
end)

net.Receive( "UpdateTime", function( len )
	cltime = tonumber(net.ReadString())
	StartTime()
end)

net.Receive( "OnEscaped", function( len )
	local nri = net.ReadInt(4)
	shoulddrawescape = nri
	esctime = CurTime() - timefromround
	lastescapegot = CurTime() + 20
	SlowFadeBlink(5)
end)

net.Receive( "ForcePlaySound", function( len )
	local sound = net.ReadString()
	surface.PlaySound(sound)
end)

net.Receive( "UpdateRoundType", function( len )
	roundtype = net.ReadString()
	print("Current roundtype: " .. roundtype)
end)

net.Receive( "SendRoundInfo", function( len )
	local infos = net.ReadTable()
	endinformation = {
		string.Replace( clang.lang_pldied, "{num}", infos.deaths ),
		string.Replace( clang.lang_descaped, "{num}", infos.descaped ),
		string.Replace( clang.lang_sescaped, "{num}", infos.sescaped ),
		string.Replace( clang.lang_rescaped, "{num}", infos.rescaped ),
		string.Replace( clang.lang_dcaptured, "{num}", infos.dcaptured ),
		string.Replace( clang.lang_rescorted, "{num}", infos.rescorted ),
		string.Replace( clang.lang_teleported, "{num}", infos.teleported ),
		string.Replace( clang.lang_snapped, "{num}", infos.snapped ),
		string.Replace( clang.lang_zombies, "{num}", infos.zombies )
	}
	--[[
	if infos.secretf == true then
		table.ForceInsert(endinformation, clang.lang_secret_found)
	else
		table.ForceInsert(endinformation, clang.lang_secret_nfound)
	end
	]]--
end)

net.Receive( "RolesSelected", function( len )
	drawinfodelete = CurTime() + 25
	shoulddrawinfo = true
end)

net.Receive( "PrepStart", function( len )
	cltime = net.ReadInt(8)
	chat.AddText(string.Replace( clang.preparing,  "{num}", cltime ))
	StartTime()
	drawendmsg = nil
	hook457delete = CurTime() + 0.5
	hook.Add("Tick", "Stop457Sounds", function()
		if hook457delete != nil then
			if hook457delete < CurTime() then
				hook457delete = nil
				hook.Remove("Tick", "Stop457Sounds")
			end
			if LocalPlayer():GetNClass() == ROLE_SCP457 then
				RunConsoleCommand("stopsound")
			end
		end
	end)
	timer.Destroy("SoundsOnRoundStart")
	timer.Create("SoundsOnRoundStart", 1, 1, SoundsOnRoundStart)
	timefromround = CurTime() + 10
	RADIO4SOUNDS = table.Copy(RADIO4SOUNDSHC)
	SAVEDIDS = {}
end)

net.Receive( "RoundStart", function( len )
	cltime = net.ReadInt(12)
	chat.AddText(clang.round)
	StartTime()
	drawendmsg = nil
end)

net.Receive( "PostStart", function( len )
	cltime = net.ReadInt(6)
	win = net.ReadInt(4)
	drawendmsg = win
	StartTime()
end)

hook.Add( "OnPlayerChat", "CheckChatFunctions", function( ply, strText, bTeam, bDead )
	strText = string.lower( strText )

	if ( (strText == "снять") or (strText == "dropvest") ) then
		if ply == LocalPlayer() then
			DropCurrentVest()
		end
		return true
	end

	if ( (strText == "эвакуация") or (strText == "escape") ) then
		if ply == LocalPlayer() then
			RunConsoleCommand("br_requestescort")
		end
		return true
	end

	if ( strText == "dropscp714" ) then
		if ply == LocalPlayer() then
			DropSCP714()
		end
		return true
	end

	if ( strText == "dropscp178" ) then
		if ply == LocalPlayer() then
			DropSCP178()
		end
		return true
	end

end)

// Blinking system

local brightness = 0
local f_fadein = 0.25
local f_fadeout = 0.000075 -- 0.000075


local f_end = 0
local f_started = false
function tick_flash()
	if LocalPlayer().GTeam == nil then return end
	/*
	if LocalPlayer():GTeam() != TEAM_SPEC then
		for k,v in pairs(ents.FindInSphere(OUTSIDESOUNDS, 300)) do
			if v == LocalPlayer() then
				StartOutisdeSounds()
			end
		end
	end
	*/
	if shoulddrawinfo then
		if CurTime() > drawinfodelete then
			shoulddrawinfo = false
			drawinfodelete = 0
		end
	end
	if f_started then
		if CurTime() > f_end then
			brightness = brightness + f_fadeout
			if brightness < 0 then
				f_end = 0
				brightness = 0
				f_started = false
			end
		else
			if brightness < 1 then
				brightness = brightness - f_fadein
			end
		end
	end
end
hook.Add( "Tick", "htickflash", tick_flash )

function CLTick()
	if postround == false and isnumber(drawendmsg) then
		drawendmsg = nil
	end
	if clang == nil then
		clang = english
	end
end
hook.Add( "Tick", "client_tick_hook", CLTick )

net.Receive("PlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
	-- Моргание
	BledLastBlink = CurTime()
end)

net.Receive("SlowPlayerBlink", function(len)
	local time = net.ReadFloat()
	Blink(time)
end)

function SlowFadeBlink(time)
	f_fadein = 0.0075
	f_fadeout = 0.0075
	f_started = true
	f_end = CurTime() + time
end

function Blink(time)
	f_fadein = 0.25
	f_fadeout = 0.000075
	f_started = true
	f_end = CurTime() + time
end

last996attack = 0

local mat_color = Material( "pp/colour" ) -- used outside of the hook for performance
hook.Add( "RenderScreenspaceEffects", "blinkeffects", function()
	local contrast = 1
	local colour = 1
	local nvgbrightness = 0
	local clr_r = 0
	local clr_g = 0
	local clr_b = 0
	local bloommul = 1.2
	last996attack = last996attack - 0.002
	if last996attack < 0 then
		last996attack = 0
	else
		DrawMotionBlur( 1 - last996attack, 1, 0.05 )
		DrawSharpen( last996attack,2 )
		contrast = last996attack
	end
	if IsValid(LocalPlayer():GetActiveWeapon()) then
		if LocalPlayer():GetActiveWeapon():GetClass() == "item_nvg" then
			nvgbrightness = 0.2
			DrawSobel( 0.7 )
		end
	end

	if livecolors then
		contrast = 1.1
		colour = 1.5
		bloommul = 2
	end
	if LocalPlayer():Health() < 30 and LocalPlayer():Alive() then
		colour = math.Clamp((LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 5, 0, 2)
		DrawMotionBlur( 0.27, 0.5, 0.01 )
		DrawSharpen( 1,2 )
		DrawToyTown( 3, ScrH() / 1.8 )
	end
	render.UpdateScreenEffectTexture()


	mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )

	mat_color:SetFloat( "$pp_colour_brightness", brightness + nvgbrightness )
	mat_color:SetFloat( "$pp_colour_contrast", contrast)
	mat_color:SetFloat( "$pp_colour_colour", colour )
	mat_color:SetFloat( "$pp_colour_mulr", clr_r )
	mat_color:SetFloat( "$pp_colour_mulg", clr_g )
	mat_color:SetFloat( "$pp_colour_mulb", clr_b )

	render.SetMaterial( mat_color )
	render.DrawScreenQuad()
	DrawBloom( 0.65, bloommul, 9, 9, 1, 1, 1, 1, 1 )
end )

local dropnext = 0
function GM:PlayerBindPress( ply, bind, pressed )
	if bind == "+menu" then
		if dropnext > CurTime() then return true end
		dropnext = CurTime() + 0.5
		net.Start("DropWeapon")
		net.SendToServer()
		if LocalPlayer().channel != nil then
			LocalPlayer().channel:EnableLooping( false )
			LocalPlayer().channel:Stop()
			LocalPlayer().channel = nil
		end
		return true
	elseif bind == "gm_showteam" then
		OpenClassMenu()
	elseif bind == "+menu_context" then
		thirdpersonenabled = !thirdpersonenabled
	end
end

concommand.Add("br_requestescort", function()
	if !(LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS or LocalPlayer():GTeam() == TEAM_SNEAK or LocalPlayer():GTeam() == TEAM_SPYHSS) then return end
	net.Start("RequestEscorting")
	net.SendToServer()
end)


concommand.Add("br_requestgatea", function()
	if !(LocalPlayer():GetNClass() == ROLES.ROLE_CHAOS or LocalPlayer():GetNClass() == ROLES.ROLE_MTFNTF) then return end
	if LocalPlayer():CLevelGlobal() < 4 then return end
	net.Start("RequestGateA")
	net.SendToServer()
end)

concommand.Add("br_sound_random", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_RandomMTF")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_GOK and LocalPlayer():Alive() then
		net.Start("Sound_RandomGOK")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_SNEAK and LocalPlayer():Alive() then
		net.Start("Sound_RandomHS")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_PSIXON and LocalPlayer():Alive() then
		net.Start("Sound_RandomPSI")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_searching", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_SearchingMTF")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_GOK and LocalPlayer():Alive() then
		net.Start("Sound_SearchingGOK")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_SNEAK and LocalPlayer():Alive() then
		net.Start("Sound_SearchingHS")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_PSIXON and LocalPlayer():Alive() then
		net.Start("Sound_SearchingPSI")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_classd", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_ClassdMTF")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_GOK and LocalPlayer():Alive() then
		net.Start("Sound_TargetonGOK")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_SNEAK and LocalPlayer():Alive() then
		net.Start("Sound_TargetonHS")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_PSIXON and LocalPlayer():Alive() then
		net.Start("Sound_TargetonPSI")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_stop", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_StopMTF")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_GOK and LocalPlayer():Alive() then
		net.Start("Sound_StopGOK")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_SNEAK and LocalPlayer():Alive() then
		net.Start("Sound_StopHS")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_PSIXON and LocalPlayer():Alive() then
		net.Start("Sound_StopPSI")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_lost", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_LostMTF")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_GOK and LocalPlayer():Alive() then
		net.Start("Sound_LostGOK")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_SNEAK and LocalPlayer():Alive() then
		net.Start("Sound_LostHS")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_PSIXON and LocalPlayer():Alive() then
		net.Start("Sound_LostPSI")
		net.SendToServer()
	end
end)

concommand.Add("br_sound_idcard", function()
	if (LocalPlayer():GTeam() == TEAM_GUARD or LocalPlayer():GTeam() == TEAM_CHAOS) and LocalPlayer():Alive() then
		net.Start("Sound_idMTF")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_GOK and LocalPlayer():Alive() then
		net.Start("Sound_idGOK")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_SNEAK and LocalPlayer():Alive() then
		net.Start("Sound_idHS")
		net.SendToServer()
	elseif LocalPlayer():GTeam() == TEAM_PSIXON and LocalPlayer():Alive() then
		net.Start("Sound_idPSI")
		net.SendToServer()
	end
end)

/*
function CalcView3DPerson( ply, pos, angles, fov )
	local view = {}
	view.origin = pos
	view.angles = angles
	view.fov = fov
	view.drawviewer = false
	if thirdpersonenabled then
		local eyepos = ply:EyePos()
		local eyeangles = ply:EyeAngles()
		local point = ply:GetEyeTrace().HitPos
		local goup = 2
		if ply:Crouching() then
			goup = 20
		end
		view.drawviewer = true
		view.origin = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 20)
		view.angles = (point - view.origin):Angle()
		local endps = eyepos + Vector(0,0,goup) - (eyeangles:Forward() * 30) + (eyeangles:Right() * 15)
		local tr = util.TraceLine( { start = eyepos, endpos = endps} )
		if tr.Hit then
			view.origin = tr.HitPos
		end
	end
	return view
end
hook.Add( "CalcView", "CalcView3DPerson", CalcView3DPerson )
*/
print("cl_init loads")


