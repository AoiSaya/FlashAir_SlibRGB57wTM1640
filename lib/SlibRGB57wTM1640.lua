-----------------------------------------------
-- SoraMame library of RGB5x7 with TM1640 for W4.00.03
-- Copyright (c) 2019, AoiSaya,maenoh
-- All rights reserved.
-- 2019/09/08 rev.0.02
-----------------------------------------------
--[[
Pin assign
	PIN TM1640
CLK  5
CMD  2	DIN
D0	 7	SCLK
D1	 8	RK
D2	 9
D3	 1
VCC  4	VDD
VSS1 3	VSS
VSS2 6
--]]

local SlibRGB57wTM1640 = {
}

--[Low layer functions]--
function SlibRGB57wTM1640:writeCmd(data,gpio)
local tbl  = (type(data)=="table") and data or {data}
gpio = gpio or self.gpio
self.gpio = gpio
local d
local a = self.cfg
local r = gpio
local q = r+self.clk
local p = q+0x01
local BE = bit32.extract
local FP = fa.pio
	FP(a,p)FP(a,q)
	for i=1,#tbl do
		d = tbl[i]
		FP(a,r)FP(a,BE(d,0)+q)
		FP(a,r)FP(a,BE(d,1)+q)
		FP(a,r)FP(a,BE(d,2)+q)
		FP(a,r)FP(a,BE(d,3)+q)
		FP(a,r)FP(a,BE(d,4)+q)
		FP(a,r)FP(a,BE(d,5)+q)
		FP(a,r)FP(a,BE(d,6)+q)
		FP(a,r)FP(a,BE(d,7)+q)
	end
	FP(a,r)FP(a,q)FP(a,p)
end

--public
function SlibRGB57wTM1640:setup(bright,gpio,cfg,clk)
self.cfg  = cfg or 0x1F
self.clk  = clk or 0x02
self.gpio = gpio or 0x00
self:writeCmd(0x40) -- auto increment
self:cls()
self:setBright(bright)
end

--[For user functions]--
function SlibRGB57wTM1640:cls()
self:writeCmd(0xc0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0) --clear
end

function SlibRGB57wTM1640:write(bitmap,gpio)
	self:writeCmd({0xc0,table.unpack(bitmap)},gpio)
end

function SlibRGB57wTM1640:setBright(bright)
self:writeCmd(0x87+bright)
end

collectgarbage()
return SlibRGB57wTM1640
