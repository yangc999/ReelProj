
--
-- * 一个轴承，齿轮附着其上，处理如何滚动，如何停止；一个轴承跟对应的滚轴区域是一致的，尤其是位置信息！
-- * 名词解释：轴承Bearing

local sConf = require("core.struct.drive.HUGE_Drive_Config")
local sGear = require("core.struct.drive.HUGE_Drive_Gear")

local HUGE_Drive_Bearing = class("HUGE_Drive_Bearing", cc.Node)


--  delegate 回调函数，用于更新上层的数据信息

 -- 1 stripMove(self.hoc_idx, list<HUGE_Cell>)
 -- 2 stripBegStop(self.hoc_idx, self.hoc_stopTag, showList)
 ---3 stripNearStop(self.hoc_idx)
 ---4 stripEndStop(self.hoc_idx)
 
 -- * 关键字说明：
 	-- * show 为在不同模式下用于显示控制的数据，var为可变变量，wish 为扩展型数据，view 为整个普通模式视图数据，不包括扩展类型

function HUGE_Drive_Bearing:ctor(delegate)

	self.delegate = delegate

	----------------------初始化轴承数据------------------------
	
	self.hoc_ViewType = 0				-- 呈现类型 上对齐，中对齐，下对齐
	self.hoc_idx = 0					-- 当前一条轴承的索引,1开头，就是第一条滚轴，1，2，3，4，5等

	self.hoc_ShowVarGearN = 0			-- 当前一条轴承的实际显示齿轮个数（可动态调整）
	self.hoc_WishGearN = 0				-- 当前一条轴承的预期创建的齿轮个数（不可动态调整,比如：普通显示3个，特殊时候向上多显示2个，则为：5）
		-- * 当前一条轴承的最终创建的齿轮个数（考虑格子高度，一般比预期多创建 2*wish+2*maxLink 个）
	self.hoc_FinalGearN = 0	

	self.hoc_ViewShowColMaxGearN = 0		-- 整个版面(所有轴承中、普通模式下)的轴承的齿轮最大个数，比如每列个数 2，3，4，3，2 最大的是4个元素
	self.hoc_lineWidth = 0					-- 表示当前滚轴的分割线的宽度

	self.hoc_ViewMaxLinkGearN = 0			-- 表示一个齿轮最大的格数，比如 有些元素是2格或者是3格

	self.hoc_height = 0					-- 表示一个普通格子的高度
	self.hoc_width = 0					-- 表示一个普通格子的宽度
	

	----------------------运行数据------------------------

	self.hoc_ShowVarStopTop = 0   			-- 视图按照左下角为(0,0)，这里是当前滚轴的停止位置，根据这个位置开始指定定停止的标记号
	self.hoc_ShowVarStopBottom = 0   		-- 视图按照左下角为(0,0)，这里是当前滚轴的停止位置，根据这个位置开始停止动作
	self.hoc_WishTop = 0					-- 视图的最高点: 显示个数高度+超出一个最大格数 的高度
	self.hoc_WishBottom = 0					-- 视图的最低点: 0点以下的一个最大格数 的高度

	self.hoc_delayTime 	= 0				-- 计算该滚轴开始滚动的延迟时间，比如后一个比前一个延迟多少，同时滚动设置为0
	self.hoc_moveTime  	= 0				-- 计算该滚轴的运动时间，越向后的滚轴运动时间越长，这样梯度停止

	-- * 向下缓动
	self.hoc_stopDownTime	= 0			-- 计算该滚轴的停止时间，每个滚轴的停止时间一样
	self.hoc_stopDownDis 	= 0
	self.hoc_stopDownDisAdd 	= 0
	self.hoc_mathDown 		= 1
	self.hoc_pReleaseStopDownTime 	= 0     -- 动态变量

	-- * 向上缓动
	self.hoc_stopUpTime		= 0				-- 计算该滚轴的停止时间，每个滚轴的停止时间一样
	self.hoc_stopUpDis   	= 0
	self.hoc_mathUp 		= 1
	self.hoc_pReleaseStopUpTime 	= 0     -- 动态变量

	self.hoc_pReleaseDelayTime 	= 0     -- 动态变量
	self.hoc_pReleaseMoveTime 	= 0     -- 动态变量
	
	----------------------外部控制数据------------------------

	self.hoc_autoStop 		= true		-- 是否自动停止模式
	self.hoc_userStop 		= false		-- 是否用户手动停止
	self.hoc_msgBack 		= false		-- 是否数据是否返回
	self.hoc_beforeBearingStop = false		-- 前一个齿轮是否停止
	self.hoc_turbo 			= false		-- 是否处于加速模式



	----------------------缓动数据------------------------

	self.hoc_bearingType = sConf.HOC_BEARING_TYPE.HOC_OVER

	self.hoc_stopTopGear = nil
	self.hoc_stopCenterGear = nil
	self.hoc_stopBottomGear = nil

	self.hoc_stopTag = 0
	self.hoc_dis = 0

	----------------------数据------------------------

	self.hoc_gearList = {}

	self.centerX = 0
	self.centerY = 0

