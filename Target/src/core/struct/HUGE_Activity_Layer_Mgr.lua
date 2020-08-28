-- HUGE_Activity_Layer_Mgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台的运营活动管理
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_Activity_Layer_Mgr = class("HUGE_Activity_Layer_Mgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)


function HUGE_Activity_Layer_Mgr:ctor(mgr)
	HUGE_Activity_Layer_Mgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_Activity_Layer_Mgr



