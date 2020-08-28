-- HUGE_DataMgr.lua
-- Author: Joker
-- Date: 2019-02-15 11:18:55
--

-- *
    -- 一个机台的通用数据结构，每个机台独立维护一份，必须继承该结构。定义特殊玩法、关键字等
-- *

local scfg = require("core.ctr.HUGE_Config")
local HUGE_Unit = require("core.struct.method.HUGE_Unit")

local HUGE_DataMgr = class("HUGE_DataMgr")

function HUGE_DataMgr:ctor()
    -- HUGE_DataMgr.super.ctor(self)

    ---- * 维护 两份数据 ，1:每个机台的配置文件数据，2:派生的 机台运行数据文件，包括消息等
    self.slotsConfigData = {}
    self.slotsRuningData = {}

    -- -- * svr传过来的spin结果包含2部分：base和feature

    -- -- * base 每次svr传过来的base的标准结构
    -- self.base = {}
    -- self.base.betIdx            = 0
    -- self.base.betExt            = {}
    -- self.base.winChips          = scfg.SLOTS_WIN_TYPE.NORMAL
    -- self.base.totalChips        = 0
    -- self.base.winType           = 0
    -- -- self.base.trueStrips        = {{71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}}
    -- self.base.trueStrips        = {{ e = {71,2,4,81,5}, a = {id = 71, in = 0, wish = 1}}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}}
    -- self.base.trueStripsExt     = {}
    -- self.base.lines             = {}

    -- -- * feature 每次svr传过来的feature的标准结构
    -- self.fstruct = {}
    -- self.fstruct.f_id       = 1  -- 每个独立feature的序号,不允许重复
    -- self.fstruct.f_state    = scfg.SLOTS_FEATURE_STATE.F_FINISH
    -- self.fstruct.f_order    = scfg.SLOTS_FEATURE_ORDER.NULL
    -- self.fstruct.f_type     = scfg.SLOTS_FEATURE_TYPE.NULL
    -- self.fstruct.f_data     = {}

    -- self.feature = {{fstruct}, {fstruct}}

    -- -- * end

    -- * slots机台基本构成数据

    self.sdata = {}
    self.sdata.id = 0
    self.sdata.name = ""
    self.sdata.viewType = 0

    self.sdata.row          = 0     -- 最大行数
    self.sdata.col          = 0     -- 最大列数
    self.sdata.rcList       = {}    -- 滚轴行列数据列表
    self.sdata.rcListWish   = {}    -- 滚轴行列数据列表 预期的
    self.sdata.rowWidth     = 0     -- 滚轴总宽度
    self.sdata.colHight     = 0     -- 滚轴总高度
    self.sdata.lineWidth    = 0     -- 分割线宽度
    self.sdata.cellWidth    = 0     -- 每个cell的宽度
    self.sdata.cellHeight   = 0     -- 每个cell的高度
    self.sdata.cellMaxNum   = 0     -- 单个sprite占用的最大格数

    self.sdata.elementUnitList = {}   -- 一个机台所有元素的数据信息
    self.sdata.elementInitList = {}   -- 一个机台初始化页面
    self.sdata.rollerList = {}   -- 一个机台假滚轴

    self.sdata.viewAnimClipLeftAndRight = 0
    self.sdata.viewAnimClipTopAndBottom = 0

    -- test
    -- self.sdata.trueStrips        = {{1,2,51,81,71}, {1,2,51,81,71},{1,1,1,2,51,81,71},{1,1,1,2,51,81,71},{1,1,1,2,51,81,71}}
    self.sdata.trueStrips        = {{2,51,81}, {51,81,71},{1,71,1,2,51},{71,1,51,2,51},{71,51,1,81,71}}
    -- self.sdata.trueStrips        = {{2}, {51, 51},{1,1,1},{1,2,51},{1,81,71}}
    -- -- * slots机台的下注信息

    -- self.sbet = {}
    -- self.sbetIdx    = 1
    -- self.sbetIdxMin = 1
    -- self.sbetIdxMax = 1
    -- self.sbetList   = {}
    -- self.sbetChips  = 100000
    -- self.sbetExt    = {}        -- 扩展数据，特殊情况下使用


    -- -- * slots feature 通用数据信息

    -- self.isFeature = false

    -- -- * 解析机台config数据

    -- -- self.totalElementList = {}

    self:build_slotsConfigData()
    self:build_slotsRuningData()
