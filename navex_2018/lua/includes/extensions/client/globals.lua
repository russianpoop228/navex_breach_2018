--[[
lua/includes/extensions/client/globals.lua
--]]


if ( SERVER ) then return end


function ScreenScale( size )
	return size * ( ScrW() / 640.0 )	
end

SScale = ScreenScale


