-- HUGE_Vtem.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

local scfg = require("core.ctr.HUGE_Config")
local HUGE_Unit = require("core.struct.method.HUGE_Unit")

-- 每个元素的静态图片，没有任何动画，只负责滚动

local HUGE_Vtem = class("HUGE_Vtem", function()
	local node = cc.Node:create()
	node:setAnchorPoint(cc.p(0.5, 0.5))
	return node
end)

local CURRENT_MODULE_NAME = ...

function HUGE_Vtem:ctor(unit, nWidth, nHeight) -- 每个元素单元格，都是同样的尺寸
	
	self.unit = HUGE_Unit.new()
	self.unit:set(unit)

	self.width  = nWidth
	self.height = nHeight

	-- 默认滚动资源索引，用于滚动时自动获取本地的默认滚轴数据
	self.defultIdx = 0

	-- 编号索引
	self.tagIdx = 0

	-- 单元格层级
	self.zOrder = 0

	-- self.underMultUnit = false 	-- 是否在 cell > 1 之下

	self.size_ = cc.size(self.width, self.height)
	self:setContentSize(self.size_)

	-- 元素
	self.icon = nil 

	self:loadItemIcon()
	self:setZOrder(0)
end

------------------------------接口--------------------------
function HUGE_Vtem:refreshItemIcon(unit)
	if unit == nil then
		-- error
	end
	if not unit or self.unit.id == unit.id then
		return
	end
	self.unit:set(unit)
	self:loadItemIcon()
end

function HUGE_Vtem:setTagIdx(idx)
	self.tagIdx = idx
end

function HUGE_Vtem:setZOrder(zord)

	local localZorder = self:iconZorder(self.unit.type) + self.zOrder + zord

	self:setLocalZOrder(localZorder)
end

function HUGE_Vtem:show(isVisible)
	if self.icon ~= nil then
		self.icon:setVisible(isVisible)
	end
end

------------------------------end--------------------------

function HUGE_Vtem:onCleanup()
end

function HUGE_Vtem:loadItemIcon()
	local name = self:iconName()
	if not self.icon then
		self.icon = ccui.ImageView:create()
		self.icon:setAnchorPoint(cc.p(0.5,0.5))
		self:addChild(self.icon, 1)
	end 
	
	self.icon:setPosition(self:iconPos())

	if self.icon and cc.SpriteFrameCache:getInstance():getSpriteFrame(name) then -- by eleven:检查当前plist中是否存在strPath纹理资源
       self.icon:loadTexture(name, 1)
    else
    	-- g_MachineUtil:slotsResourceRepairExceptionPlist(name)
    end
end

function HUGE_Vtem:iconName()
	return "slots_" .. self.unit.id .. ".png"
end

function HUGE_Vtem:iconPos()
	return cc.p(self.width*0.5, self.height*0.5) -- 不管是单格，还是多格元素，锚点都是单格元素的中心点
end

-- function HUGE_Vtem:collectWorldsPos()
-- 	return g_oHelperMgr:convertToWorldSpace(self.collectIcon)
-- end

-- function HUGE_Vtem:getSize()
-- 	return self.size_
-- end


--------------- 功能函数----------------------

function HUGE_Vtem:iconZorder(ntype, unitNum)
	if ntype == scfg.SLOTS_ELEMENT_TYPE.normal then

		return scfg.SLOTS_ELEMENT_ZORDER.normal

	elseif ntype == scfg.SLOTS_ELEMENT_TYPE.important then
		if unitNum and unitNum >= 2 then -- 多于2个格子的重要元素被认为特殊层级
			return scfg.SLOTS_ELEMENT_ZORDER.special
		end

		return scfg.SLOTS_ELEMENT_ZORDER.normal

	elseif ntype == scfg.SLOTS_ELEMENT_TYPE.wild then

		return scfg.SLOTS_ELEMENT_ZORDER.wild

	elseif ntype == scfg.SLOTS_ELEMENT_TYPE.bonus then

		return scfg.SLOTS_ELEMENT_ZORDER.bonus

	elseif ntype == scfg.SLOTS_ELEMENT_TYPE.scatter or 
		   ntype == scfg.SLOTS_ELEMENT_TYPE.scatterX or 
		   ntype == scfg.SLOTS_ELEMENT_TYPE.scatterXX or
		   ntype == scfg.SLOTS_ELEMENT_TYPE.scatterXXX or 
		   ntype == scfg.SLOTS_ELEMENT_TYPE.scatterXXXX then
		
		return scfg.SLOTS_ELEMENT_ZORDER.scatter

	end
	return 0
end
--------------- 收集活动icon end----------------------

return HUGE_Vtem

