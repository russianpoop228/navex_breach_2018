--[[
lua/autorun/viewbump.lua
--]]
--MIT License
--
--Copyright (c) 2018 xDShot xdshot9000@gmail.com
--
--Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- Runs only on client
if not CLIENT then return end

-- Convenient function to declare cvar
local function declarecvar( cvarname, helptext, defaultvalue )
	defaultvalue = defaultvalue or 1
	helptext = helptext or nil
	return CreateClientConVar( cvarname, defaultvalue, true, false, helptext )
end

-- Cvars declarations. We declare as well their descriptions and default values to re-use them later for menu
--local vbump_blah = declarecvar( "vbump_blah", "blahblahblah", 1 )
local vbump_enable_desc = "Enable view model bump near walls facing to?"
local vbump_enable_def = 1
local vbump_enable = declarecvar( "vbump_enable", vbump_enable_desc, vbump_enable_def )
local vbump_bumpsound_desc = "Enable bump sound? Only you can hear it."
local vbump_bumpsound_def = 0
local vbump_bumpsound = declarecvar( "vbump_bumpsound", vbump_bumpsound_desc, vbump_bumpsound_def )
local vbump_maxdist_desc = "Distance to wall on where weapon starts colliding"
local vbump_maxdist_def = 32
local vbump_maxdist = declarecvar( "vbump_maxdist", vbump_maxdist_desc, vbump_maxdist_def )
local vbump_mindist_desc = "Distance to wall on where weapon stops moving backward on colliding"
local vbump_mindist_def = 16
local vbump_mindist = declarecvar( "vbump_mindist", vbump_mindist_desc, vbump_mindist_def )
local vbump_minvel_desc = "Minimal player move speed to trigger bump sound"
local vbump_minvel_def = 220
local vbump_minvel = declarecvar( "vbump_minvel", vbump_minvel_desc, vbump_minvel_def )
local vbump_mindelta_desc = "Minimal player angular view speed to trigger bump sound"
local vbump_mindelta_def = 2
local vbump_mindelta = declarecvar( "vbump_mindelta", vbump_mindelta_desc, vbump_mindelta_def )
local vbump_movedist_desc = "Maximal distance view model moves backward"
local vbump_movedist_def = 16
local vbump_movedist = declarecvar( "vbump_movedist", vbump_movedist_desc, vbump_movedist_def )
local vbump_bumpratein_desc = "How fast weapon moves when distance to wall is decreased"
local vbump_bumpratein_def = 0.1
local vbump_bumpratein = declarecvar( "vbump_bumpratein", vbump_bumpratein_desc, vbump_bumpratein_def )
local vbump_bumprateout_desc = "How fast weapon moves when distance to wall is increased or stopped colliding"
local vbump_bumprateout_def = 0.03
local vbump_bumprateout = declarecvar( "vbump_bumprateout", vbump_bumprateout_desc, vbump_bumprateout_def )
local vbump_bumpsounddelay_desc = "Delay when bump sound can be played again after when stopped colliding"
local vbump_bumpsounddelay_def = 2
local vbump_bumpsounddelay = declarecvar( "vbump_bumpsounddelay", vbump_bumpsounddelay_desc, vbump_bumpsounddelay_def )

-- We store some important values globally. Do you know a better way?
VBUMP_scale = VBUMP_scale or 0 -- for scale interpolating
VBUMP_lastbump = VBUMP_lastbump or 0 -- Last time we bumped
VBUMP_prevAng = VBUMP_prevAng or Angle() -- Previous view angle value for calculating delta

-- This sound is played on bump
local bumpsound = "weapon.ImpactSoft"

-- This won't work for these weapons
local restrictedweapons = {}
restrictedweapons["weapon_empty_hands"] = true
restrictedweapons["gmod_camera"] = true

-- Bump sound wont play for these
local dontbump = {}
dontbump["weapon_fists"] = true
dontbump["weapon_doom3_fists"] = true

