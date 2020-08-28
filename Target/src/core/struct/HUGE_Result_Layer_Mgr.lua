-- HUGE_Result_Layer_Mgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 用与创建机台的bigwin，结算等各种弹框
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_Result_Layer_Mgr = class("HUGE_Result_Layer_Mgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)


function HUGE_Result_Layer_Mgr:ctor(mgr)
	HUGE_Result_Layer_Mgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_Result_Layer_Mgr



