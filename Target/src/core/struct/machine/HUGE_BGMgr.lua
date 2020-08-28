-- HUGE_BGMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台的背景，特殊动画，以及不同模式下切换背景等状态
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_BGMgr = class("HUGE_BGMgr", MachineLayer)


function HUGE_BGMgr:ctor(mgr)
	HUGE_BGMgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_BGMgr



