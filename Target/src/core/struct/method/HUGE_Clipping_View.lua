-- HUGE_Clipping_View.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

local scfg = require("core.ctr.HUGE_Config")

-- * 一个切割的整个游戏区域，锚点为中心点

local HUGE_Clipping_View = class("HUGE_Clipping_View", function()
	return cc.ClippingNode:create()
end)
	
	-- * cfg 数据结构

	-- local cfg = {}

	-- cfg.rcList 			-- 滚轴行列表 如：3,3,4,3,3
	-- cfg.rcType 			-- 滚轴竖方向的对齐类型 如：底部对齐，顶部，中部
	-- cfg.rcLineWidth 		-- 线宽
	-- cfg.rcItemWidth 		-- 单个格子宽
	-- cfg.rcItemHeight 	-- 单个格子高
	-- cfg.rcWidth 			-- 整个区域宽
	-- cfg.rcHeight 		-- 整个区域高
	-- cfg.SlotsLineScale 	-- 缩放的特殊处理

function HUGE_Clipping_View:ctor(cfg, addWidth, addHeight)

	self:setContentSize(cc.size(cfg.rcWidth, cfg.rcHeight))

	self.drawrect = cc.DrawNode:create(0)

	-- local pointArr = {}
	-- for i,v in ipairs(cfg.rcList) do
	-- 		-- v = v - 1
	-- 		local x0 = (i - 1)*cfg.rcItemWidth + (i - 2)*cfg.rcLineWidth + cfg.rcLineWidth*0.5
	-- 		local y0 = 0 --(cfg.rcHeight - v*cfg.rcItemHeight)*0.5

	-- 		if cfg.rcType == scfg.SLOTS_RCTYPE.CENTER then
	-- 			y0 = (cfg.rcHeight - v*cfg.rcItemHeight)*0.5
	-- 		elseif cfg.rcType == scfg.SLOTS_RCTYPE.TOP then  -- top
	-- 			y0 = (cfg.rcHeight - v*cfg.rcItemHeight)
	-- 		elseif cfg.rcType == scfg.SLOTS_RCTYPE.BOTTOM then  -- bottom
	-- 			y0 = 0
	-- 		end

	-- 		local x1 = x0 + cfg.rcItemWidth + cfg.rcLineWidth
	-- 		-- local y1 = (cfg.rcHeight - v*cfg.rcItemHeight)*0.5 + v*cfg.rcItemHeight
	-- 		local y1 = y0 + v*cfg.rcItemHeight

	-- 		if i == 1 then x0 = 0 x1 = cfg.rcItemWidth + cfg.rcLineWidth*0.5 end
	-- 		if i == #cfg.rcList then x1 = x0 + cfg.rcItemWidth + cfg.rcLineWidth*0.5 end
			
	-- 		-- y1 = y1 - cfg.rcItemHeight*(cfg.SlotsLineScale - 1) -- SlotsLineScale。注意：处理“猪爷到”三行裁剪为2行
	-- 		-- y0 = y0 + cfg.rcItemHeight*(cfg.SlotsLineScale - 1)

	-- 		y1 = y1 - cfg.rcItemHeight*(1 - 1) -- SlotsLineScale。注意：处理“猪爷到”三行裁剪为2行
	-- 		y0 = y0 + cfg.rcItemHeight*(1 - 1)

	-- 		table.insert(pointArr, cc.p(x0 - aWidth, y1 + aHeight))
	-- 		table.insert(pointArr, cc.p(x1 + aWidth, y1 + aHeight))

	-- 		table.insert(pointArr, cc.p(x1 + aWidth, y0 - aHeight))
	-- 		table.insert(pointArr, cc.p(x0 - aWidth, y0 - aHeight))

	-- 		self.drawrect:drawSolidPoly(pointArr, #pointArr, { r = 0, g = 0, b = 0, a = 1 })

	-- 		pointArr = nil
	-- 		pointArr = {}
	-- end	

	self:changeModel(cfg, addWidth, addHeight)

	self:setAlphaThreshold(1)
	self:setStencil(self.drawrect)
	self:setCascadeOpacityEnabled(true)

	
end

function HUGE_Clipping_View:changeModel(cfg, addWidth, addHeight)
	
	local aWidth  = addWidth or 0
	local aHeight = addHeight or 0

	local pointArr = {}
	for i,v in ipairs(cfg.rcList) do
			-- v = v - 1
			local x0 = (i - 1)*cfg.rcItemWidth + (i - 2)*cfg.rcLineWidth + cfg.rcLineWidth*0.5
			local y0 = 0 --(cfg.rcHeight - v*cfg.rcItemHeight)*0.5

			if cfg.rcType == scfg.SLOTS_RCTYPE.CENTER then
				y0 = (cfg.rcHeight - v*cfg.rcItemHeight)*0.5
			elseif cfg.rcType == scfg.SLOTS_RCTYPE.TOP then  -- top
				y0 = (cfg.rcHeight - v*cfg.rcItemHeight)
			elseif cfg.rcType == scfg.SLOTS_RCTYPE.BOTTOM then  -- bottom
				y0 = 0
			end

			local x1 = x0 + cfg.rcItemWidth + cfg.rcLineWidth
			-- local y1 = (cfg.rcHeight - v*cfg.rcItemHeight)*0.5 + v*cfg.rcItemHeight
			local y1 = y0 + v*cfg.rcItemHeight

			if i == 1 then x0 = 0 x1 = cfg.rcItemWidth + cfg.rcLineWidth*0.5 end
			if i == #cfg.rcList then x1 = x0 + cfg.rcItemWidth + cfg.rcLineWidth*0.5 end
			
			-- y1 = y1 - cfg.rcItemHeight*(cfg.SlotsLineScale - 1) -- SlotsLineScale。注意：处理“猪爷到”三行裁剪为2行
			-- y0 = y0 + cfg.rcItemHeight*(cfg.SlotsLineScale - 1)

			y1 = y1 - cfg.rcItemHeight*(1 - 1) -- SlotsLineScale。注意：处理“猪爷到”三行裁剪为2行
			y0 = y0 + cfg.rcItemHeight*(1 - 1)

			table.insert(pointArr, cc.p(x0 - aWidth, y1 + aHeight))
			table.insert(pointArr, cc.p(x1 + aWidth, y1 + aHeight))

			table.insert(pointArr, cc.p(x1 + aWidth, y0 - aHeight))
			table.insert(pointArr, cc.p(x0 - aWidth, y0 - aHeight))

			self.drawrect:drawSolidPoly(pointArr, #pointArr, { r = 0, g = 0, b = 0, a = 1 })

			pointArr = nil
			pointArr = {}
	end	
end

function HUGE_Clipping_View:test()

	local floor = cc.LayerColor:create(cc.c4b(255,255,255,150))    
    self:addChild(floor)

end

return HUGE_Clipping_View

