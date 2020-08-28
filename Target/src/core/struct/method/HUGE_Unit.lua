-- HUGE_Unit.lua
-- Author: Joker
-- Date: 2019-02-15 11:18:55
--

-- * 机台元素的基本数据结构

local scfg = require("core.ctr.HUGE_Config")

local HUGE_Unit = class("HUGE_Unit")


function HUGE_Unit:ctor()
	self.id = 0
	self.num = 1
	self.type = scfg.SLOTS_ELEMENT_TYPE.normal
	self.ami = {}
end

function HUGE_Unit:set(unit)
	self.id 		= unit.id
	self.num   		= unit.num
	self.type 		= unit.type

	self.ami = {}

	for i, v in ipairs(unit.ami) do
		table.insert(self.ami, v)
	end
end

function HUGE_Unit:isFeature()
	if 	self.type == scfg.SLOTS_ELEMENT_TYPE.scatter or 
		self.type == scfg.SLOTS_ELEMENT_TYPE.bonus or 
		self.type == scfg.SLOTS_ELEMENT_TYPE.scatterX or 
		self.type == scfg.SLOTS_ELEMENT_TYPE.scatterXX or 
		self.type == scfg.SLOTS_ELEMENT_TYPE.scatterXXX or 
		self.type == scfg.SLOTS_ELEMENT_TYPE.scatterXXXX then
		return true
	end
	return false
end

return HUGE_Unit