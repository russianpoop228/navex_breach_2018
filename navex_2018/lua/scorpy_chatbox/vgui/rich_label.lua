--[[
lua/scorpy_chatbox/vgui/rich_label.lua
--]]

-----------------------------------------------------
local PANEL = {}

AccessorFunc( PANEL, "Font", "Font" )
AccessorFunc( PANEL, "DefaultColor", "DefaultColor" )

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	self.Contents = {}
	self.Text = ""
	self.DefaultColor = Color(200,200,200,255)
	self.LastColor = self.DefaultColor
	
	function self:OnMouseWheeled(d) Chatbox.ScrollBar:SetScroll(Chatbox.ScrollBar:GetScroll() - d) end -- GriiM requested Scrollbar not jumping to top, so fixed!
	
end

function PANEL:OnMousePressed(num)
	if num == MOUSE_RIGHT then
		local menu = DermaMenu()
		menu:SetPos(gui.MouseX(), gui.MouseY())
		menu:AddOption("Копировать", function(me)
			SetClipboardText(self.Text or "nil")
		end)
	end
end

function PANEL:PerformLayout()
	surface.SetFont(self.Font)
	local x = 0
	local y = 0
	local w = self:GetWide()
	self.Lines = {}
	local curline = 1
	self.ContentsProc = table.Copy(self.Contents)
	
	for i, obj in ipairs(self.ContentsProc) do
		obj.Width, obj.Height = 0, 0
		if obj.Type == 0 then
			local fixtxt = string.gsub(obj.Text, "&", "#") --workaround for & having size 0.
			obj.Width, obj.Height = surface.GetTextSize(fixtxt)
			if x + obj.Width > w then
				curline = curline + 1
				x = 0
			end
			if obj.Width > w then
				local chars = string.ToTable(obj.Text)
				local nextw = 0
				obj.Text = ""
				obj.Width, obj.Height = surface.GetTextSize(obj.Text)
				while x + obj.Width + nextw < w and chars[1] != nil do
					obj.Text = obj.Text..chars[1]
					table.remove(chars, 1)
					local fixchar = string.gsub(chars[1], "&", "#")
					nextw = surface.GetTextSize(fixchar)
					fixtxt = string.gsub(obj.Text, "&", "#")
					obj.Width, obj.Height = surface.GetTextSize(fixtxt)
				end
				table.insert( self.ContentsProc, i+1, {Type = 0, Text = table.concat(chars)} )
			end
		elseif obj.Type == 1 then
			if x != 0 then
				curline = curline + 1
				x = 0
			end
		elseif obj.Type == 2 then
			local SpaceSize = surface.GetTextSize(obj.Space)
			local sleft = w-x
			if sleft < SpaceSize then
				curline = curline + 1
				x = SpaceSize - sleft
			else
				x = x + SpaceSize
			end
		elseif obj.Type == 4 then
			obj.Width, obj.Height = obj.Panel:GetSize()
			if x + obj.Width > w and x != 0 then
				curline = curline + 1
				x = 0
			end
		end
		obj.PosX = x
		x = x + obj.Width
		self.Lines[curline] = self.Lines[curline] or {}
		self.Lines[curline].objects = self.Lines[curline].objects or {}
		table.insert(self.Lines[curline].objects, obj)
		self.Lines[curline].Height = math.Max((self.Lines[curline].Height or 0), obj.Height)
	end
	
	if self.Lines[1] then
		for i = 1, #self.Lines do
			y = y + self.Lines[i].Height or 0
			local objs = self.Lines[i].objects
			for j = 1, #objs do
				objs[j].PosY = y - objs[j].Height
				if objs[j].Type == 4 then
					objs[j].Panel:SetPos(objs[j].PosX, objs[j].PosY)
				end
			end
		end
	end
	
	self:SetTall(y)
end

function PANEL:Paint()
	surface.SetFont(self.Font)
	surface.SetTextColor(self.DefaultColor.r, self.DefaultColor.g, self.DefaultColor.b, self.DefaultColor.a)
	
	for i = 1, #self.ContentsProc do
		local obj = self.ContentsProc[i]
		if obj.Type == 0 then
			surface.SetTextPos(obj.PosX, obj.PosY)
			surface.DrawText(obj.Text)
		elseif obj.Type == 3 then
			surface.SetTextColor(obj.Color.r, obj.Color.g, obj.Color.b, obj.Color.a)
		end
	end
end

function PANEL:AddText(text)
	self.Text = self.Text.. text
	text = string.gsub(text, "\t", "   ")
	
	for space_before, word, space_after in string.gmatch(text, "([\n%s]*)([^\n%s]*)([\n%s]*)") do
		if space_before != "" then
			if string.match(space_before, "\n") then
				table.insert( self.Contents, {Type = 1} )
			else
				table.insert( self.Contents, {Type = 2, Space = space_before} )
			end
		end
		if word != "" then
			table.insert( self.Contents, {Type = 0, Text = word} )
		end
		if space_after != "" then
			if string.match(space_after, "\n") then
				table.insert( self.Contents, {Type = 1} )
			else
				table.insert( self.Contents, {Type = 2, Space = space_after} )
			end
		end
	end
end

function PANEL:AddColor(color)
	table.insert( self.Contents, {Type = 3, Color = color} )
	self.LastColor = color
end

function PANEL:AddPlayer(ply)
	local lastcolor = self.LastColor

	local date_table = os.date("*t");
	local hour, minute, second = date_table.hour, date_table.min, date_table.sec;
	local result = string.format("%d:%d:%d", hour, minute, second)

	self:AddColor(Color(145, 179, 242));
	self:AddText("(" .. result .. ") ");

	if (ply:SteamID64() == "76561198084777060") then 
		self:AddColor(Color(255, 36, 0));
	elseif (ply:SteamID64() == "76561198129383305") then
		self:AddColor(Color(0, 121, 219));
	else
		self:AddColor(lastcolor or team.GetColor(ply:Team()));
	end

	self:AddText(ply:Name());

	--if (ply:SteamID64() == "76561198084777060") then 
		--self:AddColor(Color(255, 78, 51));
	--else
	self:AddColor(lastcolor);
	--end
end

vgui.Register( "RichLabel", PANEL, "EditablePanel" )