end
----------------------数据初始化接口函数------------------------

-- 第一个被调用 用于初始化一个轴承的基础数据，
function HUGE_Drive_Bearing:initDearingData(viewType, idx, showGearN, wishGearN, viewShowColMaxGearN, viewMaxLinkGearN, width, height)
	
	----------------------初始化轴承数据------------------------
	
	-- self.hoc_ViewType = 0				-- 呈现类型 上对齐，中对齐，下对齐
	-- self.hoc_idx = 0					-- 当前一条轴承的索引,1开头，就是第一条滚轴，1，2，3，4，5等

	-- self.hoc_ShowVarGearN = 0			-- 当前一条轴承的实际显示齿轮个数（可动态调整）
	-- self.hoc_WishGearN = 0		-- 当前一条轴承的预期创建的齿轮个数（不可动态调整,比如：普通显示3个，特殊时候向上多显示2个，则为：5）
	-- 	-- * 该数据可通过规则计算，不需要初始化
	-- 	self.hoc_FinalGearN = 0		-- 当前一条轴承的最终创建的齿轮个数（考虑格子高度，一般比预期多创建2个）

	-- self.hoc_ViewShowColMaxGearN = 0		-- 整个版面(所有轴承中、普通模式下)的轴承的齿轮最大个数，比如每列个数 2，3，4，3，2 最大的是4个元素
	-- self.hoc_lineWidth = 0			-- 表示版面的分割线的宽度

	-- self.hoc_ViewMaxLinkGearN = 0			-- 表示一个齿轮最大的格数，比如 有些元素是2格或者是3格
	-- self.hoc_height = 0					-- 表示一个普通格子的高度
	-- self.hoc_width = 0					-- 表示一个普通格子的宽度

	self.hoc_ViewType 				= viewType
	self.hoc_idx 					= idx
	self.hoc_ShowVarGearN 			= showGearN
	self.hoc_WishGearN 				= wishGearN

	self.hoc_ViewShowColMaxGearN 		= viewShowColMaxGearN
	self.hoc_ViewMaxLinkGearN 			= viewMaxLinkGearN
	self.hoc_height 				= height
	self.hoc_width 					= width
	-- * 计算
	self.hoc_FinalGearN = self.hoc_WishGearN*2 + self.hoc_ViewMaxLinkGearN*2
	

	if self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_CENTER then -- center

		self.hoc_ShowVarStopBottom 	= (self.hoc_ViewShowColMaxGearN - self.hoc_ShowVarGearN)*self.hoc_height*0.5 + self.hoc_height*0.5
		self.hoc_ShowVarStopTop 	= (self.hoc_ViewShowColMaxGearN - self.hoc_ShowVarGearN)*self.hoc_height*0.5 + self.hoc_height*0.5 + (self.hoc_ShowVarGearN - 1)*self.hoc_height

		self.hoc_WishBottom = (self.hoc_ViewShowColMaxGearN - self.hoc_WishGearN)*self.hoc_height*0.5 - (self.hoc_ViewMaxLinkGearN)*self.hoc_height
		self.hoc_WishTop 	= (self.hoc_ViewShowColMaxGearN - self.hoc_WishGearN)*self.hoc_height*0.5 + (self.hoc_FinalGearN - self.hoc_ViewMaxLinkGearN)*self.hoc_height 

	elseif self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_TOP then  -- top

		self.hoc_ShowVarStopBottom 	= (self.hoc_ViewShowColMaxGearN)*self.hoc_height - self.hoc_height*0.5 - (self.hoc_ShowVarGearN - 1)*self.hoc_height
		self.hoc_ShowVarStopTop 	= (self.hoc_ViewShowColMaxGearN)*self.hoc_height - self.hoc_height*0.5

		self.hoc_WishBottom = (self.hoc_ViewShowColMaxGearN + self.hoc_ViewMaxLinkGearN)*self.hoc_height - (self.hoc_FinalGearN)*self.hoc_height
		self.hoc_WishTop  	= (self.hoc_ViewShowColMaxGearN + 1)*self.hoc_height

	elseif self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_BOTTOM then  -- bottom

		self.hoc_ShowVarStopBottom 	= self.hoc_height*0.5
		self.hoc_ShowVarStopTop 	= self.hoc_height*0.5 + (self.hoc_ShowVarGearN - 1)*self.hoc_height

		self.hoc_WishBottom = - (self.hoc_ViewMaxLinkGearN)*self.hoc_height
		self.hoc_WishTop 	= (self.hoc_FinalGearN - self.hoc_ViewMaxLinkGearN)*self.hoc_height
		
	end

	self.hoc_delayTime 	= (self.hoc_idx - 1)*sConf.HOC_AMI.hoc_delayTime
	self.hoc_moveTime  	= sConf.HOC_AMI.hoc_time + (self.hoc_idx - 1)*sConf.HOC_AMI.hoc_gapTime

	self.hoc_pReleaseDelayTime 	= self.hoc_delayTime
	self.hoc_pReleaseMoveTime 	= self.hoc_moveTime
	
	self:resetTime()

	self:createGear()

