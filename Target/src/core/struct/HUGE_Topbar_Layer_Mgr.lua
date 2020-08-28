-- HUGE_Topbar_Layer_Mgr.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

-- *
	-- 顶部工具条
-- *

-- local MachineLayer = require("machine.game.view.ui.MachineLayer")
local HUGE_Topbar_Layer_Mgr = class("HUGE_Topbar_Layer_Mgr", function() return cc.LayerColor:create(cc.c4b(0, 0, 0, 255)) end)


function HUGE_Topbar_Layer_Mgr:ctor(mgr)
	HUGE_Topbar_Layer_Mgr.super.ctor(self)

	self.slotsMgr = mgr
end

return HUGE_Topbar_Layer_Mgr



