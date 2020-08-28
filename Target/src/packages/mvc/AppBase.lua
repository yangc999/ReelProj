
local AppBase = class("AppBase")

AppBase.APP_ENTER_BACKGROUND_EVENT = "APP_ENTER_BACKGROUND_EVENT"
AppBase.APP_ENTER_FOREGROUND_EVENT = "APP_ENTER_FOREGROUND_EVENT"

function AppBase:ctor(appName, packageRoot)
    -- cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

    self.name = appName
    self.packageRoot = packageRoot or "app"

    self.snapshots_ = {}

    -- set global app
    cc.exports.app = self
end

function AppBase:run()
end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" then
        os.exit()
    end
end

function AppBase:enterScene(sceneName, args, transitionType, time, more)
    local scenePackageName = sceneName
    local sceneClass = require(scenePackageName)
    local scene = sceneClass.new(unpack(checktable(args)))
    display.runScene(scene, transitionType, time, more)
end

function AppBase:createView(viewName, ...)
    local viewPackageName = self.packageRoot .. ".views." .. viewName
    local viewClass = require(viewPackageName)
    return viewClass.new(...)
end

function AppBase:onEnterBackground()
    -- print("AppBase:onEnterBackground")
end

function AppBase:onEnterForeground()
    -- print("AppBase:onEnterForeground")
end

return AppBase
