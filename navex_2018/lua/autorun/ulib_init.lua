--[[
lua/autorun/ulib_init.lua
--]]
-- Short and sweet
if SERVER then
	include( "ulib/init.lua" )
else
	include( "ulib/cl_init.lua" )
end


