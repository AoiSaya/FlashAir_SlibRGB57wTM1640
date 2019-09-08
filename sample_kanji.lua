----------------------------------------------
-- Sample of SlibRGB57wTM1640.lua for W4.00.03
-- Copyright (c) 2019, AoiSaya
-- All rights reserved.
-- 2019/09/01 rev.0.03
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
local libDir = myDir.."lib/"
local fontDir= myDir.."font/"
local led	 = require(libDir.."SlibRGB57wTM1640")
local jfont  = require(libDir.."SlibJfont")
local a3x8	 = jfont:open("3x8.sef")
local k6x8	 = jfont:open("k6x8.sef")

local bright = 1 -- 0..8
local d, r, g, b
local str= {
"こんにちは世界！　",
"FlashAir ",
"Demonstralion ",
}
led:setup(bright)
jfont:setFont(a3x8,k6x8)
local color = 1


rgb = {}
for i=1,15 do
	rgb[i] = 0
end

while 1 do
--chkBreak(2000)
for _,strUTF8 in ipairs(str) do
	strEUC, euc_length = jfont:utf82euc(strUTF8)
	p=1

	b = bit32.btest(color,1)
	r = bit32.btest(color,2)
	g = bit32.btest(color,4)
	color = color % 7 + 1
	while p<=#strEUC do
		bitmap,fh,fw,p = jfont:getFont(strEUC, p)
		for i=1,fw+1 do
			rgb = {table.unpack(rgb,4)}
			d = i<=fw and bitmap[i] or 0
			rgb[13] = r and d or 0
			rgb[14] = g and d or 0
			rgb[15] = b and d or 0
			led:write(rgb)
			chkBreak(100)
		end
		collectgarbage()
	end
	end
end
