-- HUGE_Clipping_View.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- * 一个切割的单元小格子，锚点为中心点

local HUGE_Clipping_Cell = class("HUGE_Clipping_Cell", function()
	return cc.ClippingNode:create()
end)


function HUGE_Clipping_Cell:ctor(width, height)

	self:setContentSize(cc.size(width, height))
	self:setAnchorPoint(cc.p(0.5,0.5))

	local drawrect = cc.DrawNode:create(0)

	local pointArr = {}

	table.insert(pointArr, cc.p(0, height))
	table.insert(pointArr, cc.p(width, height))

	table.insert(pointArr, cc.p(width, 0))
	table.insert(pointArr, cc.p(0, 0))

	drawrect:drawSolidPoly(pointArr, #pointArr, { r = 0, g = 0, b = 0, a = 1 })

	self:setAlphaThreshold(1)
	self:setStencil(drawrect)
	self:setCascadeOpacityEnabled(true)
end

return HUGE_Clipping_Cell

