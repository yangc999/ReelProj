-- HUGE_SlotsData.lua
-- Author: Joker
-- Date: 2019-02-15 11:18:55
--

-- *
    -- 一个机台的通用数据结构，每个机台独立维护一份，必须继承该结构。定义特殊玩法、关键字等
-- *

local scfg = require("core.ctr.HUGE_Config")

local HUGE_SlotsData = class("HUGE_SlotsData", Cls_BaseData)

local f_freespin_struct = {

    f_count_select = 0,     -- freespin的次数，0:固定次数、svr传过来；1:用户手动选择、传给svr
    f_retrigger_type = 0,   -- 再次触发freespin，0:直接加次数；1:重新开始一轮freespin

    f_count = 0,                  -- 当前一个freespin的次数
    f_countExt = 0,               -- 预留一个扩展，比如转盘转到5次额外的freespin，可以临时放这里
    f_total_count = 0,            -- 整个生命周期中freespin的总次数
    f_retrigger_count = 0,        -- 再次触发freespin，获取的额外次数；重新开始一轮的freespin，该值为0
    f_retriggerGame_count = 0,    -- 如果f_retrigger_type = 1，那么这里记录还有多少次新一轮的freespin

    f_win_chips = 0,               -- freespin过程中，当前一次旋转中的钱
    f_win_type = 0,                -- freespin过程中，当前一次旋转中奖类型，bigwin,mega,,,epic等

    f_wild_mutilExt = 0,           -- 特殊中wild的时候的倍数
    f_win_mutilExt = 0,            -- 特殊中任何中奖时候的倍数

    f_ext = {},                    -- 用于不知道啥情况的扩展
}
-- * 任何一个feature的基本数据构成如下：-------------------
    -- {
    --     key = "freespin",  -- 关键字
    --     state = 0:等待状态，1:过程中，2:结束  -- 状态
    --     data = {} -- 数据包
    -- }
-- * 结束----------------------------------------------
function HUGE_SlotsData:ctor()
    HUGE_SlotsData.super.ctor(self)

    -- * slots机台基本构成数据

    self.sdata = {}
    self.sdata.id = 0
    self.sdata.name = ""
    self.sdata.play = ""
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

    self.sdata.elementList = {}   -- 一个机台所有元素的数据信息

    self.viewAnimClipLeftAndRight = 0
    self.viewAnimClipTopAndBottom = 0
    -- * slots机台的下注信息

    self.sbet = {}
    self.sbetIdx    = 1
    self.sbetIdxMin = 1
    self.sbetIdxMax = 1
    self.sbetList   = {}
    self.sbetChips  = 100000
    self.sbetExt    = {}        -- 扩展数据，特殊情况下使用


    -- * svr传过来的spin结果包含2部分：base和feature

    -- * base 每次svr传过来的base的标准结构
    self.base = {}
    self.base.betIdx            = 0
    self.base.betExt            = {}
    self.base.winChips          = scfg.SLOTS_WIN_TYPE.NORMAL
    self.base.totalChips        = 0
    self.base.winType           = 0
    -- self.base.trueStrips        = {{71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}}
    self.base.trueStrips        = {{ e = {71,2,4,81,5}, a = {id = 71, in = 0, wish = 1}}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}, {71,2,4,81,5}}
    self.base.trueStripsExt     = {}
    self.base.lines             = {}

    -- * feature 每次svr传过来的feature的标准结构
    -- * 基本规则如下：
    -- * 1，不允许同时中两个feature
    -- * 2，在一个feature中允许中另外的feature
    self.feature = {}
    self.isFeature = false
    
    -- self.fstruct = {}
    -- self.fstruct.f_id       = 1  -- 每个独立feature的序号,不允许重复
    -- self.fstruct.f_state    = scfg.SLOTS_FEATURE_STATE.F_FINISH
    -- self.fstruct.f_order    = scfg.SLOTS_FEATURE_ORDER.NULL
    -- self.fstruct.f_type     = scfg.SLOTS_FEATURE_TYPE.NULL
    -- self.fstruct.f_data     = {}

    -- self.feature = {{fstruct}, {fstruct}}


    -- * end


    

    -- * 解析机台config数据

    -- self.totalElementList = {}


end
-----------------------------------------必须要继承的接口函数----------------------------------------
-- * 注册feature的关键字，前后端约定注册类型的feature
function HUGE_SlotsData:registerFeatureKey()
end

--------------------------------解析 每个机台的 config -------------------------------

function HUGE_SlotsData:elementById(eId)
    for i,unit in ipairs(self.sdata.elementList) do
        if eId == uni.id then
            return unit
        end
    end
    return nil
end
-----------------------------------------end----------------------------------------
function HUGE_SlotsData:defaultSlotsByRC(col , row)
end


function HUGE_SlotsData:reelClippingCfg()
    local cfg = {}

    cfg.rcList          = self.sdata.rcList
    cfg.rcType          = self.sdata.viewType
    cfg.rcLineWidth     = self.sdata.lineWidth
    cfg.rcItemWidth     = self.sdata.cellWidth
    cfg.rcItemHeight    = self.sdata.cellHeight
    cfg.rcWidth         = self.sdata.rowWidth
    cfg.rcHeight        = self.sdata.colHight
    cfg.SlotsLineScale  = self.sdata.lineScale
    -- cfg.isElementNull = self.configLua.isElementNull

    return cfg
end

return HUGE_SlotsData
