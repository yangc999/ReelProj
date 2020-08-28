
--
-- * 轴承的基础配置数据 以及类型定义

return {
	
	-- * 轴承的滚动数据参数

	HOC_AMI = {
		hoc_accArr 				= {},	-- 初始掉落缓动步骤
		hoc_speed 				= 30, 	-- 匀速速度
		hoc_super 				= 50, 	--
		hoc_time				= 0.12, -- 滚动时间
		hoc_stopDownTime 		= 0.2,  -- 滚轴向下停止时间
		hoc_stopUpTime 			= 0.2,  -- 滚轴向上停止时间
		hoc_gapTime  			= 0.2,  -- 滚轴之间运动时间差
		hoc_delayTime 			= 0.0,	-- 滚轴开始执行的延迟时间时间 = (col)* amiDelayTime
		hoc_downParameter  		= 0.2,--0.764, 	-- 滚轴停止时下探的比例,该比例的单位是元素的高度一半
		hoc_upParameter  		= 0.2,--0.764, 	-- 滚轴停止时回弹的比例,该比例的单位是元素的高度一半
		hoc_superAddTime 		= 2.0,  -- 时间加速
		hoc_quickStopTimeParameter 		= 2,  -- 快速停止的时间倍数参数
	},

	-- * 视图的对齐方式，默认的是居中对齐

	HOC_VIEWTYPE            = {
        HOC_CENTER  = 0,
        HOC_TOP     = 1,
        HOC_BOTTOM  = 2,
    },

    -- * 轴承的 运动 状态数据

    HOC_BEARING_TYPE = {
        HOC_SPIN    = "HOC_SPIN",  -- * 匀速运动状态
        HOC_WILL   	= "HOC_WILL",  -- * 准备开始停止时刻
        HOC_STOP    = "HOC_STOP",  -- * 正式开始停止状态
        HOC_OVER    = "HOC_OVER",  -- * 停止状态
    },
};