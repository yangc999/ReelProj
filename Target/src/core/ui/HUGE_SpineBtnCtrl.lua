-- HUGE_SpineBtnCtrl.lua
local HUGE_SpineBtnCtrl = class("HUGE_SpineBtnCtrl")
-- 
local BTN_RES_PLIST 	= "machine/machine_ui.plist"
local BTN_RES_PNG		= "machine/machine_ui.png"
-- 按钮的状态纹理资源
local BTN_RESID_TYPE	= {
	"btn2_0007_Spin.png",				-- SPIN_NOR:: spin 可点
	"btn2_0003_Spin_pro.png",			-- SPIN_DIS:: spin 置灰
	"btn2_0004_Free-Spins.png",			-- FREE_SPIN_NOR:: free spin 可点
	"btn2_0000_Free-Spins_pro.png", 	-- FREE_SPIN_DIS:: free spin 置灰
	"btn2_0006_Auto.png",				-- AUTO_SPIN_STOP_NOR:: auto spin stop 可点
	"btn2_0002_Auto_pro.png",			-- AUTO_SPIN_STOP_DIS:: auto spin stop 置灰
	"btn2_0005_Stop.png",				-- STOP_NOR:: stop 可点
	"btn2_0001_Sto_pro.png",			-- STOP_DIS:: stop 置灰
}
-- 按钮状态码
local BTN_STATUS_TYPE	= {
	SPIN_NOR 			= 1,	-- spin 可点
	SPIN_DIS 			= 2,	-- spin 置灰
	FREE_SPIN_NOR 		= 3,	-- free spin 可点
	FREE_SPIN_DIS 		= 4, 	-- free spin 置灰
	AUTO_SPIN_STOP_NOR	= 5,	-- auto spin stop 可点
	AUTO_SPIN_STOP_DIS	= 6,	-- auto spin stop 置灰
	STOP_NOR			= 7,	-- stop 可点
	STOP_DIS 			= 8,	-- stop 置灰
}
-- 
function HUGE_SpineBtnCtrl:ctor(parent, pos, zoderIndex)
	self:addPlistRes()
	self.parent_ 		= parent 		-- spin按钮 父容器节点
	self.pos_			= pos 			-- spin按钮 按钮的位置
	self.zoderIndex_	= zoderIndex 	-- spin按钮 层次
	self.spinStatus_	= BTN_STATUS_TYPE.SPIN_NOR
	self:initUI()
end
-- 初始化UI
function HUGE_SpineBtnCtrl:initUI()
	self:addPlistRes()
	-- spin按钮的容器
	self.spinNode_		= display.newNode():addTo(self.parent_, self.zoderIndex_):setPosition(self.pos_)
	-- 创建Spin按钮
	local norResId 		= self:getBtnResId(BTN_STATUS_TYPE.SPIN_NOR)
	local preResId 		= self:getBtnResId(BTN_STATUS_TYPE.SPIN_NOR)
	local disResId 		= self:getBtnResId(BTN_STATUS_TYPE.SPIN_DIS)
	self.spinBtn_		= self:createButton(handler(self, self.onClickSpin_), norResId, preResId, disResId)
							:addTo(self.spinNode_)
end
-- 获取按钮的状态纹理 btnStatus 类型为 BTN_STATUS_TYPE
function HUGE_SpineBtnCtrl:getBtnResId(btnStatus)
	return BTN_RESID_TYPE[btnStatus]
end
-- 销毁
function HUGE_SpineBtnCtrl:dispose()
	self:delPlistRes()
end
-- 加载纹理资源
function HUGE_SpineBtnCtrl:addPlistRes()
    display.loadSpriteFrames(BTN_RES_PLIST, BTN_RES_PNG)
end
-- 删除纹理资源
function HUGE_SpineBtnCtrl:delPlistRes()
	display.removeSpriteFrames(BTN_RES_PLIST, BTN_RES_PNG)
end
-- 创建按钮
function HUGE_SpineBtnCtrl:createButton(clickCallback, norResId, preResId, disResId)
	preResId = preResId or norResId
	disResId = disResId or preResId
	local btn = ccui.Button:create(norResId, preResId, disResId, ccui.TextureResType.plistType)
	btn:addClickEventListener(clickCallback)
	return btn
end
-- 设置按钮状态
function HUGE_SpineBtnCtrl:setSpinStatus(value)
	self.spinStatus_ = value
	local norResId 		= self:getBtnResId(self.spinStatus_)
	self.spinBtn_:loadTextures(norResId, norResId, norResId, ccui.TextureResType.plistType)
end
-- 获取按钮状态
function HUGE_SpineBtnCtrl:getSpinStatus()
	return self.spinStatus_
end
--------------------------------------------------------
-- 设置 spin 按钮click 回调
function HUGE_SpineBtnCtrl:setDelegate(callback)
	self.delegate_ = callback
	return self
end
-- spin 按钮的Click 
function HUGE_SpineBtnCtrl:onClickSpin_(sender, event)
	-- 测试代码
	self:test()
	-- 
	if self.delegate_ then
		self.delegate_()
	end
end
-- 
function HUGE_SpineBtnCtrl:test()
	if not self.cnt_ then
		self.cnt_ = 0
	end
	self.cnt_ = self.cnt_ + 1
	if self.cnt_ <= BTN_STATUS_TYPE.STOP_DIS then
		self:setSpinStatus(self.cnt_)
		-- 
		if self.cnt_ == BTN_STATUS_TYPE.STOP_DIS then
			self.cnt_ = 0
		end
	end
end

return HUGE_SpineBtnCtrl



