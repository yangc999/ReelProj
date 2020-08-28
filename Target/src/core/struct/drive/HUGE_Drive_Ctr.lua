
--
-- * 控制所有 轴承，初始化，创建等

local sBearing = require("core.struct.drive.HUGE_Drive_Bearing")

local HUGE_Drive_Ctr = class("HUGE_Drive_Ctr", cc.Node)


--  delegate 回调函数，用于更新上层的数据信息

 -- 1 stripMove(self.hoc_idx, list<HUGE_Cell>)
 -- 2 stripBegStop(self.hoc_idx, self.hoc_stopTag, showList)
 ---3 stripEndStop(self.hoc_idx)
 
function HUGE_Drive_Ctr:ctor(delegate)

	self.delegate = delegate

	self.bearingList = {} -- 所有轴承列表

end

function HUGE_Drive_Ctr:upDate(dt)
	-- print("HUGE_Drive_Ctr:update ------1111")

	if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            bearing:upDate(dt)
        end
    end
end

----------------------初始化接口函数------------------------

-- * 初始化数据 viewType, idx, showGearCount, showGearCountWish, viewMaxGearCount, maxGearCount, height, width
function HUGE_Drive_Ctr:initData(slotsData)
	 -- * slots机台基本构成数据

    -- self.sdata = {}
    -- self.sdata.id = 0
    -- self.sdata.name = ""
    -- self.sdata.play = ""
    -- self.sdata.viewType = 0										viewType

    -- self.sdata.row          = 0     -- 最大行数                   
    -- self.sdata.col          = 0     -- 最大列数
    -- self.sdata.rcList       = {}    -- 滚轴行列数据列表
    -- self.sdata.rcListWish   = {}    -- 滚轴行列数据列表 预期的
    -- self.sdata.rowWidth     = 0     -- 滚轴总宽度
    -- self.sdata.colHight     = 0     -- 滚轴总高度
    -- self.sdata.lineWidth    = 0     -- 分割线宽度
    -- self.sdata.cellWidth    = 0     -- 每个cell的宽度
    -- self.sdata.cellHeight   = 0     -- 每个cell的高度
    -- self.sdata.cellMaxNum   = 0     -- 单个sprite占用的最大格数

    -- self.sdata.elementList = {}   -- 一个机台所有元素的数据信息

    -- self.viewAnimClipLeftAndRight = 0
    -- self.viewAnimClipTopAndBottom = 0

    for i,v in ipairs(slotsData.rcList) do

    	local bearing = sBearing.new(self)
    	local wish = slotsData.rcListWish[i]
    	-- bearing:initDearingData(slotsData.viewType, i, v, wish, slotsData.row, slotsData.cellMaxNum, slotsData.cellWidth, slotsData.cellHeight)
        bearing:initDearingData(slotsData.viewType, i, v, wish, slotsData.row, slotsData.cellMaxNum, slotsData.cellWidth, slotsData.cellHeight)
    	bearing:initPosAndZorder(i, slotsData.lineWidth)

        self:addChild(bearing)

    	table.insert(self.bearingList, bearing)
    end

end

--------------------- delegate ------------------------
function HUGE_Drive_Ctr:stripMove(colIdx, cellList)
    -- local reelItemArr = self.reelArr[colIdx]

    -- for i, item in ipairs(reelItemArr) do
    --     for j, cell in ipairs(cellList) do
    --         if item.tagIdx == cell.hoc_tag then
    --             item:setPosition(cc.p(cell.hoc_posx, cell.hoc_posy)) -- 更新位置
    --             item:setZOrder(cell.hoc_zorder) -- 更新层级
    --             break
    --         end
    --     end
    -- end

    self.delegate:stripMove(colIdx, cellList)
end

-- * 这里是将要停止，替换真滚轴，滚轴处于严格的对齐位置，showTagList是从stopTag开始的后面需要显示的元素,从下到上的元素
function HUGE_Drive_Ctr:stripBegStop(colIdx, stopTag, showTagList)

    -- local nextColIdx = colIdx + 1
    -- if nextColIdx <= 5 then
    --     local bearing = self.bearingList[nextColIdx]
    --     bearing:beforeBearingStopAction(true)
    -- end

    self.delegate:stripBegStop(colIdx, stopTag, showTagList)
end

function HUGE_Drive_Ctr:stripNextStop(colIdx)
    local nextIdx = colIdx + 1
    if nextIdx <= 5 then
        local bearing = self.bearingList[nextIdx]
        bearing:beforeBearingStopAction(true)
    end
end

function HUGE_Drive_Ctr:stripNearStop(colIdx)
    -- local nextIdx = colIdx + 1
    -- if nextIdx <= 5 then
    --     local bearing = self.bearingList[nextIdx]
    --     bearing:beforeBearingStopAction(true)
    -- end

    self.delegate:stripNearStop(colIdx)
end

-- * 一条滚轴完成缓动，完全停止
function HUGE_Drive_Ctr:stripEndStop(colIdx)
    self.delegate:stripEndStop(colIdx)
end


--------------------- end ------------------------
----------------------接口函数------------------------

function HUGE_Drive_Ctr:doAction()
	
	if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            bearing:doAction()
        end
    end

end

function HUGE_Drive_Ctr:stopAction()
	
	if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            bearing:stopAction()
        end
    end

end

function HUGE_Drive_Ctr:beforeReelStopAction(idx, isStop)

	if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            if i == idx then
            	bearing:beforeBearingStopAction(isStop)
            	break
            end
        end
    end

end

function HUGE_Drive_Ctr:quickStopAction()

	if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            bearing:quickStopAction()
        end
    end
end

function HUGE_Drive_Ctr:turboModel(idx, isTurbo)

	if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            if i == idx then
            	bearing:turboModel(isTurbo)
            	break
            end
        end
    end
    
end

function HUGE_Drive_Ctr:dearingInfoListByIdx(idx)

    if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            if i == idx then
                return bearing:bearingList()
            end
        end
    end

end
-- 第四个被调用 用来获取一条滚轴的中心点位置
function HUGE_Drive_Ctr:dearingCenterPosByIdx(idx)

    if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            if i == idx then
                return bearing:centerPos()
            end
        end
    end
    
end

function HUGE_Drive_Ctr:refreshNormalModel(normalList)
    
    if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            bearing:refreshShowGear(normalList[i])
        end
    end
end

function HUGE_Drive_Ctr:refreshWishModel(wishList)
    
    if #self.bearingList ~= 0 then 
        for i, bearing in ipairs(self.bearingList) do
            bearing:refreshShowGear(wishList[i])
        end
    end
end
-- 
function HUGE_Drive_Ctr:dispose()
end


return HUGE_Drive_Ctr


