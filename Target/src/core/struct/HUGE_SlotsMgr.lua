
--
-- HUGE_SlotsMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--
-- SlotsView 机台的各种层，可继承；管理的类如下：

    -- * HUGE_Topbar_Layer_Mgr      -- 顶部工具条
    -- * HUGE_Machine_Layer_Mgr     -- 游戏
    -- * HUGE_Activity_Layer_Mgr    -- 运营
    -- * HUGE_Bottombar_Layer_Mgr   -- 底部工具条
    -- * HUGE_Result_Layer_Mgr      -- 结果弹框等


local scfg = require("core.ctr.HUGE_Config")


local HUGE_Activity_Layer_Mgr   = require("core.struct.HUGE_Activity_Layer_Mgr")
local HUGE_Bottombar_Layer_Mgr  = require("core.struct.HUGE_Bottombar_Layer_Mgr")
local HUGE_Machine_Layer_Mgr    = require("core.struct.HUGE_Machine_Layer_Mgr")
local HUGE_Result_Layer_Mgr     = require("core.struct.HUGE_Result_Layer_Mgr")
local HUGE_Topbar_Layer_Mgr     = require("core.struct.HUGE_Topbar_Layer_Mgr")


local HUGE_SlotsMgr = class("HUGE_SlotsMgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)

function HUGE_SlotsMgr:ctor(gameCtr, dataMgr)
	-- HUGE_SlotsMgr.super.onInit(self)
    
    -- * 流程堆栈
    -- * 主要目的维持slots运行的状态机
    self.fstackList = {} -- 每一个数据单元是 feature关键字key
    -- * slots控制标记
    self.slotsCtrType        = scfg.SLOTS_CTR_TYPE.SLOTS_OVER

    -- * init
    self.GameCtr	 	= gameCtr  -- 游戏控制
    self.DataMgr        = dataMgr  -- 游戏数据

    -- * mgr
    self.ActivityLayerMgr   = nil
    self.BottombarLayerMgr  = nil
    self.TopbarLayerMgr     = nil
    self.MachineLayerMgr    = nil
    self.ResultLayerMgr     = nil

    self:build()
end

function HUGE_SlotsMgr:onEnter()
end


function HUGE_SlotsMgr:onExit()
end


function HUGE_SlotsMgr:onCleanUp()
end

----------------------------------测试------------------------------------
function HUGE_SlotsMgr:upDate(dt)
    
    if self.MachineLayerMgr ~= nil then
        self.MachineLayerMgr:upDate(dt)
    end

end

----------------------------------状态机功能接口------------------------------------
-- * 不允许出现相同的key
function HUGE_SlotsMgr:pushFeatureStack(key)
    
    if #self.fstackList > 0 then
        for i, skey in ipairs(self.fstackList) do
            if skey == key then return end
        end
    else
        table.insert(self.fstackList, 1, key) -- 加入堆栈顶部
    end
end

-- 出栈 删除栈顶
function HUGE_SlotsMgr:delFeatureStack(key)

    if #self.fstackList > 0 then
        local idx = 1
        local skey = self.fstackList[idx]
        if skey == key then
            table.remove(self.stackList, idx)
        end
    end
end

-- 获取栈顶
function HUGE_SlotsMgr:curFeatureStack()

    if #self.fstackList > 0 then
        local idx = 1
        local skey = self.fstackList[idx]
        return skey
    end

    return nil
end

-- 清空
function HUGE_SlotsMgr:clearFeatureStack()
    self.fstackList = {} -- 初始化清空
end

-- 是否为空
function HUGE_SlotsMgr:isEmptyFeatureStack()
    local count = #self.fstackList
    if count == 0 then 
        return true
    else
        return false
    end
    return false
end
----------------------------------结束------------------------------------

----------------------------------btn spin按钮的回调------------------------------------

function HUGE_SlotsMgr:delegateBtnSpinAction(stype)

    if     stype == scfg.SPIN_BTN_TYPE.btn_spin then

        self.MachineLayerMgr:doAction()
        self.BottombarLayerMgr:refreshSpinBtnType(scfg.SPIN_BTN_TYPE.btn_stop, true)

    elseif stype == scfg.SPIN_BTN_TYPE.btn_stop then
        self.MachineLayerMgr:quickStopAction()
        self.BottombarLayerMgr:refreshSpinBtnType(scfg.SPIN_BTN_TYPE.btn_spin, false)

    elseif stype == scfg.SPIN_BTN_TYPE.btn_freespin then

    elseif stype == scfg.SPIN_BTN_TYPE.btn_auto then

    end
end

function HUGE_SlotsMgr:allStripEndStop()
    self.BottombarLayerMgr:refreshSpinBtnType(scfg.SPIN_BTN_TYPE.btn_spin, true)
end

----------------------------------build------------------------------------

-- 创建
function HUGE_SlotsMgr:build()

    --------------测试-------------

    -- local plistName = "res/Machine_JinGuQiMing/res/Machine_JinGuQiMing"
    -- display.loadSpriteFrames(string.format("%s.plist", plistName), string.format("%s.png", plistName))

    -- self:onUpdate(handler(self, self.upDate))

    self.MachineLayerMgr = HUGE_Machine_Layer_Mgr.new(self.DataMgr, self)
    self:addChild(self.MachineLayerMgr)

    self.BottombarLayerMgr = HUGE_Bottombar_Layer_Mgr.new(self)
    self:addChild(self.BottombarLayerMgr)
end

-- ----------------------------------测试------------------------------------
-- function HUGE_GameCtr:upDate(dt)
    

-- end

-- ----------------------------------build------------------------------------

-- -- 创建进入机台loading页面
-- function HUGE_GameCtr:build_loading()
--     -- 创建loading
--     -- 资源异步加载

--     --------------测试-------------
--     self:onUpdate(handler(self, self.upDate))

--     self.MachineLayerMgr = HUGE_Machine_Layer_Mgr.new()
--     self:addChild(self.MachineLayerMgr)
-- end

-- 创建进入机台管理类，每个机台有独立的管理类
function HUGE_SlotsMgr:build_mgr()
    local fullPath = string.format("machineSkin/%s/res/scripts/%_SlotsMgr", slotsName, slotsName)

    if not g_oHelperMgr:isScriptsFileExist(fullPath) then
        fullPath = "core.ctr.HUGE_Machine_Layer_Mgr"
    end

    self.slotsMgr = require(fullPath).new()
    self.slotsMgr:setCtrHander(self)
end

-- 创建机台的所有功能页面
function HUGE_SlotsMgr:build_slots()

    self:createBGMgr()
    self:createReelMgr()
    self:createTitleMgr()
    self:createAnimMgr()
    self:createTipsMgr()
    self:createExtMgr()
    self:createActivityMgr()
    self:createResultMgr()
end

-----------------------------------create-----------------------------------

-- 创建机台的背景
function HUGE_SlotsMgr:createBGMgr()
    local fullPath = string.format("machineSkin/%s/res/scripts/%_SlotsMgr", slotsName, slotsName)

    if not g_oHelperMgr:isScriptsFileExist(fullPath) then
        fullPath = "core.view.Slots_BGMgr"
    end

    local bgMgr = require(fullPath).new(self.slotsMgr)
    self:addChild(bgMgr, scfg.VIEW_ZORDER.BG_ORDER)

    self.slotsMgr:setBGMgrHander(bgMgr)
end

-- 创建机台的滚动层
function HUGE_SlotsMgr:createReelMgr()
end

-- 创建机台的顶部，jackpot或者收集功能层
function HUGE_SlotsMgr:createTitleMgr()
end

-- 创建机台的元素动画层
function HUGE_SlotsMgr:createAnimMgr()
end

-- 创建机台的真机提示层
function HUGE_SlotsMgr:createTipsMgr()
end

-- 创建机台的扩展交互
function HUGE_SlotsMgr:createExtMgr()
end

-- 创建机台的运营层
function HUGE_SlotsMgr:createActivityMgr()
end

-- 创建机台的结算、弹框、等公共层
function HUGE_SlotsMgr:createResultMgr()
end


---------------------------------ctr-------------------------------------
-- * 整个游戏的总控制器
function HUGE_SlotsMgr:doActionCtr(ctrType)
    if self.slotsCtrType == ctrType then return end

    self.slotsCtrType = ctrType

    if      slotsCtrType == scfg.SLOTS_CTR_TYPE.SLOTS_START then
        -- * spin按钮变为：spin不可点击
        -- * 检测是否是处于feature状态
            -- * 不是，则检测是否有足够的金币进行spin
                -- * 不足，则触发破产机制等，同时 回复spin按钮状态
                -- * 足够，则
                    -- * 改变上下导航条的状态
                    -- * 滚轴开始滚动
                    -- * 请求服务器消息，等待消息返回
            -- * 是，则
                -- * 滚轴开始滚动
                -- * 请求服务器消息，等待消息返回
        self:doCtrStart()
    elseif  slotsCtrType == scfg.SLOTS_CTR_TYPE.SLOTS_RESULT then
        -- * spin按钮变为：stop可点击，机制要求 第一列滚轴完全停止之后再改变该状态为可点
        -- * 数据返回、滚轴启动停止机制、检测关键列元素动画、wish等
            
            -- * 滚轴完全停止，spin按钮变为：spin不可点击   
                -- * 滚轴完全停止，检测是否中feature播放电话铃声、是否有合并动画、是否有搜集飞动画
        -- * 所有做完进行下一步
        self:doCtrResult()
    elseif  slotsCtrType == scfg.SLOTS_CTR_TYPE.SLOTS_BALANCE then
        -- * 开始结算，并播放不同元素的动画，全部中奖元素一起播，除了AKQJ109这些元素其余都是循环动画，一个时间周期之后开始播线
            
            -- * spin按钮变为：spin可点击，金币滚动未完成一旦提前点击，金币滚动立即结束，并进入下一个步

        -- * 结束完成进行下一步
        self:doCtrBalance()
    elseif  slotsCtrType == scfg.SLOTS_CTR_TYPE.SLOTS_END then
        -- * spin按钮变为：spin不可点击

        -- * 检测是否有新的feature，并启动feature模式
            -- * 检测是否处于feature过程，如果处于feature过程，则继续该SLOTS_START，不允许走到SLOTS_OVER
        -- （feature的删除工作由开发自己负责清理）

        self:doCtrEnd()
    elseif  slotsCtrType == scfg.SLOTS_CTR_TYPE.SLOTS_OVER then
        -- * 流程全部结束，清除所有堆栈
        -- * 流程全部结束，检测是否有达成的运营活动
            
            -- * 检测是否处于auto状态，无则spin按钮变为：spin可点击
        self:doCtrOver()
    end
end

function HUGE_SlotsMgr:doCtrStart()
end

function HUGE_SlotsMgr:doCtrResult()
end

function HUGE_SlotsMgr:doCtrBalance()
end

function HUGE_SlotsMgr:doCtrEnd()
end

function HUGE_SlotsMgr:doCtrOver()
end

return HUGE_SlotsMgr