-- HUGE_VtemAmi.lua
-- Author: Joker
-- Date: 2020-02-03 11:40:32
--

local scfg = require("core.ctr.HUGE_Config")
local HUGE_Unit = require("core.struct.method.HUGE_Unit")

-- 每个元素的动画管理，没有滚动，只是原地播放

local HUGE_VtemAmi = class("HUGE_VtemAmi", function()
	local node = cc.Node:create()
	node:setAnchorPoint(cc.p(0.5, 0.5))
	return node
end)

-- local CURRENT_MODULE_NAME = ...

function HUGE_VtemAmi:ctor(unit, nWidth, nHeight)
	
	self.unit = HUGE_Unit.new()
	self.unit:set(unit)

	self.width  = nWidth
	self.height = nHeight

	self.showTag = -1
	-- 行列编号索引
	self.colIdx = -1
	self.rowIdx = -1
	
	-- 单元格层级
	self.zOrder = 0

	self.size_ = cc.size(self.width, self.height)
	self:setContentSize(self.size_)

	-- spine
	self.rootNode = nil 
	self.ami 	  = nil 
	self.isAming = false -- 临时

	self.hasAmi = true   -- 是否有 动画文件，true:有动画文件，比如spine，false:只有一个静态文件
	-- 收集
	self.collectIcon = nil

	if #self.unit.ami == 0 then
		self.hasAmi = false
	end

	self:loadAmi()
	self:clearAmiState()
	-- self:setZOrder(0)
end

function HUGE_VtemAmi:onCleanup()
	if self.ami then
		self.ami:removeFromParent()
		self.ami:release()
		self.ami = nil
	end
end

------------------------------接口--------------------------
function HUGE_VtemAmi:playAnimation(isForever, sAmi)   -- 
	if self.isAming == true then return end

	self.isAming = true

	self:stopAmin()

	-- self:setZOrder(1000)
	
	if self.ami then
		for i,v in ipairs(self.unit.ami) do
			if v == sAmi then
				self.ami:setAnimation(0, sAmi, isForever)
				break
			end
		end
	end
end

function HUGE_VtemAmi:setRC(col, row)
	self.colIdx = col
	self.rowIdx = row
end

function HUGE_VtemAmi:clearAmiState()
	self.colIdx = -1
	self.rowIdx = -1
	self.showTag = -1
	self.isAming = false
end

function HUGE_VtemAmi:getId()
	return self.unit.id
end

function HUGE_VtemAmi:setZOrder(zord)

	local localZorder = self:iconZorder(self.unit.type) + self.zOrder + zord

	self:setLocalZOrder(localZorder)
end

function HUGE_VtemAmi:show(isVisible)
	if self.rootNode ~= nil then
		self.rootNode:setVisible(isVisible)
	end
end

function HUGE_VtemAmi:stopAmin()
	if self.ami then
		self.ami:stopAllActions()
	end
	-- self:setZOrder(0)
end
------------------------------end--------------------------

function HUGE_VtemAmi:loadAmi()
	if not self.rootNode then
		self.rootNode = cc.Node:create()
		self.rootNode:setAnchorPoint(cc.p(0.5,0.5))
		self:addChild(self.rootNode)
	end 
	
	if self.hasAmi == true then
		local path = self:amiPath()
		-- self.ami  = g_tData.MachineData:getSpineByFile(path)
		self.ami = sp.SkeletonAnimation:create(path .. ".json", path .. ".atlas")

		if self.ami ~= nil then
			self.ami:registerSpineEventHandler(handler(self, self.onSpineAnimationEnd), sp.EventType.ANIMATION_END)
		    self.ami:setAnchorPoint(cc.p(0.5, 0.5))
		    self.ami:setPosition(self:amiPos())
		    self.rootNode:addChild(self.ami)
		end
	else
		local path = self:imageName()
		if not self.ami then
			self.ami = ccui.ImageView:create()
			self.ami:setAnchorPoint(cc.p(0.5,0.5))
			self:addChild(self.ami, 1)
		end 
		
		self.ami:setPosition(self:amiPos())

		-- if self.ami and cc.SpriteFrameCache:getInstance():getSpriteFrame(name) then -- by eleven:检查当前plist中是否存在strPath纹理资源
	 --       self.ami:loadTexture(name, 1)
	 --    else
	 --    	-- g_MachineUtil:slotsResourceRepairExceptionPlist(name)
	 --    end
	end
end

function HUGE_VtemAmi:amiPath()
	return  "res/Machine_JinGuQiMing" .. string.format("/res/spine/slots_%d",self.unit.id)
end

function HUGE_VtemAmi:imageName()
	return "slots_" .. self.unit.id .. ".png"
end

function HUGE_VtemAmi:amiPos()
	return cc.p(self.width*0.5, self.height*0.5) -- 不管是单格，还是多格元素，锚点都是单格元素的中心点
end

function HUGE_VtemAmi:onSpineAnimationEnd(event)
	-- self:setZOrder(0)
end

--------------- 功能函数----------------------

function HUGE_VtemAmi:iconZorder(ntype, unitNum)
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
--------------- 收集活动icon start----------------------
-- function MachineItem:createCollectIcon()
-- 	if not self.collectIcon then
-- 		self.collectIcon = display.newSprite():addTo(self, scfg.ICON_ZORD.COLLECT):hide()
-- 	end 
-- end

-- function MachineItem:showCollectIcon(strPath, sz)
-- 	if self.collectIcon then
-- 		self.collectIcon:setSpriteFrame(strPath)
-- 		if not sz then
-- 			sz = self.collectIcon:getContentSize()
-- 		end
-- 		-- 
-- 		local spos = self:getSlotsPos(self.slots.itemCount)
-- 		spos.x = spos.x + (self.width-sz.width)*0.5
-- 		spos.y = spos.y - (self.height-sz.height)*0.5
-- 		self.collectIcon:setPosition(spos)
-- 		self.collectIcon:setVisible(true)
-- 	end
-- end

-- function MachineItem:hideCollectIcon()
-- 	self.collectIcon:setVisible(false)
-- end

-- function MachineItem:getCollectWorldsPos()
-- 	return g_oHelperMgr:convertToWorldSpace(self.collectIcon)
-- end

-- function MachineItem:getSize()
-- 	return self.size_
-- end


--------------- 收集活动icon end----------------------

return HUGE_VtemAmi