end

-- 第二个被调用 用于校正滚轴元素的X轴位置，比如第3列，应该偏移2列宽度+线宽；否则滚轴元素都是按起点来计算
function HUGE_Drive_Bearing:initPosAndZorder(colIdx, viewLineWidth)
	self.hoc_lineWidth = viewLineWidth

	for i,cell in ipairs(self.hoc_gearList) do
		cell.hoc_posx 	= cell.hoc_posx + (colIdx - 1)*self.hoc_width + (colIdx - 1)*viewLineWidth
		cell.hoc_zorder = cell.hoc_zorder + (colIdx - 1)*(self.hoc_WishGearN + 2*self.hoc_ViewMaxLinkGearN)

		self.centerX = cell.hoc_posx
	end
end

----------------------数据获取接口函数------------------------

-- 第三个被调用 用来获取滚轴格子的初始化数据信息，比如校正格子x,y等等的信息
function HUGE_Drive_Bearing:bearingList()
	return self.hoc_gearList
end
-- 第四个被调用 用来获取一条滚轴的中心点位置
function HUGE_Drive_Bearing:centerPos()
	local center = {}
	center.x = self.centerX
	center.y = self.centerY
	return center
end
----------------------控制接口函数------------------------
function HUGE_Drive_Bearing:doAction()
	self:resetData()

	if self.hoc_idx == 1 then
		self:beforeBearingStopAction(true)
	else
		self:beforeBearingStopAction(false)
	end
	self.hoc_bearingType = sConf.HOC_BEARING_TYPE.HOC_SPIN
end

function HUGE_Drive_Bearing:stopAction()
	self:resetTime()

	-- self:beforeBearingStopAction(true)
	self.hoc_msgBack = true
	self.hoc_bearingType = sConf.HOC_BEARING_TYPE.HOC_SPIN
end

function HUGE_Drive_Bearing:beforeBearingStopAction(isStop)
	self.hoc_beforeBearingStop = isStop
end

