--[[
lua/scorpy_chatbox/vgui/scorpy_chatbox_panels.lua
--]]

-----------------------------------------------------
SSC = SSC or {};
SSC.Tabs = {};
local MESSAGE_PANEL = {}
local meta = FindMetaTable( "Player" ) function meta:ChatPrint( str) return self:PrintMessage( HUD_PRINTTALK, str ) end

function MESSAGE_PANEL:Init()
	self.NrLines = 0
	
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self.TextPanel = vgui.Create("RichLabel", self)
	self.TextPanel:SetFont(SSC.Font_Message)
	self.TextPanel:SetDefaultColor(Color(220,220,220))
	
	self.Icon = vgui.Create("DImage", self)
	self.Icon:SetSize(16, 16)
end

function MESSAGE_PANEL:PerformLayout()
	self.Icon:SetPos(30 - self.Icon:GetWide(), 1)
		
	self.TextPanel:SetWidth(self:GetWide() - 30 - 10)
	self.TextPanel:SetPos(30 + 5, 0)
	self.TextPanel:InvalidateLayout(true)
	self.NrLines = #self.TextPanel.Lines

	self:SetTall( math.Max( self.Icon:GetTall(), self.TextPanel:GetTall() ) )
	self.TextPanel:CenterVertical()
end

function MESSAGE_PANEL:Show()
	self.Hidden = false
	self:SetVisible(true)
end

function MESSAGE_PANEL:Hide()
	self.Hidden = true
	timer.Simple(0.30, function()
		if self.Hidden then
			self:SetVisible(false)
		end
	end)
end

function MESSAGE_PANEL:MoveToS(x, y)
	if self.TargetX != x or self.TargetY != y then
		self:MoveTo(x, y, 0.25 )
	end
	self.TargetX, self.TargetY = x, y
end

function MESSAGE_PANEL:SetMessage(contents, icon)
	local isRex = false;
	local isJasque = false;

	for _,item in ipairs(contents) do
		if (type(item) == "Player") and (item:SteamID64() == "76561198084777060") then 
			self.TextPanel:AddColor(Color(255, 78, 51)); 
			isRex = true;
		end
		if (type(item) == "Player") and (item:SteamID64() == "76561198129383305") then 
			self.TextPanel:AddColor(Color(66, 170, 255)); 
			isJasque = true;
		end

		if type(item) == "string" then
			--self.TextPanel:AddColor(Color(100, 149, 237));
			self.TextPanel:AddText(item)
		elseif type(item) == "table" then
			if ((isRex == false) and (isJasque == false)) then
				self.TextPanel:AddColor(item);
			end
		elseif type(item) == "Player" then
			self.TextPanel:AddPlayer(item)
			icon = icon or item
		end
	end
	
	if not icon then
		local match
		for _, ply in pairs( player.GetAll() ) do
			local name = ply:Name()
			if string.find(self.TextPanel.Text, name..": ", 1, true) then
				if not match or match:len() < name:len() then
					match = name
					icon = ply
				end
			end
		end
		if not match then
			if string.find(self.TextPanel.Text, "Console: ", 1, true) then
				icon = SSC.ConsoleIcon
			end
		end
	end
	
	if type(icon) == "Player" then
		if !SSC.RanksOverAvatars then
			self.Icon.Avatar = vgui.Create("AvatarImage", self.Icon)
			self.Icon.Avatar:SetPlayer(icon)
			self.Icon.Avatar:SetSize(16,16)
			icon = "icon16/user.png"
		else
			
			for group, ricon in pairs(SSC.Ranks) do
				if icon:IsUserGroup(group) then
					icon = ricon
					break
				end
			end
			
			if type(icon) == "Player" then  -- If the system has already got the rank from that player, we need go no further here.
				-- Default GMod Admin system support
				if icon:IsSuperAdmin() then
					icon = SSC.DefaultSuperAdminRankIcon
				elseif icon:IsAdmin() then
					icon = SSC.DefaultAdminRankIcon
				else
					icon = SSC.DefaultRankIcon
				end
			end
		end
	end
	
	icon = icon or SSC.InfoIcon
	
	self.Icon:SetImage(icon)
