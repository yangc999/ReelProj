-- HUGE_ReelAmiMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台元素所有的动画表现；同样创建全部滚轴，每个滚轴包含全部元素的动画，平时不参与滚动，只有在替换真实元素时候出现指定元素
-- *

local HUGE_Clipping_View = require("core.struct.method.HUGE_Clipping_View")
local HUGE_VtemAmi = require("core.struct.method.HUGE_VtemAmi")

local HUGE_ReelAmiMgr = class("HUGE_ReelAmiMgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 10)) end)


function HUGE_ReelAmiMgr:ctor(machineMgr)
	-- HUGE_ReelAmiMgr.super.ctor(self)

	self.machineMgr = machineMgr

	self.amiCache    	= {}  -- 所有元素动画的集合，每个元素有多个，在用的时候，如果用完了则立即创建加入
	-- self.reelAmiArr    	= {}	-- 包含所有滚轴，每个滚轴包含全部元素的动画，在需要替换真轴的时候才一起滚动出现，否则隐藏

	self.slotsAmiLayer = nil

end

--------------------- delegate ------------------------
function HUGE_ReelAmiMgr:stripMove(colIdx, cellList)

	-- self.stopInfo.stopTagList
	-- self.stopInfo.showTagArrList

	if #self.amiCache then

		for i, vtem in ipairs(self.amiCache) do

			if vtem.colIdx == colIdx then

				for j, gear in ipairs(cellList) do
					if vtem.showTag ==  gear.hoc_tag then
						-- local gear = cellList[vtem.rowIdx]
						vtem:setPosition(cc.p(gear.hoc_posx, gear.hoc_posy)) -- 更新位置
						vtem:setZOrder(gear.hoc_zorder) -- 更新层级
						-- if vtem.unit:isFeature() == true then
						-- 	vtem:show(true)
						-- 	vtem:playAnimation(false, "ami1") 
						-- end
						break
					end
				end
			end
		end

	end
end

-- * 这里是将要停止，替换真滚轴, showTagList是从stopTag开始的后面需要显示的元素,从下到上的元素
function HUGE_ReelAmiMgr:stripBegStop(colIdx, stopTag, showTagList, trueStrips)

		-- trueStrips 返回的真实滚轴数据，从上至下排列，我们需要在 self.amiCache 寻找相应的元素，并标记上 col，row
		local trueList = self.machineMgr.DataMgr.sdata.trueStrips[colIdx]

		if #self.amiCache > 0 then
			for i, showIdx in ipairs(showTagList) do

				local slotsId = trueList[i]
				local inCache = false

				for j, vtem in ipairs(self.amiCache) do

					if slotsId == vtem.unit.id and vtem.colIdx == -1 and vtem.rowIdx == -1 then
						vtem.colIdx = colIdx
						vtem.rowIdx = i
						vtem.showTag = showIdx
						inCache = true
						-- print("stripBegStop-->>", colIdx, vtem.colIdx, vtem.rowIdx, vtem.unit.id, showIdx)
						break
					end
				end

				if inCache == false then
					local unit = self.machineMgr.DataMgr:elementById(slotsId)

        			local vAnim = HUGE_VtemAmi.new(unit, self.machineMgr.DataMgr.sdata.cellWidth, self.machineMgr.DataMgr.sdata.cellHeight)

        			table.insert(self.amiCache, vAnim)

        			vAnim.colIdx = colIdx
        			vAnim.rowIdx = i
        			vAnim.showTag = showIdx

        			-- print("stripBegStop--cache>>", colIdx, vtem.colIdx, vtem.rowIdx, vtem.unit.id, showIdx)
				end
			end
		end
end

-- * 一条滚轴将要缓动，接近停止
function HUGE_ReelAmiMgr:stripNearStop(colIdx)
	if #self.amiCache then

		for i, vtem in ipairs(self.amiCache) do

			if vtem.colIdx == colIdx and vtem.rowIdx ~= -1 and vtem.showTag ~= -1 then

				if vtem.unit:isFeature() == true then
					vtem:show(true)
					vtem:playAnimation(false, "ami1") 
				end
			end
		end
	end
end

-- * 一条滚轴完成缓动，完全停止
function HUGE_ReelAmiMgr:stripEndStop(colIdx)
	if #self.amiCache then

		for i, vtem in ipairs(self.amiCache) do

			if vtem.colIdx == colIdx and vtem.rowIdx ~= -1 and vtem.showTag ~= -1 then
				vtem:show(true)
			end
		end
	end
end
--------------------- end ------------------------

------------------------------------------------------
function HUGE_ReelAmiMgr:createSlotsAmiLayer()
	if not self.slotsAmiLayer then
        self.slotsAmiLayer = HUGE_Clipping_View.new(self.machineMgr.DataMgr:reelClippingCfg(), 50, 50)
        self.slotsAmiLayer:setAnchorPoint(cc.p(0.5, 0.5))
        self.slotsAmiLayer:setPosition(cc.p(display.cx,display.cy - 0))

        self:addChild(self.slotsAmiLayer, 1)
    end

    self:initAmiReel()
end

function HUGE_ReelAmiMgr:refreshNormalModel()
	
	self.slotsAmiLayer:changeModel(self.machineMgr.DataMgr:reelClippingCfg(), 0, 0)
	
end

function HUGE_ReelAmiMgr:refreshWishModel()
	
	self.slotsAmiLayer:changeModel(self.machineMgr.DataMgr:reelClippingWishCfg(), 0, 0)
	
end

function HUGE_ReelAmiMgr:initAmiReel()

	for i, unit in ipairs(self.machineMgr.DataMgr.sdata.elementUnitList) do
		-- if #unit.ami > 0 then
		-- print("HUGE_ReelAmiMgr:initAmiReel--->>>>", unit.id)

			for j=1, self.machineMgr.DataMgr.sdata.row*5 do

				local vAnim = HUGE_VtemAmi.new(unit, self.machineMgr.DataMgr.sdata.cellWidth, self.machineMgr.DataMgr.sdata.cellHeight)
				vAnim:show(false)
				self.slotsAmiLayer:addChild(vAnim)

				table.insert(self.amiCache, vAnim)

				print("HUGE_ReelAmiMgr:initAmiReel--->>>>", unit.id)

			end
		-- end
	end
	print("HUGE_ReelAmiMgr:initAmiReel--->>>>", #self.amiCache)
end

function HUGE_ReelAmiMgr:clearAmiCacheState()
	if #self.amiCache > 0 then
		for i, vtem in ipairs(self.amiCache) do
			vtem:clearAmiState()
			vtem:show(false)
		end
	end
end
-- function HUGE_ReelMgr:initReel()

-- 	for i,v in ipairs(self.machineMgr.DataMgr.sdata.rcList) do

-- 		local gearList = self.machineMgr.DriveCtr:dearingInfoListByIdx(i)
-- 		local reelItemArr = {}

-- 		-- * 创建每个滚动条所属的真实元素
-- 		for j, gear in ipairs(gearList) do
-- 			local slotsId 	= self.machineMgr.DataMgr:defaultSlotsByRC(i, j)
-- 			local unit 		= self.machineMgr.DataMgr:elementById(slotsId)
			
-- 			if unit ~= nil then
-- 				local item = HUGE_Vtem.new(unit, self.machineMgr.DataMgr.sdata.cellWidth, self.machineMgr.DataMgr.sdata.cellHeight)

-- 				item:setPosition(cc.p(gear.hoc_posx, gear.hoc_posy))
-- 				item:setTagIdx(gear.hoc_tag)
				
-- 				self.slotsAmiLayer:addChild(item)

-- 				item:setZOrder(gear.hoc_zorder)

-- 				table.insert(reelItemArr, item)
-- 			end
-- 		end

-- 		table.insert(self.reelArr, reelItemArr)
-- 	end
-- end

return HUGE_ReelAmiMgr



