--[[
addons/breach_iv_motd/lua/autorun/iv_motd_client.lua
--]]
------------------------
--[[ NAVEX MOTD 2.0 ]]--
------------------------

if SERVER then return end

surface.CreateFont("NavexMOTDdef", {
	font = "DermaLarge",
	extended = false,
	size = 30,
  weight = 500
});

surface.CreateFont("_NavexMOTDdef", {
	font = "DermaLarge",
	extended = false,
	size = 30,
  weight = 1000
});

surface.CreateFont("_NavexMOTDdefA", {
	font = "DermaDefault",
	extended = false,
	size = 11,
});

local MOTD = {};

MOTD.Update = GetGlobalBool("NAVEX_MOTD_USEUPDATE", false);
MOTD.Version = "EXPERIMENTAL 1.25"

MOTD.Sizes = {
  [true] = {400, 600},
  [false] = {400, 420}
};
MOTD.Buttons = {
  {Text = "Контент сервера", TextLight = "Контент",  Icon = "navex_motd_20/vk.png", Func = function(Window) gui.OpenURL("https://steamcommunity.com/workshop/filedetails/?id=1532784195"); end, CI = Color(80, 117, 165, 75)},
  {Text = "Группа проекта Navex", TextLight = "Navex", Icon = "navex_motd_20/vk.png", Func = function(Window) gui.OpenURL("http://vk.com/navex"); end, CI = Color(80, 117, 165, 75)},
  {Text = "Правила сервера", TextLight = "Правила", Icon = "navex_motd_20/rules.png", Func = function(Window) gui.OpenURL("http://vk.com/topic-150054837_40571131"); end, CI = Color(237, 238, 240, 20)},
  {Text = "Закрыть", TextLight = "Закрыть", Icon = "navex_motd_20/close.png", Func = function(Window) Window:Close(); end, CI = Color(255, 0, 0, 20)}
};

function MOTD.Open(Player)  
  Window = vgui.Create("DFrame");
  Window:SetSize(MOTD.Sizes[MOTD.Update][1], MOTD.Sizes[MOTD.Update][2]);
  Window:Center();
  Window:SetDraggable(true);
  Window:SetTitle("");
  Window:ShowCloseButton(false);

  function Window:Paint(w, h)
    surface.SetDrawColor(255, 255, 255);
    surface.SetMaterial(Material("navex_motd_20/background.png"));
    surface.DrawTexturedRect(0, 0, 800, 600);

    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 240));

    surface.SetDrawColor(255, 255, 255);
    surface.SetMaterial(Material("navex_motd_20/logo.png"));
    surface.DrawTexturedRect(50, 0, 300, 140);

    draw.SimpleText(MOTD.Version, "DermaDefault", w/2, 110, Color(255,255,255,200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
  end

  if !MOTD.Update then
    for k, v in pairs(MOTD.Buttons) do
      local Button = vgui.Create("DButton", Window);
      Button:SetSize(380, 50);
      Button:SetPos(10, 88 + k*60);
      Button:SetText("");
      function Button:Paint(w, h)
        if v.Text == "Закрыть" then 
          draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 20)); 
        else
          draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 125)); end
        draw.RoundedBox(0, 0, 0, 50, 50, v.CI); 
        surface.SetDrawColor(255, 255, 255, 200);
        surface.DrawOutlinedRect(0, 0, w, h);
        surface.SetMaterial(Material(v.Icon));
        surface.DrawTexturedRect(9, 9, 32, 32);
        if v.Text == "Закрыть" then
          draw.SimpleText(v.Text, "_NavexMOTDdef", w/2, h/2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        else
          draw.SimpleText(v.Text, "NavexMOTDdef", 66, h/2, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        end

        if self:IsDown() then
          draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200));
        end
      end
      function Button:DoClick()
        v.Func(Window);
      end
    end
  else
    local PatchNote = vgui.Create("DHTML", Window);
    PatchNote:SetSize(380, 350);
    PatchNote:SetPos(10, 148);
    PatchNote:SetScrollbars(false);
    PatchNote:OpenURL("http://rex-interactive.ru/navex/patchnote");

    for k, v in pairs(MOTD.Buttons) do
      local Button = vgui.Create("DButton", Window);
      Button:SetSize(70, 64);
      Button:SetPos(32 + (k-1)*(64+25), 515);
      Button:SetText("");
      function Button:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, v.CI);
        surface.SetDrawColor(255, 255, 255, 200);
        surface.SetMaterial(Material(v.Icon));
        surface.DrawTexturedRect(w/2-16, h/2-25, 32, 32);
        if v.TextLight == "Navex Breach" then
          draw.SimpleText(v.TextLight, "_NavexMOTDdefA", w/2, h/2+21, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        else
          draw.SimpleText(v.TextLight, "DermaDefault", w/2, h/2+20, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        end

        if self:IsDown() then
          draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200));
        end
      end
      function Button:DoClick()
        v.Func(Window);
      end
    end
  end

  Window:MakePopup();
end

net.Receive("navex_motd", MOTD.Open);


