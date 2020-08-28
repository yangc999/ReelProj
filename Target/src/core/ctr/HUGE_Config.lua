-- Huge_cfg.lua
-- Author: Joker
-- Date: 2019-02-15 11:18:55
--

return {

    SLOTS_LOCAL_SKIN = {
        NAME        = "Machine_JinGuQiMing",    -- Machine_JinGuQiMing
        ID          = 100000066,             -- 100000066
        VIP_ID      = -100000066,             -- 100000066
    },
    SLOTS_LOCAL_SKIN_TEST = false,  -- 是否 跳过皮肤交验
    MACHINE_SRC_SKIN_PATH = "machine/skin/",

    SLOTS_CTR_TYPE = {

        SLOTS_START      = 0, --  触发spin按钮，请求svr，滚轴无限滚动，不允许任何操作
        SLOTS_RESULT     = 1, --  数据返回，滚轴开始启动停止机制，玩家可手动提前停止，直到滚轴全部完全停止，之后检测是否中feature或者特殊合并动画
        SLOTS_BALANCE    = 2, --  开始结算状态
        SLOTS_END        = 3, --  本次结果结束、检测是否有feature，并启动feature模式
        SLOTS_OVER       = 4, --  一次spin触发的所有流程全部结束，如freespin全部结束，之后检测是否有运营活动达成，然后才允许进入下一步付费spin
    },

    VIEW_ZORDER = {

        BG_ORDER        = 1000,
        REEL_ORDER      = 2000,
        TITLE_ORDER     = 3000,
        ANIM_ORDER      = 4000,
        TIPS_ORDER      = 5000,
        EXT_ORDER       = 6000,
        ACTIVITY_ORDER  = 7000,
        RESULT_ORDER    = 8000,
    },

    SLOTS_WIN_TYPE = {
        NORMAL  = 0,
        BIGWIN  = 1,
        MEGAWIN = 2,
        HUGEWIN = 3,
        EPICWIN = 4,
    },

    SLOTS_FEATURE_STATE = {
        F_WAIT      = 0,
        F_PROC      = 1,
        F_FINISH    = 2,
    },

    -- SLOTS_FEATURE_ORDER = {
    --     NULL    = 0,
    --     UP      = 1,
    --     NEXT    = 2,
    --     DOWN    = 3,
    -- },

    -- SLOTS_FEATURE_TYPE = {
    --     NULL        = 0,
    --     FREESPIN    = 1,
    --     JACKPORT    = 2,
    --     MINIGAME    = 3,
    --     HOLDSPIN    = 4,
    --     COLLECT     = 5,
    --     EXT1        = 6,
    --     EXT2        = 7,
    --     EXT3        = 8,
    -- },

    SLOTS_RCTYPE = {
        CENTER  = 0,
        TOP     = 1,
        BOTTOM  = 2,
    },

    -- * 任意机台所属元素的类型定义，共9种，其中5种为扩展类型，其动画种类与scatter元素一致

    SLOTS_ELEMENT_TYPE = {
        normal      = 0, -- 普通元素 
        important   = 1, -- 重要元素
        wild        = 2, -- wild元素
        scatter     = 3, -- scatter元素
        bonus       = 4, -- bonus元素(一般用于触发小游戏，feature的特殊扩展，只是习惯性叫法)
        scatterX    = 5, -- 触发feature，特殊类型扩展1，可自由赋予含义
        scatterXX   = 6, -- 触发feature，特殊类型扩展2，可自由赋予含义
        scatterXXX  = 7, -- 触发feature，特殊类型扩展3，可自由赋予含义
        scatterXXXX = 8, -- 触发feature，特殊类型扩展4，可自由赋予含义
    },

    -- * 元素的层级定义，在实际设置中，后一条滚轴的所有元素层级 都比前一条要高，赋予偏差

    SLOTS_ELEMENT_ZORDER = {
        normal      = 1,  -- 普通元素 重要元素
        special     = 2,  -- 比普通元素高一些，但是比scatter等低一些的，如2格的，或者3格的
        wild        = 51, -- wild元素
        scatter     = 61, -- scatter元素
        bonus       = 61, -- bonus元素 
        max         = 71, -- 触发feature，特殊类型扩展1，可自由赋予含义
    },

    -- * 播放动画时元素的层级临时提升程度

    SLOTS_ELEMENT_PLAY_ZORDER_UP = 1000,

    SLOTS_LINE_TIME = 1.1, -- 线播放时间
    SLOTS_GAP_TIME  = 0.2, -- auto spin或者 免费旋转 结算之后 停留的时间，再进行下一步

    -- * spin按钮的几种状态
    SPIN_BTN_TYPE = {

        btn_null      = -1, --  无效状态
        btn_spin      = 0, --  spin状态
        btn_stop      = 1, --  可停止状态
        btn_freespin  = 2, --  免费游戏状态
        btn_auto      = 3, --  自动状态
    },

    SPIN_BTN_AUTO_LENGTH_PRESS_TIME = 3, -- spin状态长按3秒触发auto
    ----------------------------------------------------------------------------
}  
