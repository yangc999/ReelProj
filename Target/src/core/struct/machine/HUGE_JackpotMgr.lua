-- HUGE_JackpotMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台的顶部jackpot，或者收集之类的管理
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_JackpotMgr = class("HUGE_JackpotMgr", MachineLayer)


function HUGE_JackpotMgr:ctor(mgr)
	HUGE_JackpotMgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_JackpotMgr



