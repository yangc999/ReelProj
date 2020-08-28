
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "initMain"
require "cocos.init"

local function main()
    -- require("app.MyApp"):create():run()
    require("app.MyApp").new():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
