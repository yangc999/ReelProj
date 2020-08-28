
--
-- HUGE_Machine_Layer_Mgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--
-- machine mgr 机台本身的管理类，负责机台相关的如下：

    -- * HUGE_BGMgr -- 机台背景
    -- * HUGE_ReelMgr -- 元素滚动层
    -- * HUGE_ReelAmiMgr -- 元素播放动画层
    -- * HUGE_TipsMgr -- 机台信息提示
    -- * HUGE_JackpotMgr -- jackpot或者收集类的
    -- * HUGE_FeatureMgr -- 中feature交互层

    -- * HUGE_Drive_Ctr -- 轴承驱动模块

local HUGE_Drive_Ctr = require("core.struct.drive.HUGE_Drive_Ctr")
local HUGE_ReelMgr = require("core.struct.machine.HUGE_ReelMgr")
local HUGE_ReelAmiMgr = require("core.struct.machine.HUGE_ReelAmiMgr")


local HUGE_Machine_Layer_Mgr = class("HUGE_Machine_Layer_Mgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)

-- class("BaseLayer", function() return cc.LayerColor:create() end)

function HUGE_Machine_Layer_Mgr:ctor(DataMgr, slotsCtr)

    self.DriveCtr = nil

    self.DataMgr = DataMgr 
    self.slotsCtr = slotsCtr

	self.BgMgr 			= nil  -- 背景管理
    self.ReelMgr 		= nil  -- 滚动元素
    self.ReelAmiMgr 	= nil  -- 动画元素
    self.TipsMgr 		= nil  -- 提示信息
    self.JackpotMgr 	= nil  -- 顶部jackpot
    self.FeatureMgr 	= nil  -- feature交互

    self.DriveCtr = HUGE_Drive_Ctr.new(self)
    
    -- 加载配置--
    self.clippingViewCfg= {}


    -- * slots机台基本构成数据

    -- self.sdata = {}
    -- self.sdata.id = 0
    -- self.sdata.name = ""
    -- self.sdata.play = ""
    -- self.sdata.viewType = 0                                      viewType

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
    -- local slotData = {}
    -- slotData.id = 100
    -- slotData.name = "xx"
    -- slotData.play = "xx"
    -- slotData.viewType = 0                                      

    -- slotData.row          = 3     -- 最大行数                   
    -- slotData.col          = 5     -- 最大列数
    -- slotData.rcList       = {3,3,3,3,3}    -- 滚轴行列数据列表
    -- slotData.rcListWish   = {3,3,3,3,3}    -- 滚轴行列数据列表 预期的
    -- slotData.rowWidth     = 820     -- 滚轴总宽度
    -- slotData.colHight     = 820     -- 滚轴总高度
    -- slotData.lineWidth    = 5     -- 分割线宽度
    -- slotData.cellWidth    = 160     -- 每个cell的宽度
    -- slotData.cellHeight   = 160     -- 每个cell的高度
    -- slotData.cellMaxNum   = 1     -- 单个sprite占用的最大格数

    -- self.driveCtr:initData(slotData)
    self.DriveCtr:initData(self.DataMgr.sdata)

    -- self:createMenu()


    self:addChild(self.DriveCtr, 1)

    -----------------------------------------------------------

    self.ReelMgr = HUGE_ReelMgr.new(self)
    -- self.ReelMgr:setAnchorPoint(cc.p(0.5,0.5))
    -- self.ReelMgr:setPosition(cc.p(display.cx,display.cy))
    self.ReelMgr:setPosition(cc.p(0,0))
    self:addChild(self.ReelMgr, 1)

    self.ReelMgr:createSlotsLayer()

    -- self.ReelMgr:refreshWishModel()
    -----------------------------------------------------------

    self.ReelAmiMgr = HUGE_ReelAmiMgr.new(self)
    self.ReelAmiMgr:setPosition(cc.p(0,0))
    self:addChild(self.ReelAmiMgr, 2)
    -- self.DriveCtr:doAction()
    self.ReelAmiMgr:createSlotsAmiLayer()
    -- self.ReelAmiMgr:refreshWishModel()

    self:refreshWishModel()

    self.touchIdx = 1
    
end

function HUGE_Machine_Layer_Mgr:doAction()
    self.DriveCtr:doAction()
    self.ReelAmiMgr:clearAmiCacheState()
end

function HUGE_Machine_Layer_Mgr:stopAction()
    self.DriveCtr:stopAction()
end

function HUGE_Machine_Layer_Mgr:quickStopAction()
    self.DriveCtr:quickStopAction()
end

function HUGE_Machine_Layer_Mgr:turboModel(idx, isTurbo)
    self.DriveCtr:turboModel(idx, isTurbo)
end



---------------------------delegate--------------------------------

function HUGE_Machine_Layer_Mgr:stripMove(idx, list)
    self.ReelMgr:stripMove(idx, list)
    self.ReelAmiMgr:stripMove(idx, list)
end

function HUGE_Machine_Layer_Mgr:stripBegStop(idx, stopTag, showList)
    self.ReelMgr:stripBegStop(idx, stopTag, showList)
    self.ReelAmiMgr:stripBegStop(idx, stopTag, showList, self.DataMgr.sdata.trueStrips)
end

function HUGE_Machine_Layer_Mgr:stripNearStop(idx)
    self.ReelMgr:stripNearStop(idx)
    self.ReelAmiMgr:stripNearStop(idx)
end

function HUGE_Machine_Layer_Mgr:stripEndStop(idx)
    self.ReelMgr:stripEndStop(idx)
    self.ReelAmiMgr:stripEndStop(idx)

    if idx == self.DataMgr.sdata.col then -- 最后一列停止了
        self.slotsCtr:allStripEndStop()
    end
end

function HUGE_Machine_Layer_Mgr:upDate(dt)
    
    if self.DriveCtr ~= nil then
        self.DriveCtr:upDate(dt)
    end

end

function HUGE_Machine_Layer_Mgr:refreshNormalModel()
    
    self.ReelMgr:refreshNormalModel()
    self.ReelAmiMgr:refreshNormalModel()
    self.DriveCtr:refreshNormalModel(self.DataMgr.sdata.rcList)
end

function HUGE_Machine_Layer_Mgr:refreshWishModel()
    
    self.ReelMgr:refreshWishModel()
    self.ReelAmiMgr:refreshWishModel()
    self.DriveCtr:refreshWishModel(self.DataMgr.sdata.rcListWish)
    
end
-----------------------------------------------------------

----------------------------------------hander------------------------------------------

function HUGE_Machine_Layer_Mgr:setCtrHander(ctr)
    self.SlotsView = ctr
end

function HUGE_Machine_Layer_Mgr:setBgHander(mgr)
    self.bgMgr = mgr
end

function HUGE_Machine_Layer_Mgr:setReelHander(mgr)
    self.ReelMgr = mgr
end

function HUGE_Machine_Layer_Mgr:setReelAmiHander(mgr)
    self.reelAmiMgr = mgr
end

function HUGE_Machine_Layer_Mgr:setTipsHander(mgr)
    self.tipsMgr = mgr
end

function HUGE_Machine_Layer_Mgr:setJackpotHander(mgr)
    self.jackpotMgr = mgr
end

function HUGE_Machine_Layer_Mgr:setFeatureHander(mgr)
    self.featureMgr = mgr
end

----------------------------------------hander------------------------------------------

-- function HUGE_Machine_Layer_Mgr:clippingViewCfg()
--     local cfg = {}

--     cfg.rcList = self.rcList
--     cfg.rcType = self.rcType
--     cfg.rcLineWidth = self.rcLineWidth
--     cfg.rcItemWidth = self.rcItemWidth
--     cfg.rcItemHeight = self.rcItemHeight
--     cfg.rcWidth = self.rcWidth
--     cfg.rcHeight = self.rcHeight

--     return cfg
-- end

return HUGE_Machine_Layer_Mgr