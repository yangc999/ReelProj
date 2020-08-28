-- HUGE_Bottombar_Layer_Mgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 机台底部工具条
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
-- local HUGE_Bottombar_Layer_Mgr = class("HUGE_Bottombar_Layer_Mgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)

--  delegate 回调函数，用于btnspin的信息回调
 -- 1 delegateBtnSpinAction(sType)

local scfg = require("core.ctr.HUGE_Config")

local HUGE_Bottombar_Layer_Mgr = class("HUGE_Bottombar_Layer_Mgr", cc.Node)

-- 按钮的状态纹理资源
local BTN_SPIN_RES    = {
    "spin.png",              
    "spin_sel.png",      
    "spin_dis.png",      
    "stop.png",    
    "stop_dis.png",            
    "auto.png",          
    "auto_dis.png",        
    "freespin.png",       
    "freespin_dis.png",  
}

function HUGE_Bottombar_Layer_Mgr:ctor(gameView)
	-- HUGE_Bottombar_Layer_Mgr.super.ctor(self)
    self.touchIdx      = 0
	self.delegate     = gameView

    -- * spin 按钮的控制数据
    self.btnSpinType = scfg.SPIN_BTN_TYPE.btn_null
    self.btnSpinIsEnable  = true -- 是否可点击
    -- spin btn 的信息
    self.btnSpin_  = nil
    self.btnSpinLongTouch = nil
    
    

    self:createMenu()

    ---- test ---
    -- if not self.spinNode_ then
    --     self.spinNode_ = display.newNode():addTo(self):setPosition(0, 0)
    --     self.spinMenu_ = cc.Menu:create():addTo(self.spinNode_):setPosition(0, 0)
    --     -- 
    --     self.spinBtn_ = self:menuItemSprite(SPIN_BTN_RES[1], SPIN_BTN_RES[2], SPIN_BTN_RES[3], handler(self, self.onSpin))
    --         :addTo(self.spinMenu_)
    --         :setPosition(0, 0)
    -- end

    self.btnSpinType = scfg.SPIN_BTN_TYPE.btn_spin
end
-- 

-- -------------------btn spin 唯一对外暴露的接口函数-----------------------------------
-- * 用于刷新 按钮的状态
-- * btn spin也保留自我状态更新的功能，主要是 是否可点状态的更新维护，这样更及时
function HUGE_Bottombar_Layer_Mgr:refreshSpinBtnType(stype, enable)
    if self.btnSpinType == stype and self.btnSpinIsEnable == enable then 
        return
    end

    self.btnSpinType = stype
    self.btnSpinIsEnable = enable

    self:loadSpinBtnType(stype, enable)
end

function HUGE_Bottombar_Layer_Mgr:loadSpinBtnType(stype, enable)

    if     stype == scfg.SPIN_BTN_TYPE.btn_spin then
        if enable then
            self.btnSpin_:setSpriteFrame("spin.png")
        else
            self.btnSpin_:setSpriteFrame("spin_dis.png")
        end
    elseif stype == scfg.SPIN_BTN_TYPE.btn_stop then
        if enable then
            self.btnSpin_:setSpriteFrame("stop.png")
        else
            self.btnSpin_:setSpriteFrame("stop_dis.png")
        end
    elseif stype == scfg.SPIN_BTN_TYPE.btn_freespin then
        if enable then
            self.btnSpin_:setSpriteFrame("freespin.png")
        else
            self.btnSpin_:setSpriteFrame("freespin_dis.png")
        end
    elseif stype == scfg.SPIN_BTN_TYPE.btn_auto then
        if enable then
            self.btnSpin_:setSpriteFrame("auto.png")
        else
            self.btnSpin_:setSpriteFrame("auto_dis.png")
        end
    end
end

-----------------------------------------------------------

function HUGE_Bottombar_Layer_Mgr:createMenu()
    self.gameLayer_ = require("core.BaseLayer").new()
        :addTo(self)
        -- :setColor3b(cc.c3b(0x66, 0x66, 0x66))
        :setDelegate(handler(self, self.onTouchHandler_))
    -- -- 
    -- local spinParent    = self.gameLayer_
    local spinPos       = cc.p(display.width-100, display.cy-260)
    -- local spinZorder    = 10
    -- self.spinCtrl_  = require("core.ui.HUGE_SpineBtnCtrl").new(self, spinPos, spinZorder)
    --                     :setDelegate(handler(self, self.onSpinAction_))

    self.btnSpin_ = cc.Sprite:createWithSpriteFrameName("spin.png")

    self:addChild(self.btnSpin_)
    self.btnSpin_:setPosition(spinPos)
end
-- 
-- self.delegate("began", touch, event, isTouchSelf)
-- * 触发器
function HUGE_Bottombar_Layer_Mgr:onTouchHandler_(evtName, touch, event, isTouchSelf)

    if self.btnSpinIsEnable == false then return end

    if evtName == "began" then
        print("began")
        -- * 启动长按3秒启动 auto 机制
        -- * 只有spin按钮是 释放 才生效；stop和auto 是刚触摸就立即生效，这样效果更好
        if self.btnSpinIsEnable == true then
            if self.btnSpinType == scfg.SPIN_BTN_TYPE.btn_spin then
                -- * 启动 长按计时器，0.5秒之后开启 长按特殊效果用于提示玩家即将auto

                self.btnSpin_:setSpriteFrame("spin_sel.png")

            elseif self.btnSpinType == scfg.SPIN_BTN_TYPE.btn_stop then
                -- * 快速停止行为，意味着让滚轴快速停止，到达结算

                self:btnSpinAction(self.btnSpinType)
            elseif self.btnSpinType == scfg.SPIN_BTN_TYPE.btn_freespin then
                -- * feature时候 可快速进入下一步的行为；主要用在有步骤的feature，比如freespin、也可以根据特殊需要一直为不可点状态
                
                self:btnSpinAction(self.btnSpinType)
            elseif self.btnSpinType == scfg.SPIN_BTN_TYPE.btn_auto then
                -- * 停止auto状态的行为

                self:btnSpinAction(self.btnSpinType)
            end
        end
    elseif evtName == "moved" then
        -- print("moved")
    elseif evtName == "ended" or evtName == "cancelled" then
        print("ended")
        -- * spin按钮是否点击在这里进行判断
        if self.btnSpinIsEnable == true and self.btnSpinType == scfg.SPIN_BTN_TYPE.btn_spin then
            -- * 停止 长按计时器 判断是否为auto，否则为正常spin

            self:btnSpinAction(self.btnSpinType)
        else
            -- * 取消掉定时器
        end
    -- self:onSpinAction_()
    end
end

function HUGE_Bottombar_Layer_Mgr:btnSpinAction(stype)

    self.btnSpinIsEnable = false

    -- * 按钮声音等....
    if     stype == scfg.SPIN_BTN_TYPE.btn_spin then

    elseif stype == scfg.SPIN_BTN_TYPE.btn_stop then

    elseif stype == scfg.SPIN_BTN_TYPE.btn_freespin then

    elseif stype == scfg.SPIN_BTN_TYPE.btn_auto then

    end

    self:loadSpinBtnType(stype, self.btnSpinIsEnable)

    if self.delegate.delegateBtnSpinAction then 
        self.delegate:delegateBtnSpinAction(self.btnSpinType)
    end
end
-- 
-- function HUGE_Bottombar_Layer_Mgr:onSpinAction_(sender, event)
--     -- self:runAction(cc.Sequence:create(
--     --     cc.DelayTime:create(0), 
--     --     cc.CallFunc:create(handler(self, self.doAction)),
--     --     cc.DelayTime:create(1.2), 
--     --     cc.CallFunc:create(handler(self, self.stopAction))
--     --     ))

--         self.touchIdx = self.touchIdx  + 1
--         if self.touchIdx%2 == 1 then
--             self.GameView.MachineLayerMgr:doAction()
--         else
--             self.GameView.MachineLayerMgr:stopAction()
--         end
--     -- self.ReelMgr:refreshWishModel()
-- end

return HUGE_Bottombar_Layer_Mgr



