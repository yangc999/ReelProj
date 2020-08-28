
--

-- * 滚轴数据驱动的 单个数据单元
-- * 名称解释：Drive驱动，Gear齿轮，基础数据单元相当于轴承上的齿轮，转动驱动皮带

local HUGE_Drive_Gear = class("HUGE_Drive_Gear", cc.Node)

function HUGE_Drive_Gear:ctor()
	self:init()
end

function HUGE_Drive_Gear:init()
	self.hoc_tag	 	= 0  	-- 标记一个最小单元格序号
	self.hoc_with 		= 0     -- 标记一个最小单元宽度
	self.hoc_height 	= 0		-- 标记一个最小单元高度
	self.hoc_maxLink 		= 1		-- 标记一个本单元格的个数
	self.hoc_posx 		= 0		-- 标记一个本单元格的x位置
	self.hoc_posy 		= 0		-- 标记一个本单元格的y位置
	self.hoc_zorder 	= 0		-- 标记一个本单元格的层级
	self.hoc_row 		= 0		-- 标记一个本单元格的横序号
	self.hoc_col 		= 0		-- 标记一个本单元格的竖序号

end

return HUGE_Drive_Gear