
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
end
-- 
function MyApp:run()
    self:enterScene("core/ctr/HUGE_GameCtr")
end
-- 
function MyApp:enterScene(sceneName, args, transitionType, time, more)
    -- self:dispatchEvent("EnterScene_Event", sceneName)
    MyApp.super.enterScene(self, sceneName, args, transitionType, time, more)
end

return MyApp