function HUGE_Drive_Bearing:quickStopAction()
	self:turboModel(false)

	self.hoc_msgBack = true
	self:beforeBearingStopAction(true)
	self.hoc_pReleaseMoveTime = 0
	self.hoc_userStop = true
end

function HUGE_Drive_Bearing:turboModel(isTurbo)
	self.hoc_turbo = isTurbo

	self.hoc_dis = sConf.HOC_AMI.hoc_speed

	if self.hoc_turbo == true then
		self.hoc_dis = sConf.HOC_AMI.hoc_super

		if self.hoc_pReleaseMoveTime < 0 then
			self.hoc_pReleaseMoveTime = sConf.HOC_AMI.hoc_superAddTime
		else
			self.hoc_pReleaseMoveTime = self.hoc_pReleaseMoveTime + sConf.HOC_AMI.hoc_superAddTime
		end
	end

end

function HUGE_Drive_Bearing:refreshShowGear(showGear)
	self.hoc_ShowVarGearN = showGear

	if self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_CENTER then -- center

		self.hoc_ShowVarStopBottom 	= (self.hoc_ViewShowColMaxGearN - self.hoc_ShowVarGearN)*self.hoc_height*0.5 + self.hoc_height*0.5
		self.hoc_ShowVarStopTop 	= (self.hoc_ViewShowColMaxGearN - self.hoc_ShowVarGearN)*self.hoc_height*0.5 + self.hoc_height*0.5 + (self.hoc_ShowVarGearN - 1)*self.hoc_height

	elseif self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_TOP then  -- top

		self.hoc_ShowVarStopBottom 	= (self.hoc_ViewShowColMaxGearN)*self.hoc_height - self.hoc_height*0.5 - (self.hoc_ShowVarGearN - 1)*self.hoc_height
		self.hoc_ShowVarStopTop 	= (self.hoc_ViewShowColMaxGearN)*self.hoc_height - self.hoc_height*0.5

	elseif self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_BOTTOM then  -- bottom

		self.hoc_ShowVarStopBottom 	= self.hoc_height*0.5
		self.hoc_ShowVarStopTop 	= self.hoc_height*0.5 + (self.hoc_ShowVarGearN - 1)*self.hoc_height
		
	end
end


----------------------功能函数------------------------
function HUGE_Drive_Bearing:resetData()

	self:resetTime()

	self.hoc_msgBack 		= false		-- 是否数据是否返回
	self.hoc_beforeBearingStop = false		-- 是否前一列滚轴是否停止

	self.hoc_autoStop 		= true		-- 是否自动停止模式
	self.hoc_userStop 		= false		-- 是否用户手动停止
	
	self.hoc_turbo 			= false		-- 是否处于加速模式

	self.hoc_stopTag 		= 0
	self.hoc_dis 			= 0
end

-- 这里说明一下，cell是从上往下排列的,1行，2行，，，5行
function HUGE_Drive_Bearing:createGear()
	local finalGearN = self.hoc_FinalGearN
	for i=1,finalGearN do
		local gear = sGear.new()
		gear.hoc_tag	 	= i  							-- 标记一个最小单元格序号
		gear.hoc_with 		= self.hoc_width     		-- 标记一个最小单元宽度
		gear.hoc_height 	= self.hoc_height			-- 标记一个最小单元高度
		gear.hoc_maxLink 		= 1								-- 标记一个本单元格的个数
		gear.hoc_posx 		= self.hoc_width*0.5		-- 标记一个本单元格的x位置
		gear.hoc_posy 		= self:gearY(finalGearN, i)		-- 标记一个本单元格的y位置
		gear.hoc_zorder 	= i -- + (self.hoc_idx - 1)*self.hoc_ViewShowColMaxGearN	-- 标记一个本单元格的层级
		gear.hoc_row 		= i								-- 标记一个本单元格的横序号
		gear.hoc_col 		= self.hoc_idx				-- 标记一个本单元格的竖序号

		self:addChild(gear)
		table.insert(self.hoc_gearList, gear)
	end

	self.centerY = self.hoc_ShowVarGearN*0.5*self.hoc_height
end

