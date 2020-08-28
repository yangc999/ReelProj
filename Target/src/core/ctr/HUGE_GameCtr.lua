
--
-- HUGE_GameCtr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--
-- GameCtr 机台的入口场景类，该类不允许继承；管理的类如下：

    -- * HUGE_SlotsMgr              -- 机台
    -- * HUGE_DataMgr               -- 机台独立数据

    -- * 进入机台采用 进入过程中下载的方式

    -- * 负责：通用加载、网络、消息通讯、机台下载、资源预加载等


local scfg = require("core.ctr.HUGE_Config")

-- local HUGE_Machine_Layer_Mgr = require("core.struct.HUGE_Machine_Layer_Mgr")

local HUGE_SlotsMgr = require("core.struct.HUGE_SlotsMgr")
local HUGE_DataMgr = require("core.struct.HUGE_DataMgr")


local HUGE_GameCtr = class("HUGE_GameCtr", function()
    return display.newScene("HUGE_GameCtr")
end)

function HUGE_GameCtr:ctor()
	-- HUGE_GameCtr.super.onInit(self)
    
    self.slotsMgr	 	= nil  -- 机台
    self.dataMgr        = nil  -- 数据

    --------------测试-------------
    -- 临时
    self.dataMgr = HUGE_DataMgr.new()

    local plistName = "res/Machine_JinGuQiMing/res/Machine_JinGuQiMing"
    display.loadSpriteFrames(string.format("%s.plist", plistName), string.format("%s.png", plistName))

    display.loadSpriteFrames("res/spinbtn.plist", "res/spinbtn.png")

    self:onUpdate(handler(self, self.upDate))

    self:build()
end

function HUGE_GameCtr:onEnter()
end


function HUGE_GameCtr:onExit()
end


function HUGE_GameCtr:onCleanUp()
end

----------------------------------测试------------------------------------
function HUGE_GameCtr:upDate(dt)
    
    if self.slotsMgr ~= nil then
        self.slotsMgr:upDate(dt)
    end

end

----------------------------------build------------------------------------

-- 创建slots
function HUGE_GameCtr:build()
    
    self.slotsMgr = HUGE_SlotsMgr.new(self, self.dataMgr)
    self:addChild(self.slotsMgr)

end


return HUGE_GameCtr