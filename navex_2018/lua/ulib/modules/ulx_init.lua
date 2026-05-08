--[[
lua/ulib/modules/ulx_init.lua
--]]
if SERVER then
	include( "ulx/init.lua" )
else
	include( "ulx/cl_init.lua" )
end