function HUGE_Drive_Bearing:resetTime()

	self.hoc_stopDownTime	= sConf.HOC_AMI.hoc_stopDownTime
	self.hoc_stopDownDis 	= 0
	self.hoc_stopDownDisAdd = 0
	self.hoc_mathDown 		= 1
	self.hoc_pReleaseStopDownTime 	= self.hoc_stopDownTime

	self.hoc_stopUpTime		= sConf.HOC_AMI.hoc_stopUpTime
	self.hoc_stopUpDis   	= 0
	self.hoc_mathUp 		= 1
	self.hoc_pReleaseStopUpTime 	= self.hoc_stopUpTime


	-- self.hoc_pReleaseDelayTime = self.hoc_delayTime
	self.hoc_pReleaseMoveTime  = self.hoc_moveTime
end

function HUGE_Drive_Bearing:gearY(finalGearN, row)

	local posY = (finalGearN - row - self.hoc_ViewMaxLinkGearN)*self.hoc_height + self.hoc_height*0.5
	
	if self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_CENTER then

		posY = posY + (self.hoc_ViewShowColMaxGearN - self.hoc_WishGearN)*self.hoc_height*0.5

	elseif self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_TOP then  -- top

		posY = (self.hoc_ViewShowColMaxGearN + self.hoc_ViewMaxLinkGearN - row)*self.hoc_height + self.hoc_height*0.5

	elseif self.hoc_ViewType == sConf.HOC_VIEWTYPE.HOC_BOTTOM then  -- bottom

	end

	return posY
end

function HUGE_Drive_Bearing:upDate(deltaTime)

	if self.hoc_bearingType == sConf.HOC_BEARING_TYPE.HOC_OVER then 
		return 
	end

	self.hoc_pReleaseDelayTime = self.hoc_pReleaseDelayTime - deltaTime

	if self.hoc_pReleaseDelayTime > 0 then 
		self.hoc_pReleaseDelayTime = self.hoc_pReleaseDelayTime - deltaTime
		return
	end

	self.hoc_pReleaseMoveTime = self.hoc_pReleaseMoveTime - deltaTime

	if self.hoc_pReleaseMoveTime > 0 and self.hoc_bearingType == sConf.HOC_BEARING_TYPE.HOC_SPIN then
		self:move()
	elseif self.hoc_msgBack == false then
		self:move()
	elseif self.hoc_beforeBearingStop == false then
		self:move()
	else
		if self.hoc_bearingType == sConf.HOC_BEARING_TYPE.HOC_SPIN then
			self:willStop()
		end

		if self.hoc_bearingType == sConf.HOC_BEARING_TYPE.HOC_WILL then
			self:begStop()
			return
		end 

		if self.hoc_bearingType == sConf.HOC_BEARING_TYPE.HOC_STOP then
			self:doStop(deltaTime)
		end 
	end
end

function HUGE_Drive_Bearing:move()
	self.hoc_dis = sConf.HOC_AMI.hoc_speed

	if self.hoc_turbo == true then
		self.hoc_dis = sConf.HOC_AMI.hoc_super
	end

	self:moveList(self.hoc_dis)
end

function HUGE_Drive_Bearing:willStop()

	self.hoc_bearingType = sConf.HOC_BEARING_TYPE.HOC_WILL

	local wishTop = self.hoc_WishTop -- 查找停止的规则，最接近上面停止位置规则

	for i,cell in ipairs(self.hoc_gearList) do

		if cell.hoc_posy > (self.hoc_ShowVarStopTop) and cell.hoc_posy < wishTop then
			wishTop = cell.hoc_posy
			self.hoc_stopTag = cell.hoc_tag
			self.hoc_stopTopGear 	= cell
			self.hoc_stopCenterGear = cell
			self.hoc_stopBottomGear = cell
		end
	end
end

