--[[
lua/scorpy_chatbox/skin.lua
--]]

-----------------------------------------------------
local SKIN = {}

SKIN.PrintName 		= "Scorpy's Simple Chatbox Skin"
SKIN.Author 		= "Phoenixf129 previously Scorpius289 (Azura Meta)"
SKIN.DermaVersion	= 1

function SKIN:PaintInputPanel(panel)
	local outline = 3
	draw.RoundedBoxEx( 0, 0, 0, panel:GetWide(), panel:GetTall(), SSC.OutlineColor, false, true, false, true )
	draw.RoundedBoxEx( 0, 0, outline, panel:GetWide() - outline, panel:GetTall() - outline*2, SSC.BGColor, false, true, false, true )
end

function SKIN:PaintTextEntry(panel)
	draw.RoundedBoxEx( 2, 0, 0, panel:GetWide(), panel:GetTall(), SSC.FGColor, false, true, false, true )

	panel:DrawTextEntryText( SSC.TextEntryTextColor, SSC.TextEntryHighlightColor, SSC.TextEntryCursorColor )
end

function SKIN:PaintVScrollBar( panel ) end

function SKIN:PaintSysButton( panel )
	local outline = 2
	draw.RoundedBoxEx( 4, 0, 0, panel:GetWide(), panel:GetTall(), SSC.OutlineColor, false, false, false, false )
	draw.RoundedBoxEx( 4, outline, outline, panel:GetWide() - outline*2, panel:GetTall() - outline*2, SSC.BGColor, false, false, false, false )
end

function SKIN:PaintScrollBarGrip( panel )
	local outline = 2
	draw.RoundedBoxEx( 4, 0, 0, panel:GetWide(), panel:GetTall(), SSC.OutlineColor, false, false, false, false )
	draw.RoundedBoxEx( 4, outline, outline, panel:GetWide() - outline*2, panel:GetTall() - outline*2, SSC.BGColor, false, false, false, false )
end

function SKIN:PaintSSCDropdown(panel)
	local outline = 2
	draw.RoundedBoxEx( 0, 0, 0, panel:GetWide(), panel:GetTall(), SSC.OutlineColor, false, false, true, true )
	draw.RoundedBoxEx( 0, outline, 0, panel:GetWide() - outline*2, panel:GetTall() - outline, SSC.BGColor, false, false, true, true )
end

function SKIN:PaintChatTypeLabel(panel)
	local outline = 0
	draw.RoundedBoxEx( 4, 0, 0, panel:GetWide(), panel:GetTall(), SSC.ChatTypeBGColor, false, false, true, true )
	draw.RoundedBoxEx( 4, outline, 0, panel:GetWide() - outline*2, panel:GetTall() - outline, SSC.ChatTypeColor, false, false, true, true )
end

derma.DefineSkin( "ScorpyChatbox", "Scorpy's Simple Chatbox - Skin", SKIN )