end

--------------------------------解析 每个机台的 config -------------------------------

function HUGE_DataMgr:build_slotsConfigData()

    local configPath = "core.config"
    local configLua = require(configPath)

    self.sdata.id = configLua.slotsId
    self.sdata.name = configLua.slotsName
    self.sdata.viewType = configLua.viewAlignmentType

    self.sdata.row          = 3     -- 最大行数
    self.sdata.col          = 5     -- 最大列数
    self.sdata.rcList       = configLua.rcList    -- 滚轴行列数据列表
    self.sdata.rcListWish   = configLua.rcWishList    -- 滚轴行列数据列表 预期的
    self.sdata.rowWidth     = configLua.viewWidth     -- 滚轴总宽度
    self.sdata.colHight     = configLua.viewHeight     -- 滚轴总高度
    self.sdata.lineWidth    = configLua.viewLineWidth     -- 分割线宽度
    self.sdata.cellWidth    = 158     -- 每个cell的宽度
    self.sdata.cellHeight   = 108     -- 每个cell的高度
    self.sdata.cellMaxNum   = 1     -- 单个sprite占用的最大格数

    self.sdata.elementUnitList = {}   -- 一个机台所有元素的数据信息

    for i,v in ipairs(configLua.elementArr) do
        local unit = HUGE_Unit.new()

        unit.id     = v.id
        unit.num    = v.num
        unit.type   = v.type
        unit.ami    = v.ami

        table.insert(self.sdata.elementUnitList, unit)
    end

    self.sdata.viewAnimClipLeftAndRight = configLua.viewAnimClipLeftAndRight
    self.sdata.viewAnimClipTopAndBottom = configLua.viewAnimClipTopAndBottom

    self.sdata.elementInitList  = configLua.initArr
    self.sdata.rollerList       = configLua.rollerArr

end

function HUGE_DataMgr:build_slotsRuningData()
end

-- function HUGE_DataMgr:elementById(eId)
--     for i,unit in ipairs(self.sdata.elementUnitList) do
--         if eId == uni.id then
--             return unit
--         end
--     end
--     return nil
-- end
-----------------------------------------end----------------------------------------
function HUGE_DataMgr:defaultSlotsByRC(col , row)
end


function HUGE_DataMgr:reelClippingCfg()
    local cfg = {}

    cfg.rcList          = self.sdata.rcList
    cfg.rcType          = self.sdata.viewType
    cfg.rcLineWidth     = self.sdata.lineWidth
    cfg.rcItemWidth     = self.sdata.cellWidth
    cfg.rcItemHeight    = self.sdata.cellHeight
    cfg.rcWidth         = self.sdata.rowWidth
    cfg.rcHeight        = self.sdata.colHight
    -- cfg.SlotsLineScale  = self.sdata.lineScale
    -- cfg.isElementNull = self.configLua.isElementNull

    return cfg
end

function HUGE_DataMgr:reelClippingWishCfg()
    local cfg = {}

    cfg.rcList          = self.sdata.rcListWish --self.sdata.rcList
    cfg.rcType          = self.sdata.viewType
    cfg.rcLineWidth     = self.sdata.lineWidth
    cfg.rcItemWidth     = self.sdata.cellWidth
    cfg.rcItemHeight    = self.sdata.cellHeight
    cfg.rcWidth         = self.sdata.rowWidth
    cfg.rcHeight        = self.sdata.colHight
    -- cfg.SlotsLineScale  = self.sdata.lineScale
    -- cfg.isElementNull = self.configLua.isElementNull

    return cfg
end

function HUGE_DataMgr:defaultSlotsByRC(col, row)
    -- print("getDefaultElementByPos(row) = ", row)
    -- print("getDefaultElementByPos(col) = ", col)
    if not self.sdata.elementInitList[col] or not self.sdata.elementInitList[col][row] then
        -- writeTabToLog({row=row, col=col, defaultElementList=self.defaultElementList}, "getDefaultElementByPos:::", "MachineDataLog7.lua")
    end
    return self.sdata.elementInitList[col][row]  -- 
end

function HUGE_DataMgr:elementById(slotsId)
    for i,unit in ipairs(self.sdata.elementUnitList) do
        if unit.id == slotsId then
            return unit
        end
    end
end

return HUGE_DataMgr
