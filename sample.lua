----------------------------------------------
-- Sample of SlibRGB57wTM1640.lua for W4.00.03
-- Copyright (c) 2019, AoiSaya
-- All rights reserved.
-- 2019/09/01 rev.0.02
-----------------------------------------------
function chkBreak(n)
	sleep(n or 0)
	if fa.sharedmemory("read", 0x00, 0x01, "") == "!" then
		error("Break!",2)
	end
end
fa.sharedmemory("write", 0x00, 0x01, "-")

local script_path = function()
	local  str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)")
end

--main
local myDir  = script_path()
led = require (myDir.."lib/SlibRGB57wTM1640")
local bright = 1 -- 0..8
local rgb={}
local color = 1
local pat = {0x0C,0x1E,0x3C,0x1E,0x0C}
local clr = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local r, g, b
local n = 8

led:setup(bright)

while 1 do
	b = bit32.btest(color,1)
	r = bit32.btest(color,2)
	g = bit32.btest(color,4)
	color = color % 7+1
	for k=1,5 do
		d = pat[k]
		rgb[k*3-2] = r and d or 0
		rgb[k*3-1] = g and d or 0
		rgb[k*3  ] = b and d or 0
	end

	for i=0,n*10 do
		for j=0,n do
			p = (n-i<j) and (i-n*8<j)
			led:write(p and rgb or clr)
		end
		chkBreak(1)
		collectgarbage()
	end
end