function HUGE_Drive_Bearing:begStop()
	local isStop = false
	local subDis = 0

	if self.hoc_stopTopGear ~= nil then
		
		-- if (self.hoc_stopTopGear.hoc_posy - self.hoc_ShowVarStopTop) <= self.hoc_dis then
			isStop = true

			subDis = self.hoc_stopTopGear.hoc_posy - self.hoc_ShowVarStopTop

			self.hoc_stopDownDis = self.hoc_height*sConf.HOC_AMI.hoc_downParameter + (self.hoc_ShowVarGearN - 1)*self.hoc_height
			self.hoc_stopUpDis   = self.hoc_height*sConf.HOC_AMI.hoc_upParameter

			self.hoc_bearingType = sConf.HOC_BEARING_TYPE.HOC_STOP -- 停止步骤
			self.hoc_stopTopGear = nil

			-- print("begStop" ,self.hoc_idx, self.hoc_dis, subDis)
		-- end
	end

	if isStop == false then
		self:moveList(self.hoc_dis) -- 这里基本不会走到
		-- print("error:" ,self.hoc_idx, self.hoc_dis)
	else
		self:moveList(subDis)  -- 基本可以肯定，必须要走到这里
		-- print("ok------------" ,self.hoc_idx, self.hoc_stopCenterGear.hoc_posy, subDis)
		if self.delegate then
			
			local showList = {}

			for i=1,self.hoc_ShowVarGearN do
				local tag = (self.hoc_stopTag - i + 1 + self.hoc_FinalGearN)%(self.hoc_FinalGearN)
				if tag == 0 then
					tag = self.hoc_FinalGearN
				end
				
				table.insert(showList, 1, tag) -- 正序
			end
			self.delegate:stripBegStop(self.hoc_idx, self.hoc_stopTag, showList)
		end
	end
end

function HUGE_Drive_Bearing:doStop(time)
	if self.hoc_bearingType == sConf.HOC_BEARING_TYPE.HOC_OVER then return end

	-- if self.hoc_userStop == true then
	-- 	time = time*1.5
	-- end
	-- 向下缓动
	if self.hoc_pReleaseStopDownTime > 0 then
		self.hoc_pReleaseStopDownTime = self.hoc_pReleaseStopDownTime - time

		if self.hoc_pReleaseStopDownTime <= 0 then
			self.hoc_pReleaseStopDownTime = 0
		end

		local downTime = self.hoc_pReleaseStopDownTime/self.hoc_stopDownTime

		-- local resDown = 1 - math.sin(math.acos(downTime))
		-- resDown = math.pow(resDown, 0.8)

		-- local resDown=math.pow(downTime,2.5)
		local resDown = math.pow(downTime, 1.5)
		self.hoc_dis = (self.hoc_mathDown - resDown)*self.hoc_stopDownDis
		self.hoc_mathDown = resDown

		-- if (self.hoc_stopDownDisAdd + self.hoc_dis) >= self.hoc_stopUpDis then
		-- 	self.hoc_dis = self.hoc_stopUpDis - self.hoc_stopDownDisAdd

		-- 	self.hoc_pReleaseStopDownTime = 0
		-- 	self.hoc_stopDownDisAdd = 0
		-- else
		-- 	self.hoc_stopDownDisAdd = self.hoc_stopDownDisAdd + self.hoc_dis
		-- end
		if (self.hoc_stopDownDisAdd + self.hoc_dis) >= self.hoc_stopDownDis then
			self.hoc_dis = self.hoc_stopDownDis - self.hoc_stopDownDisAdd

			self.hoc_pReleaseStopDownTime = 0
			self.hoc_stopDownDisAdd = 0
		else
			self.hoc_stopDownDisAdd = self.hoc_stopDownDisAdd + self.hoc_dis
		end

		self:moveList(self.hoc_dis)

		
		if self.hoc_stopCenterGear ~= nil then
			if (self.hoc_stopCenterGear.hoc_posy - (self.hoc_ShowVarStopBottom + (self.hoc_ShowVarStopTop - self.hoc_ShowVarStopBottom)*0.6))  <= 0 then
				self.hoc_stopCenterGear = nil
				-- 通知下一个滚轴可以停止了
				if self.delegate then
					self.delegate:stripNextStop(self.hoc_idx)
				end
			end
		end

		if self.hoc_stopBottomGear ~= nil then
			if (self.hoc_stopBottomGear.hoc_posy - self.hoc_ShowVarStopBottom)  <= 0 then
				self.hoc_stopBottomGear = nil
				-- 这里是一个滚轴接近停止，用于通知播放特殊出现的动画，如：scatter
				if self.delegate then
					self.delegate:stripNearStop(self.hoc_idx)
					-- print("stripNearStop", self.hoc_idx, self.hoc_ShowVarStopBottom, self.hoc_stopBottomGear.hoc_posy)
				end
			end
		end

		return
	end
	-- 向上缓动
	self.hoc_pReleaseStopUpTime = self.hoc_pReleaseStopUpTime - time

	if self.hoc_pReleaseStopUpTime <= 0 then
		self.hoc_pReleaseStopUpTime = 0
	end

	local upTime = self.hoc_pReleaseStopUpTime/self.hoc_stopUpTime

	-- local resUp = math.sin(math.acos(1-upTime))
	-- resUp = math.pow(resUp, 2)
	local resUp = 1-math.pow(1-upTime,1.2)

	-- local resUp = math.pow(upTime, 3)
	self.hoc_dis = (self.hoc_mathUp - resUp)*self.hoc_stopUpDis
	self.hoc_mathUp = resUp

	self:moveList(-self.hoc_dis)

	if self.hoc_pReleaseStopUpTime == 0 then
		self.hoc_bearingType = sConf.HOC_BEARING_TYPE.HOC_OVER

		-- 这里是一个滚轴完全停止
		if self.delegate then
			self.delegate:stripEndStop(self.hoc_idx)
			-- test
			-- if self.hoc_idx ==  1 then
			-- 	for i,gear in ipairs(self.hoc_gearList) do
			-- 		print(gear.hoc_tag,gear.hoc_posy)
			-- 	end
			-- end
		end
	end
