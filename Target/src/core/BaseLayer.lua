--[[
基础层
]]--
-- local BaseLayer = class("BaseLayer", cc.LayerColor)
local BaseLayer = class("BaseLayer", function() return cc.LayerColor:create() end)

function BaseLayer:ctor()
    self.touchEnable = false;
    self:enableNodeEvents();
    self:setIsTouchEnable(true);
    self:setIgnoreAnchorPointForPosition(true);
end

function BaseLayer:setColor3b(color3b)
    self:setColor(color3b);
    self:setOpacity(255 * 0.6);
    return self
end

function BaseLayer:onEnter()
end

function BaseLayer:onExit()
    self:setIsTouchEnable(false);
end

function BaseLayer:onEnterTransitionFinish()
end

function BaseLayer:onExitTransitionStart()
end

function BaseLayer:onCleanup()
    self:removeScriptListenner()
    self:removeEnterFrames()
end

function BaseLayer:setDelegate(delegate)
    self.delegate = delegate;
    return self
end

function BaseLayer:onTouchBegan(touch, event)
    local isTouchSelf = false;
    local rect = self:getBoundingBox();
    if cc.rectContainsPoint(rect, touch:getLocation()) then
        isTouchSelf = true;
    end
    -- 
    if self.delegate then
        self.delegate("began", touch, event, isTouchSelf)
    end
    -- 
    return (isTouchSelf and self.touchEnable);
end

function BaseLayer:onTouchMoved(touch, event)
    if self.delegate then
        self.delegate("moved", touch, event)
    end
end

function BaseLayer:onTouchEnded(touch, event)
    if self.delegate then
        self.delegate("ended", touch, event)
    end
end

function BaseLayer:onTouchCancelled(touch, event)
    if self.delegate then
        self.delegate("cancel", touch, event)
    end
end

function BaseLayer:getIsTouchEnable()
    return self.touchEnable;
end

function BaseLayer:setIsTouchEnable(isEnable)
    if self.touchEnable == isEnable then return end
    -- 
    self.touchEnable = isEnable;
    if self.touchEnable then
        self:registerScriptListener()
        
    else
        self:removeScriptListenner()
    end
end
-- 
function BaseLayer:registerScriptListener()
    if not self.eventDispatcher_ then
        self.listener_ = cc.EventListenerTouchOneByOne:create();
        self.listener_:setSwallowTouches(true);
        self.listener_:registerScriptHandler(handler(self, self.onTouchBegan), cc.Handler.EVENT_TOUCH_BEGAN )
        self.listener_:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED )
        self.listener_:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED )
        self.listener_:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED )
        
        self.eventDispatcher_ = self:getEventDispatcher()
        self.eventDispatcher_:addEventListenerWithSceneGraphPriority(self.listener_, self)
        -- self.eventDispatcher_:addEventListenerWithFixedPriority(self.listener_, -128)
        -- self.eventDispatcher_:addEventListenerWithFixedPriority(self.listener_, 1)
    end
end
-- 
function BaseLayer:removeScriptListenner()
    if self.eventDispatcher_ then
        self.eventDispatcher_:removeEventListenersForTarget(self);
        self.eventDispatcher_ = nil
    end
end
-- 
function BaseLayer:addEnterFrames(callback)
    if not self.enterFrameId_ then
        -- self.enterFrameId_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(callback, FRAME_TIME or 0.02, false)
    end
end
-- 
function BaseLayer:removeEnterFrames()
    if self.enterFrameId_ then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.enterFrameId_)
        self.enterFrameId_ = nil
    end
end

return BaseLayer
