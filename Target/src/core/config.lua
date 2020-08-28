return {

		-- * 每一个机台，都有一个独立的config配置文件，用于定义该slots的基本数据信息

		-- * 机台标记
		slotsId = 100000090,				-- * 机台唯一ID
		slotsName = "Machine_Vegas777",		-- * 机台唯一名称标记

		-- * 机台音效
		automaticStopMusicTime = 10,		-- * spin时循环播放音效，停止spin后音效停止播放时间

		-- * 滚轴基础配置
		rcList = {   
			[1] = 3,
			[2] = 3,
			[3] = 3,
			[4] = 3,
			[5] = 3,
		},									-- * 3*5 的区域

		rcWishList = {   
			[1] = 3,
			[2] = 3,
			[3] = 3,
			[4] = 3,
			[5] = 3,
		},	


		viewAlignmentType = 2,				-- * 滚轴的对齐方式，上中下
		viewWidth = 810,
		viewHeight = 324, --540--324,
		viewLineWidth = 5,
		viewAnimClipLeftAndRight = 0,  -- 动画层的元素 播放动画，是否可以左右超框,这里决定 左右加宽范围
		viewAnimClipTopAndBottom = 0,  -- 动画层的元素 播放动画，是否可以上下超框,这里决定 上下加高范围

		cLineWidthList = {   -- 每个滚轴之间的线宽
			[1] = 5,
			[2] = 5,
			[3] = 5,
			[4] = 5,
			[5] = 0,  -- 最后一个滚轴的线宽为0，后面没有滚轴了
		},	

		-- * 元素类型定义说明

		    -- * 任意机台所属元素的类型定义，共9种，其中5种为扩展类型，其动画种类与scatter元素一致

		    -- SLOTS_ELEMENT_TYPE = {
		    --     normal      = 0, -- 普通元素 （A、K、Q、J、10、9, 梅花4色等）
		    --     important   = 1, -- 重要元素
		    --     wild        = 2, -- wild元素(百搭元素）
		    --     scatter     = 3, -- scatter元素（用于触发“免费游戏”的元素都叫scatter）   
		    --     bonus       = 4, -- bonus元素(一般用于触发小游戏，feature的特殊扩展，只是习惯性叫法)
		    --     scatterX    = 5, -- 触发feature，特殊类型扩展1，可自由赋予含义
		    --     scatterXX   = 6, -- 触发feature，特殊类型扩展2，可自由赋予含义
		    --     scatterXXX  = 7, -- 触发feature，特殊类型扩展3，可自由赋予含义
		    --     scatterXXXX = 8, -- 触发feature，特殊类型扩展4，可自由赋予含义
		    -- },

		-- * 元素动画定义说明

			-- 0:普通元素             全部中奖周期动画，无循环动画（可程序处理、可spine）
			-- 1:重要元素             全部中奖循环动画（强制spine）
			-- 2:wild元素             一般都是中奖循环动画，但是也会有 入场 动画的情况（强制spine）
			-- 3:scatter元素          大致分2种动画：入场、中奖循环动画（强制spine）,scatterX,scatterXX,scatterXXX,scatterXXXX雷同
			-- 4:bonus元素			 大致分2种动画：入场、中奖循环动画（强制spine）

		-- * 动画类型说明

			-- ami0:表示 周期动画、无循环
			-- ami1:表示 入场动画
			-- ami2:表示 中奖循环动画
			-- amiX:表示 扩展动画，如：amiX1:3格合体动画，amiX2:飞金币动画，等等，约定

		-- * 注意： 每一个元素 正确配置 自己的动画类型，必须在本配置表配置，不允许程序里面自己定义，特殊动画约定

		-- * 本机台所有元素的信息配置说明

		elementArr = {
			[1] = {
				id 		= 1,
				num 	= 1,
				type 	= 0,  	-- 0:普通元素，1:重要元素，2:wild元素，3:scatter元素，4:bonus元素(feature的扩展用)
				ami = {},  -- 动画列表为空，则：无spine动画，需技术统一规范处理
			},
			[2] = {
				id 		= 81,
				num 	= 1,
				type 	= 1,  	-- 0:普通元素，1:重要元素，2:wild元素，3:scatter元素，4:bonus元素(feature的扩展用)
				ami = {"ami2"},
			},
			[3] = {
				id 		= 71,
				num 	= 1,
				type 	= 3,  	-- 0:普通元素，1:重要元素，2:wild元素，3:scatter元素，4:bonus元素(feature的扩展用)
				ami = {"ami1", "ami2"},
			},
			[4] = {
				id 		= 51,
				num 	= 1,
				type 	= 2,  	-- 0:普通元素，1:重要元素，2:wild元素，3:scatter元素，4:bonus元素(feature的扩展用)
				ami = {"ami3", "ami1"}, --{"ami3", "amiX1"},
			},
			[5] = {
				id 		= 2,
				num 	= 1,
				type 	= 0,  	-- 0:普通元素，1:重要元素，2:wild元素，3:scatter元素，4:bonus元素(feature的扩展用)
				ami = {},  -- 动画列表为空，则：无spine动画，需技术统一规范处理
			},
		},

		featureKey = {"freespin","holdspin"},
		--   以下 未完待续

		uiViewSub = {  -- UI默认为游戏的中心点，这里是调整偏差
			viewBg = {posX = 0, posY = -44},
			lineBg = {posX = 0, posY = -44},
			boxBg  = {posX = 0, posY = -44},
			drawLine = {posX = 0, posY = -44},
		},

		playTableCount = 8,	

		initArr = {   
			[1] = { 81, 71,  81,  81,  81, 81,  81,  81}, 
      		[2] = {  2,  1,  2,  2,  1,  1,  2,  2},
      		[3] = { 71, 2, 71, 2, 71, 2, 1, 81, 71, 81, 71, 2},
      		[4] = { 81, 81, 81, 81,  2, 51, 51, 81, 81, 81,  2, 51},
      		[5] = {  1,  2,  2,  1,  2, 51, 2,  2,  2,  1,  2, 51},
		},

		rollerArr = { 
			[1] = {71,2,3,1,82,3,2,103,106,109,83,101,83,82,81,83,83,101,3,2,81,101,1,3,82,107,82,1,81,1,110,83,3,109,81,82},
          	[2] = {71,2,1,3,108,2,83,3,1,101,3,1,1,2,2,103,106,109,3,81,2,51,51,2,1,82,3,3},
          	[3] = {71,51,51,51,83,81,82,103,106,109,82,83,81,1,81,82,107,82,83,110,2,81,83,83,110,82,101,108,81,81,83},
          	[4] = {71,82,81,103,3,82,2,1,83,81,1,51,51,51,81,82,101,83,103,110,81,1,2,82,107,83,83,102,105,108,3,107},
          	[5] = {71,83,81,83,101,83,2,101,109,3,2,81,102,101,82,82,110,3,82,82,81,3,1,106,101,108,1,1,104,1,82,51,51,51,2,83,106,1,3}
        },

        lineNum 		= 25,	
		lineArr = {
			{pos = {1,1,1,1,1}},
			{pos = {0,0,0,0,0}},
			{pos = {2,2,2,2,2}},
			{pos = {0,1,2,1,0}},
			{pos = {2,1,0,1,2}},

			{pos = {1,0,0,0,1}},
			{pos = {1,2,2,2,1}},
			{pos = {0,0,1,2,2}},
			{pos = {2,2,1,0,0}},
			{pos = {1,2,1,0,1}},

			{pos = {1,0,1,2,1}},
			{pos = {0,1,1,1,0}},
			{pos = {2,1,1,1,2}},
			{pos = {0,1,0,1,0}},
			{pos = {2,1,2,1,2}},

			{pos = {1,1,0,1,1}},
			{pos = {1,1,2,1,1}},
			{pos = {0,0,2,0,0}},
			{pos = {2,2,0,2,2}},
			{pos = {0,2,2,2,0}},

			{pos = {2,0,0,0,2}},
			{pos = {1,2,0,2,1}},
			{pos = {1,0,2,0,1}},
			{pos = {0,2,0,2,0}},
			{pos = {2,0,2,0,2}},
		},

		-- 异步加载的资源
		AsynLoad = {
		-- pngList = {"animation0.png", "animation1.png", "animation9_freeze.png", "animation9.png", "animation11.png", "dragonBoy.png", "dragonMap.png", "skeleton.png", "skeleton2.png"},
		pngList = {},
		spineList = {"slots_51", "slots_71", "slots_81", "slots_82", "slots_83", "slots_101", "slots_102", "slots_103", "boom", "slots_110", "slots_112", "slots_113"},
	},
}
