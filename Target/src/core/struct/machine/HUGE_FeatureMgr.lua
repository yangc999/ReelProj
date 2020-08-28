-- HUGE_FeatureMgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 机台的feature处理管理
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_FeatureMgr = class("HUGE_FeatureMgr", MachineLayer)


function HUGE_FeatureMgr:ctor(mgr)
	HUGE_FeatureMgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_FeatureMgr



