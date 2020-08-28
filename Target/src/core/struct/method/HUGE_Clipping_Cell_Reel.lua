-- HUGE_Clipping_Cell_Reel.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- local scfg = require("machine.Scfg")

-- * 一个单条滚轴，只切割其中的一个格子，并规定格子的位置，暂时不支持切割多个格子，不包括中间的线宽，锚点为中心点；主要用于扩展使用

local HUGE_Clipping_Cell = require("core.struct.method.HUGE_Clipping_Cell")
local HUGE_Vtem = require("core.struct.method.HUGE_Vtem")

local HUGE_Clipping_Cell_Reel = class("HUGE_Clipping_Cell_Reel", function()
	return cc.Node:create()
end)

function HUGE_Clipping_Cell_Reel:ctor()

	----------------------数据------------------------

	self._vtemList = {}

	self.clipCell = nil

end
	-- * 参数说明
	-- clipIdx 			--切割格子的位置，从上到下，比如3X5的，共有5行，第1行和第5行都在显示区域以外的
	-- viewType 		--对齐类型
	-- colIdx 			--对齐类型
	-- curReelCellCount --当前滚轴显示的元素个数
	-- viewCellMaxCount --当前页面能显示的最大元素个数
	-- maxCellCount 	--当前元素最大格子数
	-- cellHeight 		--格子高
	-- celWidth 		--格子宽
function HUGE_Clipping_Cell_Reel:initReelData(clipIdx, viewType, colIdx, curReelCellCount, viewCellMaxCount, maxCellCount, cellHeight, celWidth)
	
	self:setContentSize(cc.size(celWidth, curReelCellCount*cellHeight))
	self:setAnchorPoint(cc.p(0.5,0.5))

	local maxConut = self._curReelCellCount + self._maxCellCount*2

	self._clipIdx				= clipIdx
	self._viewType 				= viewType
	self._colIdx 				= colIdx
	self._curReelCellCount	 	= curReelCellCount
	self._viewCellMaxCount 		= viewCellMaxCount
	self._maxCellCount 			= maxCellCount
	self._cellHeight 			= cellHeight
	self._cellWidth 			= celWidth

	local clipCellPosY = self:cellPosY(maxConut, self._clipIdx)

	self.clipCell = HUGE_Clipping_Cell.new(celWidth*0.5, cellHeight)
	self.clipCell:setPosition(cc.p(posx, clipCellPosY))
	self.addChild(self.clipCell)
	
	for i=1, maxConut do
		local slotsId 	= HUGE_SlotsData:defaultSlotsByRC(self._colIdx, i)
		local unit 		= HUGE_SlotsData:elementById(slotsId)

		local item = HUGE_Vtem.new(unit, self._cellWidth, self._cellHeight)

		local posx = self.hoc_width*0.5 	-- 标记一个本单元格的x位置
		local posy = self:cellPosY(maxConut, i) -- 标记一个本单元格的y位置
		local zorder = i + (self._colIdx - 1)*maxConut

		-- * 偏移Y的位置
		posy = posy - clipCellPosY

		item:setPosition(cc.p(posx, posy))
		item:tagIdx(i)
		
		self.clipCell:addChild(item)
		
		item:setZOrder(zorder)

		table.insert(self._vtemList, item)
	end
end

-- 这里说明一下，cell是从上往下排列的,1行，(2行，3行，4行)，5行
function HUGE_Clipping_Cell_Reel:cellPosY(maxConut, row)

	local posY = (maxConut - row - self._maxCellCount)*self.hoc_height + self.hoc_height*0.5
	
	if self.hoc_viewType == sConf.HOC_VIEWTYPE.HOC_CENTER then
		posY = posY + (self.hoc_ViewShowColMaxGearN - self.hoc_ShowVarGearN)*self.hoc_height*0.5
	elseif self.hoc_viewType == sConf.HOC_VIEWTYPE.HOC_TOP then  -- top
		posY = posY + (self.hoc_ViewShowColMaxGearN - self.hoc_ShowVarGearN)*self.hoc_height
	elseif self.hoc_viewType == sConf.HOC_VIEWTYPE.HOC_BOTTOM then  -- bottom

	end

	return posY
end


return HUGE_Clipping_Cell_Reel