-- Here goes our magic
local function CalcViewModelView( wep, vm, oldPos, oldAng, pos, ang )

	-- Do nothing if disabled
	if not cvars.Bool( "vbump_enable", true ) then return end

	-- We need a player for this
	local ply = LocalPlayer()
	-- If failed to allocate player, do nothing
	if not IsValid(ply) then
		print( "ViewmodelBump", "LocalPlayer() fail!" )
		return
	end
	-- If failed to allocate weapon or it's blacklisted, do nothing
	if not IsValid(wep) or restrictedweapons[wep.ClassName] then
		return
	end
	
	-- Firstly do all view calculations if weapon has them overridden
	if wep.GetViewModelPosition then
		local weppos, wepang = wep.GetViewModelPosition( wep, pos*1, ang*1 )
		pos = weppos or pos
		ang = wepang or ang
	end
	
	if wep.CalcViewModelView then
		local weppos, wepang = wep.CalcViewModelView( wep, vm, oldPos*1, oldAng*1, pos*1, ang*1 )
		pos = weppos or pos
		ang = wepang or ang
	end
	
	-- Grab values
	--local blah = cvars.Number( "vbump_blah", 1 )
	--local blah = math.max( cvars.Number( "vbump_blah", 1 ), 0.01 )
	local maxdist = math.max( cvars.Number( "vbump_maxdist", vbump_maxdist_def ), 0.01 )
	local mindist = math.Clamp( cvars.Number( "vbump_mindist", vbump_mindist_def ), 0.01, maxdist-0.01 )
	local minvel = cvars.Number( "vbump_minvel", vbump_minvel_def )
	local mindelta = cvars.Number( "vbump_minvel", vbump_mindelta_def )
	local movedist = cvars.Number( "vbump_movedist", vbump_movedist_def )
	local bumpratein = math.max( cvars.Number( "vbump_bumpratein", vbump_bumpratein_def ), 0.01 )
	local bumprateout = math.max( cvars.Number( "vbump_bumprateout", vbump_bumprateout_def ), 0.01 )
	local bumpsoundenabled = false; --cvars.Bool( "vbump_bumpsound", true )
	local bumpsounddelay = math.max( cvars.Number( "vbump_bumpsounddelay", vbump_bumpsounddelay_def ), 0 )
	
	-- We work with unsquare-rooted values, so we keep these values in power of 2
	local maxdist2 = maxdist*maxdist
	local mindist2 = mindist*mindist
	local minvel2 = minvel*minvel
	
	-- Get eye trace and it's distance.
	-- We take non-rooted value, for optimization
	local tr = ply:GetEyeTrace()
	local dist = tr.StartPos:DistToSqr(tr.HitPos)
	
	-- Get angle direction as normal vector
	local fwd = ang:Forward()
	
	-- This is extent of how far weapon will move, between 0..1
	-- Formula is kinda simple: current_distance / total_distance
	local curscale = 1 - math.Clamp( ((dist-mindist2)/(maxdist2-mindist2)), 0, 1 )
	
	-- Interpolate scale
	if VBUMP_scale < curscale then -- go backward
		VBUMP_scale = VBUMP_scale + math.min( bumpratein, curscale-VBUMP_scale ) 
	else -- go back forward
		VBUMP_scale = VBUMP_scale - math.min( bumprateout, VBUMP_scale-curscale )
	end
	
	-- calculate move speed and angle speed for bumpsound
	if bumpsoundenabled and not dontbump[wep.ClassName] then
	
		-- Move speed
		local velocity = ply:GetVelocity():Length2DSqr()
		-- Angle delta and speed
		local delta = ang - VBUMP_prevAng
		-- Keep values between -180 and 180
		delta:Normalize()
		-- Get absolute values, so that works when turning in any directions
		delta.p, delta.y = math.abs(delta.p), math.abs(delta.y)
		
		-- Fast enough, then bump. Emits on player. Only this player can hear it because we are clientside.
		if VBUMP_scale > 0 and ( CurTime() > VBUMP_lastbump + bumpsounddelay ) and ( velocity > minvel2 or delta.p > mindelta or delta.y > mindelta ) then
			ply:EmitSound( bumpsound )
		end
	
	end
	
	-- Update last time bump only when colliding
	if VBUMP_scale > 0 then VBUMP_lastbump = CurTime() end
	
	-- Save new previous angle value
	VBUMP_prevAng = ang
	
	-- Don't move when we are ironsighting.
	-- We actually needed all previous calculations, so the weapon won't pop up when exiting ironsights.
	if ( wep.GetIronsight and wep:GetIronsight() ) or ( wep.GetIronsights and wep:GetIronsights() ) or ( wep.GetIronSights and wep:GetIronSights() ) then
		return
	end
	
	-- Finally, pos
	pos = pos + fwd*(-1)*movedist*VBUMP_scale
	
	return pos, ang
end

