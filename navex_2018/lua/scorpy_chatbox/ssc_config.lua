--[[
lua/scorpy_chatbox/ssc_config.lua
--]]

-----------------------------------------------------
--Copyright Phoenixf129 2013.
-- Модифицировано MR.REX'ом в 2017-2018 году

print("[SSC] Loading Config...")

SSC = SSC or {} -- For my sanity.

--Scorpys Simple Chatbox Configuration
SSC.LabelText = "NAVEX"
SSC.WebUrl = "https://vk.com/navex"
--SSC.DonateUrl = "https://vk.com/navex"

-- Images can be found here: 
-- http://www.glua.me/bin/?path=/materials/icon16

SSC.InfoIcon = "icon16/information.png" -- The Icon for Information messages.
SSC.ConsoleIcon = "icon16/application_xp_terminal.png" -- The Icon for Server Console messages.

-- True/False. False to see Avatar icons, True to see Rank icons.
SSC.RanksOverAvatars = false

-- Where the chatbox is on your screen.
SSC.ChatBoxPos = ScrH() - 180

-- True/False. False to disable PM system (/p name msg)
SSC.PMFunctionality = false

-- True/False. False to disable animated dropdown menu bar.
SSC.EnableDropDown = true

-- Fonts
SSC.Font_Message 	 = "DefaultBold" --hatFont
SSC.Font_ChatLabel	 = "DefaultBold"
SSC.Font_URL		 = "Default"


-- rank, icon. 
-- Should work with ALL Admin mods. Fallbacks to Player:IsAdmin() and Player:IsSuperAdmin() if no admin mod installed.
SSC.Ranks = {
	["root"]   = "icon16/shield_go.png",
	["superadmin"]  = "icon16/shield.png",
	["xdminx"]		= "icon16/star.png",
	["moderator"]	= "icon16/rainbow.png",
	["premium"] 		= "icon16/coins.png",
	["user"] 		= "icon16/user.png"
}
-- If you don't have an admin mod, OR one of your groups isn't set above, it will default to these listed below.
SSC.DefaultSuperAdminRankIcon = "icon16/shield.png"
SSC.DefaultAdminRankIcon = "icon16/star.png"
SSC.DefaultRankIcon = "icon16/user.png"

-- SKIN options
-- Only edit these if you know what you're doing!
SSC.BGColor = Color(0, 0, 0, 180)
SSC.OutlineColor = Color(0, 0, 0, 120)
SSC.FGColor = Color(255, 255, 255, 255)

SSC.OutlineGlow = 100

SSC.TextEntryTextColor = Color( 0, 0, 0, 255 )
SSC.TextEntryHighlightColor = Color( 0, 180, 255, 255 )
SSC.TextEntryCursorColor = Color( 0, 0, 0, 255 )

SSC.ChatTypeBGColor = Color(0,0,0,0)
SSC.ChatTypeColor = Color(255,0,0,0)

-- Button Configuration
SSC.Buttons = {}

-- name = The tooltip's title (mouseover to see tooltip)
-- icon = The icon you want to display
-- desc  = The tooltip's description (mouseover to see tooltip)
-- cmd   = The command to run when the button is clicked
-- To change these, just follow the format below.

-- Example Website button
SSC.Buttons[1] = {
   ["name"] = "Группа сервера",
   ["icon"] = "icon16/world_go.png",
   ["desc"]  = "",
   ["cmd"]   = "ssc_loadsite",
}

--Example Donate button
SSC.Buttons[2] = {
	["name"] = "MR.REX в Steam",
	["icon"] = "icon16/heart.png",
	["desc"] = "",
	["cmd"]  = "ssc_mrrexsteam",
}

--Example Pointshop button
--[[
SSC.Buttons[3] = {
	["name"] = "Navex Buy™",
	["icon"] = "icon16/emoticon_smile.png",
	["desc"] = "",
	["cmd"]  = "donate",
}
]]--

-- Commands for buttons

-- These are examples. You can add new/remove old if you wish, but remove the buttons too!
concommand.Add("ssc_loadsite", function()
	gui.OpenURL(SSC.WebUrl);
end)

concommand.Add("ssc_mrrexsteam", function()
	gui.OpenURL("http://steamcommunity.com/id/ImMrREX/");
end)
print("[SSC] Loading Complete!") --Debug for Auto-Refresh, which is now working.

