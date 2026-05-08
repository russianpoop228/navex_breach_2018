--[[
lua/scorpy_chatbox/sh_init.lua
--]]

-----------------------------------------------------
print("[SSC] Loading init...")
SSC = SSC or {};

if SERVER then

	AddCSLuaFile("autorun/scorpy_chatbox.lua")
	AddCSLuaFile("scorpy_chatbox/ssc_config.lua")
	AddCSLuaFile("scorpy_chatbox/sh_init.lua")
	AddCSLuaFile("scorpy_chatbox/skin.lua")
	AddCSLuaFile("scorpy_chatbox/vgui/rich_label.lua")
	AddCSLuaFile("scorpy_chatbox/vgui/scorpy_chatbox_panels.lua")

	function SSC.GetPlayerByName(name)
		name = string.lower(name);
		for _,v in ipairs(player.GetHumans()) do
			if(string.find(string.lower(v:Name()),name,1,true) != nil)
				then return v;
			end
		end
	end
	
	gameevent.Listen( "player_connect" )
	hook.Add( "player_connect", "SSC_PrintConnect", function( data )
		for k,v in pairs( player.GetAll() ) do
			v:NavexForceChatPrint( data.name .. " вошел на проект." )
		end
	end )
	
	gameevent.Listen( "player_disconnect" )
	hook.Add( "player_disconnect", "SSC_PrintLeave", function( data )
		for k,v in pairs( player.GetAll() ) do
			v:NavexForceChatPrint( data.name .. " вышел с проекта." )
		end
	end )
	
	--[[ hook.Add("PlayerSay", "SSC - PM", function(ply, msg)
		if (string.sub(msg, 1,2) == "/p") then
			msg = string.gsub(msg, "/p ", "", 1)
			-- I blame garry for this.
			ply:ConCommand("ssc_pm "..msg)
			return ""
		end
	end)
	
	-- console functionality for server console-and idiots who want to pm through console also.
	function SSC.SendPM(ply, cmd, args)
		--if !SSC.PMFunctionality then return end
		
		local target = SSC.GetPlayerByName(args[1])
		
		local msg = table.concat(args, " ", 2)
		
		if target then
			local rp = RecipientFilter()
			rp:AddPlayer(ply)
			rp:AddPlayer(target)
						
			umsg.Start("SSC - PM", rp)
				umsg.Entity(ply)
				umsg.Entity(target)
				umsg.String(msg)
			umsg.End()		
		end
	end
	concommand.Add("ssc_pm", SSC.SendPM) ]]--
	
	local meta = FindMetaTable("Player") 
	util.AddNetworkString("PrintDatMessage")

	function meta:ChatPrint( Text )
		--MsgN( Text ) -- Send Standard Message
		if Text then
			net.Start("PrintDatMessage")
				net.WriteString(Text)
			net.Send(self)
		end
	end
	
	function meta:NavexForceChatPrint(Text)
		net.Start("PrintDatMessage");
		net.WriteString(Text);
		net.Send(self);
	end

	meta.oPrintMessage = meta.PrintMessage
	function meta:oPrintMessage( isTypeOfMessage, Text )
		if (isTypeOfMessage == HUD_PRINTTALK) then 
			net.Start("PrintDatMessage")
			net.WriteString(Text)
			net.Send(self)
		else
			--net.Start("PrintDatMessage")
			--net.WriteString(Text)
			--net.Send(self)
			self:PrintMessage(isTypeOfMessage, Text);
		end 
	end

	function meta:ScreenText( Text )
		--MsgN( Text ) -- Send Standard Message
		if Text then
			net.Start("PrintDatMessage")
				net.WriteString(Text)
			net.Send(self)
		end
	end

	
	return
end

--Start Clientside

include("scorpy_chatbox/ssc_config.lua")
include("scorpy_chatbox/skin.lua")
include("scorpy_chatbox/vgui/rich_label.lua")
include("scorpy_chatbox/vgui/scorpy_chatbox_panels.lua")

--local Chatbox

local meta = FindMetaTable( "Player" ) function meta:ChatPrint( str) return self:PrintMessage( HUD_PRINTTALK, str ) end

SSC.Chatbox = Chatbox

surface.CreateFont( "DefaultBold", { -- Fix for DefaultBold missing font. 
        font = "Arial",
        size = 16,
        weight = 1000,
        antialias = true,
        additive = false
} )

surface.CreateFont( "SSCBold", { -- Fix for DefaultBold missing font. 
        font = "Calibri", --Tahoma
        size = 18,
        weight = 1000,
        antialias = true,
        additive = false
} )

hook.Add("InitPostEntity", "Scorpy's Simple Chatbox - Init", function() 
	Chatbox = vgui.Create("ScorpyChatbox")
end)

local oldChatAddText = chat.AddText
function chat.AddText(...)
	oldChatAddText(...)
	
	Chatbox = Chatbox or vgui.Create("ScorpyChatbox")
	Chatbox:AddMessage({...})
end

net.Receive("PrintDatMessage", function( len )
	local stuff = net.ReadString()
	chat.AddText( stuff )
end)

hook.Add("HUDShouldDraw", "Scorpy's Simple Chatbox - Hide Default", function(name)
	if name=="CHudChat" then
		return false
	end
end)

hook.Add("StartChat", "Scorpy's Simple Chatbox - StartTyping", function( team_chat )
	LocalPlayer().TypingInChat = true
end)

hook.Add("FinishChat", "Scorpy's Simple Chatbox - FinishTyping", function( team_chat )
	LocalPlayer().TypingInChat = false
end)

hook.Add("PlayerBindPress", "Scorpy's Simple Chatbox - Open", function(ply, bind, pressed)
	if string.find(bind, "messagemode2") then
		Chatbox:Open(true)
		return true
	elseif string.find(bind, "messagemode") then
		Chatbox:Open(false)
		return true
	end
end)

--[[ usermessage.Hook("SSC - PM", function(um)
	local ply = um:ReadEntity()
	local target = um:ReadEntity()
	local text = um:ReadString()
	local tab = {}
	
	table.insert( tab, Color( 0, 200, 200 ) )
	table.insert( tab, "(PM" )
	if target != LocalPlayer() then
		table.insert( tab, " to "..target:Name() )
	end
	table.insert( tab, ") " )
	
	table.insert( tab, ply )
	
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..text )
	
	chat.AddText( unpack(tab) )
end) ]]--