-- Add our view hook
hook.Add( "CalcViewModelView", "zzzzzzzzViewmodelBump", CalcViewModelView )



-- Menu stuff
local function vbump_cpanel( panel )
	-- Text for Reset button
	local reset = "Reset"
	
	-- Add checkboxes and help texts
	local vbump_enable_panel = panel:CheckBox( "Enable", "vbump_enable" )
	local vbump_enable_help = panel:Help( vbump_enable_desc )
	
	local vbump_bumpsound_panel = panel:CheckBox( "Bump Sound", "vbump_bumpsound" )
	local vbump_bumpsound_help = panel:Help( vbump_bumpsound_desc )
	
	-- Add sliders, reset buttons and help texts, tell buttons what do on clicking
	local vbump_movedist_panel = panel:NumSlider( "Move distance", "vbump_movedist", 0, 256, 1 )
	local vbump_movedist_reset = panel:Button( reset )
	vbump_movedist_reset.DoClick = function() vbump_movedist_panel:SetValue( vbump_movedist_def ) end
	local vbump_movedist_help = panel:Help( vbump_movedist_desc )
	
	local vbump_mindist_panel = panel:NumSlider( "Minimal distance", "vbump_mindist", 0, 256, 1 )
	local vbump_mindist_reset = panel:Button( reset )
	vbump_mindist_reset.DoClick = function() vbump_mindist_panel:SetValue( vbump_mindist_def ) end
	local vbump_mindist_help = panel:Help( vbump_mindist_desc )
	
	local vbump_maxdist_panel = panel:NumSlider( "Maximal distance", "vbump_maxdist", 0, 256, 1 )
	local vbump_maxdist_reset = panel:Button( reset )
	vbump_maxdist_reset.DoClick = function() vbump_maxdist_panel:SetValue( vbump_maxdist_def ) end
	local vbump_maxdist_help = panel:Help( vbump_maxdist_desc )
	
	local vbump_minvel_panel = panel:NumSlider( "Minimum move speed", "vbump_minvel", 0, 250, 0 )
	local vbump_minvel_reset = panel:Button( reset )
	vbump_minvel_reset.DoClick = function() vbump_minvel_panel:SetValue( vbump_minvel_def ) end
	local vbump_minvel_help = panel:Help( vbump_minvel_desc )
	
	local vbump_mindelta_panel = panel:NumSlider( "Minimum angle speed", "vbump_mindelta", 0, 5, 1 )
	local vbump_mindelta_reset = panel:Button( reset )
	vbump_mindelta_reset.DoClick = function() vbump_mindelta_panel:SetValue( vbump_mindelta_def ) end
	local vbump_mindelta_help = panel:Help( vbump_mindelta_desc )
	
	local vbump_bumpratein_panel = panel:NumSlider( "Bump rate in", "vbump_bumpratein", 0.01, 1, 2 )
	local vbump_bumpratein_reset = panel:Button( reset )
	vbump_bumpratein_reset.DoClick = function() vbump_bumpratein_panel:SetValue( vbump_bumpratein_def ) end
	local vbump_bumpratein_help = panel:Help( vbump_bumpratein_desc )
	
	local vbump_bumprateout_panel = panel:NumSlider( "Bump rate out", "vbump_bumprateout", 0.01, 1, 2 )
	local vbump_bumprateout_reset = panel:Button( reset )
	vbump_bumprateout_reset.DoClick = function() vbump_bumprateout_panel:SetValue( vbump_bumprateout_def ) end
	local vbump_bumprateout_help = panel:Help( vbump_bumprateout_desc )
	
	local vbump_bumpsounddelay_panel = panel:NumSlider( "Bump sound delay", "vbump_bumpsounddelay", 0.5, 10, 1 )
	local vbump_bumpsounddelay_reset = panel:Button( reset )
	vbump_bumpsounddelay_reset.DoClick = function() vbump_bumpsounddelay_panel:SetValue( vbump_bumpsounddelay_def ) end
	local vbump_bumpsounddelay_help = panel:Help( vbump_bumpsounddelay_desc )
end

-- Add our menu
local function vbump_populatetoolmenu()
	spawnmenu.AddToolMenuOption( "Options", "Player", "vbump_toolmenu", "View Model Bump Settings", "", "", vbump_cpanel )
end

-- Add our menu hook
hook.Add( "PopulateToolMenu", "vbump_PopulateToolMenu", vbump_populatetoolmenu )


--YOU'RE WINNER!