end

local MessagePanel = vgui.RegisterTable(MESSAGE_PANEL, "Panel")

SSC_TextEntry_Panel = {}

function SSC_TextEntry_Panel:Init()
	self:SetAllowNonAsciiCharacters(true)
	self.m_bLoseFocusOnClickAway = false
	self.History = {}
	self.HistoryNum = 1	
end

function SSC_TextEntry_Panel:Paint() derma.SkinHook( "Paint", "TextEntry", self ) end

function SSC_TextEntry_Panel:OnTextChanged()
	gamemode.Call( "ChatTextChanged", self:GetValue() )
end

function SSC_TextEntry_Panel:AllowInput()
	if string.len(self:GetValue()) >= 126 then
		surface.PlaySound("Resource/warning.wav")
		return true
	end
end

function SSC_TextEntry_Panel:OnLoseFocus() -- Support for pressing tab to autofill names, loses focus; so lets give it focus again!
	if input.IsKeyDown( KEY_TAB ) then
		self:RequestFocus()
		
		local text = hook.Call("OnChatTab", GAMEMODE, self:GetValue() or "")
		if text then
			self:SetText( text )
		end
		self:SetCaretPos( #self:GetText() )
	end
end

-- NAVEX ЦЕНЗУРА
function navex_censore( msg )
	--[[
	local bad_words = {
						"Novux", "Novus",
						"Nexusrp", "Nextoren",
						"Nexus", "NexusRP",
						"nexus", "nexusrp", "нексус",
						"nextoren", "некст", "некс", "нексторен",
						"novux", "novus", "новукс", "новус",
					  };
	local word = "";
	local censored = "███████"
	
	for w in string.gmatch(msg, "%S+") do
		for id = 1, #bad_words do
			w = string.lower(w);
			if w == bad_words[id] then
				--print("Navex Anti-Pidor: " .. w)
				msg = string.gsub(msg, bad_words[id], censored);
			end
		end
	end
	]]--
	return msg;
end
-- NAVEX ЦЕНЗУРА

function SSC_TextEntry_Panel:OnKeyCodeTyped( code )
	local chatbox = self:GetParent()
	local text = self:GetText()

	if code == KEY_UP then
		if #self.History == 0 then return end
		
		self.HistoryNum = self.HistoryNum + 1
		
		if self.HistoryNum > #self.History then self.HistoryNum = 1 end
		
		self:SetText(self.History[self.HistoryNum])
		
		self:SetCaretPos( #self:GetValue() )
		
		return
	end
		
	if code == KEY_DOWN then
		if #self.History == 0 then return end
		
		self.HistoryNum = self.HistoryNum - 1
		
		if self.HistoryNum < 1 then self.HistoryNum = 1 end
		
		self:SetText(self.History[self.HistoryNum])
		
		self:SetCaretPos( #self:GetValue() )
		
		return
	end

	if code == KEY_ENTER then
		if string.Trim(text) != "" then
			local match = string.match(text, "^!%s*(.+)$")
			if chatbox.TeamChat then
				RunConsoleCommand("say", text)
			else
				RunConsoleCommand("say", text) -- ВОТ ОНА, РЫБА МОЕЙ МЕЧТЫ
			end
			
			table.insert(self.History, text)		
		end

		chatbox:Close()
	elseif code == KEY_ESCAPE then
		chatbox:Close()
		timer.Simple(0, function() RunConsoleCommand("cancelselect") end)
	end
end

local ChatboxTextEntry = vgui.RegisterTable(SSC_TextEntry_Panel, "DTextEntry")

SSC_Chatbox_Panel = {}

function SSC_Chatbox_Panel:Init()
	self.IsOpen = false
	self.TeamChat = false
	self.FirstOpen = true
	self.Messages = {}
	self.Lines = {}
	self.RecentMessages = {}
	self.ButtonsList = {}
	self.ShowLines = 10
	
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	self:DockPadding(8, 8, 8, 8)
	self:SetSize(500, 32)
	self.x = -self:GetWide()
	
	self.ChatTypeLabel = vgui.Create("DLabel", self)
	self.ChatTypeLabel:SetTextColor(SSC.LabelColors)
	self.ChatTypeLabel:SetFont(SSC.Font_ChatLabel)
	self.ChatTypeLabel:Dock(LEFT)
	self.ChatTypeLabel:DockMargin(0, 0, 4, 0)
	function self.ChatTypeLabel:Paint() derma.SkinHook( "Paint", "ChatTypeLabel", self ) end

	self.TextEntry = vgui.CreateFromTable(ChatboxTextEntry, self)
	self.TextEntry:SetHistoryEnabled(true)
	self.TextEntry:Dock(FILL)
	
	self.ScrollBar = vgui.Create( "DVScrollBar" )
	function self.ScrollBar.GetParent() return self end
	function self.ScrollBar:OnMouseWheeled(d) self:SetScroll(self:GetScroll() - d) end -- GriiM requested Scrollbar not jumping to top, so fixed!
	function self.ScrollBar.btnUp:DoClick() self:GetParent():SetScroll(self:GetParent():GetScroll() - 1) end
	function self.ScrollBar.btnDown:DoClick() self:GetParent():SetScroll(self:GetParent():GetScroll() + 1) end

	self.SSCDropdown = vgui.Create("Panel")
	self.SSCDropdown:SetVisible(false)
	self.SSCDropdown:DockPadding(8, 4, 8, 4)
	function self.SSCDropdown:Paint() derma.SkinHook( "Paint", "SSCDropdown", self ) end
	
	self.SSC_URL = vgui.Create("DLabel", self.SSCDropdown)
	self.SSC_URL:SetTextColor(SSC.LabelColors)
	self.SSC_URL:SetFont(SSC.Font_URL)
	self.SSC_URL:SetText(SSC.LabelText)
	self.SSC_URL:SizeToContentsX()
	self.SSC_URL:Dock(LEFT)
end

function SSC_Chatbox_Panel:Paint() derma.SkinHook( "Paint", "InputPanel", self ) end

function SSC_Chatbox_Panel:PerformLayout()
	self.y = SSC.ChatBoxPos - self:GetTall() - self.SSCDropdown:GetTall()
	
	self.ScrollBar:SetSize(16, self.ShowLines*draw.GetFontHeight(SSC.Font_Message))
	self.ScrollBar:SetPos( self:GetWide() - 16, self.y - 16 - self.ScrollBar:GetTall() )
	self.ScrollBar:SetUp( self.ShowLines, #self.Lines )
	
	self.SSCDropdown:SetSize(self:GetWide() - 40, 24)
	self.SSCDropdown:SetPos(20, self.IsOpen and self.y + self:GetTall() or self.y)
end

function SSC_Chatbox_Panel:OnVScroll()
	self:SetRecentMessages()
end

function SSC_Chatbox_Panel:OnScrollbarAppear()
	if not self.IsOpen then
		self.ScrollBar:SetAlpha(0)
	end
end

function SSC_Chatbox_Panel:Open(team_chat)
	if self.IsOpen then return end
	self.IsOpen = true
	gamemode.Call("StartChat")
	
	self.TeamChat = team_chat
	self.ChatTypeLabel:SetText(team_chat and "Чат:" or "Чат:")
	self.ChatTypeLabel:SizeToContentsX()
	self:InvalidateLayout(true)
	
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:MakePopup()
	self.TextEntry:RequestFocus()
	
	if self.FirstOpen then
		self:SetSkin("ScorpyChatbox")
		self.SSCDropdown:SetSkin("ScorpyChatbox")
		self.ScrollBar:SetSkin("ScorpyChatbox")
		
		self:AddSSCButtons()
		
		self.FirstOpen = false
	end
	
	for _,btn in pairs(self.ButtonsList) do
		btn:SetVisible(true)
	end
	self.SSCDropdown:InvalidateLayout(true)
	
	self:SetRecentMessages()
	
	self:MoveTo( 0, self.y, 0.25, 0, 1)
	timer.Simple(0.30, function()
		if self.IsOpen then
			if SSC.EnableDropDown then
				self.SSCDropdown:SetVisible(true)
				self.SSCDropdown:MoveTo( self.SSCDropdown.x, self.y + self:GetTall(), 0.25)
			end
			self.ScrollBar:AlphaTo(255, 0.25)
		end
	end)
end

function SSC_Chatbox_Panel:Close()
	if not self.IsOpen then return end
	self.IsOpen = false
	gamemode.Call("FinishChat")
	
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	self.TextEntry:SetText("")
	gamemode.Call( "ChatTextChanged", "" )
	
	self.ScrollBar:SetScroll(self.ScrollBar.CanvasSize)
	self:SetRecentMessages()
	
	self.ScrollBar:AlphaTo(0, 0.25)
	self.SSCDropdown:MoveTo( self.SSCDropdown.x, self.y, 0.25, 0, 1)
	timer.Simple(0.30, function()
		if not self.IsOpen then
			self.SSCDropdown:SetVisible(false)
			self:MoveTo( -self:GetWide(), self.y, 0.25)
		end
	end)
end

function SSC_Chatbox_Panel:AddMessage(contents, icon)
	local msg = vgui.CreateFromTable(MessagePanel)
	msg:SetMessage(contents, icon)
	msg:SetWidth(self:GetWide() - 16)
	msg:InvalidateLayout(true)
	msg:SetPos(0, self.y)
		
	local index = table.insert(self.Messages, msg)
	
	for i = 1, msg.NrLines do
		table.insert(self.Lines, index)
	end
	
	self.ScrollBar:SetUp( self.ShowLines, #self.Lines )
	
	if not self.IsOpen or self.CurrentMessage == #self.Messages - 1 then
		self.ScrollBar:SetScroll(self.ScrollBar.CanvasSize)
		self:SetRecentMessages()
	end
			
	timer.Simple(10, function()
		msg.Expired = true
		if not self.IsOpen then
			msg:Hide()
			msg:MoveToS(-msg:GetWide(), msg.TargetY)
		end
	end)
	
	chat.PlaySound()
	--surface.PlaySound("stalker_rp/pda/pda_tip.wav")
end

function SSC_Chatbox_Panel:SetRecentMessages()
	local offset_line = math.floor(self.ScrollBar:GetScroll()) + math.Min(self.ShowLines, #self.Lines)
	local i = self.Lines[offset_line]
	if not i then return end
	self.CurrentMessage = i
	
	local new_recent_messages = {}
	local y = self.y - 16
	local nr_lines = 0
	while nr_lines < self.ShowLines and i >= 1 do
		local msg = self.Messages[i]
		nr_lines = nr_lines + msg.NrLines
		y = y - msg:GetTall()
		if self.IsOpen or not msg.Expired then
			msg:Show()
		else
			msg:Hide()
		end
		msg:MoveToS(msg.Hidden and -msg:GetWide() or 0, y)
		table.insert(new_recent_messages, msg)
		i = i - 1
	end
	
	for _, msg in pairs(self.RecentMessages) do
		if not table.HasValue(new_recent_messages, msg) then
			msg:MoveToS(-msg:GetWide(), msg.TargetY)
			msg:Hide()
		end
	end
	
	self.RecentMessages = new_recent_messages
end

function SSC_Chatbox_Panel:AddSSCButtons()
	for k, v in pairs(SSC.Buttons) do
		local btn = vgui.Create("DImageButton", self.SSCDropdown)
		btn:SetSize(16,16)
		btn:SetImage(v["icon"])
		btn:SetTooltip(v["name"])
		if v["desc"] and v["desc"] !="" then
			btn:SetTooltip(v["name"].." - "..v["desc"])
		end
		btn.Name = v["name"]
		btn.Command = v["cmd"]
		function btn.DoClick(btn)
			LocalPlayer():ConCommand(btn.Command)
			self:Close()
		end
		btn:DockMargin(2,0,0,0)
		btn:Dock(RIGHT)
		table.insert(self.ButtonsList, btn)
	end
end

ScorpyChatbox = vgui.Register( "ScorpyChatbox", SSC_Chatbox_Panel, "EditablePanel")