end

function HUGE_Drive_Bearing:moveList(dis)
	for i,v in ipairs(self.hoc_gearList) do
		self:moveCell(v, dis)
	end
	-- 这里表示滚轴移动一次完成，并且重新校正了层级，需要回调参数
	if self.delegate then
		self.delegate:stripMove(self.hoc_idx, self.hoc_gearList)
		-- if self.hoc_idx ==  3 then
		-- 	for i,v in ipairs(self.hoc_gearList) do
		-- 		print(v.hoc_tag,v.hoc_posy)
		-- 	end
		-- end
	end
end

function HUGE_Drive_Bearing:moveCell(cell, dis)
	local posY = cell.hoc_posy - dis

	-- if posY > self.hoc_WishTop then
	-- 	posY = posY - self.hoc_WishTop + self.hoc_WishBottom
	-- elseif posY <  self.hoc_WishBottom then
	-- 	posY = self.hoc_WishTop - (self.hoc_WishBottom - posY)
	-- 	-- 遇到这种情况，就是最下面的一个元素已经被移动到最上面了，就要重新排列层级问题
	-- 	local tag = cell.hoc_tag
	-- 	for i,v in ipairs(self.hoc_gearList) do
	-- 		if tag == v.hoc_tag then
	-- 			v.hoc_zorder = 1
	-- 		else
	-- 			v.hoc_zorder = v.hoc_zorder + 1
	-- 		end
	-- 	end
	-- end
	if posY > self.hoc_WishTop then
		posY = posY - self.hoc_WishTop + self.hoc_WishBottom
	elseif posY <  self.hoc_WishBottom then
		posY = self.hoc_WishTop - (self.hoc_WishBottom - posY)
		-- 遇到这种情况，就是最下面的一个元素已经被移动到最上面了，就要重新排列层级问题
		local tag = cell.hoc_tag
		for i,v in ipairs(self.hoc_gearList) do
			if tag == v.hoc_tag then
				v.hoc_zorder = 1
			else
				v.hoc_zorder = v.hoc_zorder + 1
			end
		end
	end

	cell.hoc_posy = posY
end

-- 
function HUGE_Drive_Bearing:dispose()
end


return HUGE_Drive_Bearing






