-- HUGE_TipsMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台的 真机提示管理
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_TipsMgr = class("HUGE_TipsMgr", MachineLayer)


function HUGE_TipsMgr:ctor(mgr)
	HUGE_TipsMgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_TipsMgr



