-- HUGE_ReelMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台的元素滚动管理机制
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_Clipping_View = require("core.struct.method.HUGE_Clipping_View")
local HUGE_Vtem = require("core.struct.method.HUGE_Vtem")



local HUGE_ReelMgr = class("HUGE_ReelMgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)

function HUGE_ReelMgr:ctor(machineMgr)
	-- HUGE_ReelMgr.super.ctor(self)

	self.machineMgr = machineMgr

	self.reelArr  = {}			-- 这里是slots的全部滚轴

	self.slotsLayer = nil

end

--------------------- delegate ------------------------
function HUGE_ReelMgr:stripMove(colIdx, cellList)
	local reelItemArr = self.reelArr[colIdx]

	for i, item in ipairs(reelItemArr) do
		for j, cell in ipairs(cellList) do
			if item.tagIdx == cell.hoc_tag then
				item:setPosition(cc.p(cell.hoc_posx, cell.hoc_posy)) -- 更新位置
				item:setZOrder(cell.hoc_zorder) -- 更新层级
				break
			end
		end
	end
end

-- * 这里是将要停止，替换真滚轴，滚轴处于严格的对齐位置，showTagList是从stopTag开始的后面需要显示的元素,从下到上的元素
function HUGE_ReelMgr:stripBegStop(colIdx, stopTag, showTagList)
	
	local reelColList = self.reelArr[colIdx]

	local trueReelList = self.machineMgr.DataMgr.sdata.trueStrips[colIdx]

	for i, trueSlotsId in ipairs(trueReelList) do
		
		local showTag = showTagList[i]

		for k, vtem in ipairs(reelColList) do
			if vtem.tagIdx == showTag then
				local unit = self.machineMgr.DataMgr:elementById(trueSlotsId)
		        vtem:refreshItemIcon(unit)
				break
			end 
		end
	end

end

-- * 一条滚轴将要缓动，完全停止
function HUGE_ReelMgr:stripNearStop(colIdx)

end

-- * 一条滚轴完成缓动，完全停止
function HUGE_ReelMgr:stripEndStop(colIdx)

end
--------------------- end ------------------------

function HUGE_ReelMgr:upDate(dt)
	
	if #self.reelCellArr ~= 0 then 
        for i, reel in ipairs(self.reelCellArr) do
            reel:upDate(dt)
        end
    end
end

------------------------------------------------------
function HUGE_ReelMgr:createSlotsLayer()
	if not self.slotsLayer then
        self.slotsLayer = HUGE_Clipping_View.new(self.machineMgr.DataMgr:reelClippingCfg())
        self.slotsLayer:setAnchorPoint(cc.p(0.5, 0.5))
        self.slotsLayer:setPosition(cc.p(display.cx,display.cy - 0))
        self.slotsLayer:test()
        self:addChild(self.slotsLayer, 1)
    end

    self:initReel()
end

function HUGE_ReelMgr:refreshNormalModel()
	
	self.slotsLayer:changeModel(self.machineMgr.DataMgr:reelClippingCfg(), 0, 0)
	
end

function HUGE_ReelMgr:refreshWishModel()
	
	self.slotsLayer:changeModel(self.machineMgr.DataMgr:reelClippingWishCfg(), 0, 0)
	
end

function HUGE_ReelMgr:initReel()

	for i,v in ipairs(self.machineMgr.DataMgr.sdata.rcList) do
		-- * 创建滚动条 以及 滚动条所属的小格子
		-- local ami = HUGE_Drive_Bearing.new(self)
		-- ami:initStripData(HUGE_SlotsData.sdata.viewType, i, v, HUGE_SlotsData.sdata.row, HUGE_SlotsData.sdata.cellMaxNum, HUGE_SlotsData.sdata.cellWidth, HUGE_SlotsData.sdata.cellHeight)
		-- ami:initPosAndZorder(i, HUGE_SlotsData.sdata.lineWidth)

		-- table.insert(self.reelCellArr, ami)

		-- local bearing = sBearing.new(self.delegate)
  --   	local wish = slotsData.rcListWish[i]
  --   	bearing:initDearingData(slotsData.viewType, i, v, wish, slotsData.row, slotsData.cellMaxNum, slotsData.cellHeight, slotsData.cellHeight)
  --   	bearing:initPosAndZorder(i, slotsData.lineWidth)


		local gearList = self.machineMgr.DriveCtr:dearingInfoListByIdx(i)
		local reelItemArr = {}

		print("initReel:", #gearList)
		-- * 创建每个滚动条所属的真实元素
		for j, gear in ipairs(gearList) do
			local slotsId 	= self.machineMgr.DataMgr:defaultSlotsByRC(i, j)
			local unit 		= self.machineMgr.DataMgr:elementById(slotsId)
			
			if unit ~= nil then
				local item = HUGE_Vtem.new(unit, self.machineMgr.DataMgr.sdata.cellWidth, self.machineMgr.DataMgr.sdata.cellHeight)

				item:setPosition(cc.p(gear.hoc_posx, gear.hoc_posy))
				item:setTagIdx(gear.hoc_tag)
				
				self.slotsLayer:addChild(item)

				item:setZOrder(gear.hoc_zorder)

				table.insert(reelItemArr, item)
			end
		end

		table.insert(self.reelArr, reelItemArr)
	end
end

return HUGE_ReelMgr



