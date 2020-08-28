-- initMain.lua
GAME_DEBUG          = true      -- 控制游戏打印日志输出，true为打印日志
-- 
local inspect = require("inspect")
function XBLog(_tab,tabDescribe,logPath,mod)
    if type(_tab)~="table" then
        _tab = {_tab = _tab,_1_ = "error! Pass in a string!"}
    end
    -- 
    _tab._11_time = os.date()
    local logPath = logPath or "ErrorGameLog.lua"
    if device.platform ~= "windows" then
        logPath = device.writablePath.."/"..logPath
    else
        logPath = "../"..logPath
    end
    -- 
    local mod = mod or 1
    local str = ""
    if mod==1 then
        local oldStr = ""
        local file = io.open(logPath, "r")
        if file then
            oldStr = file:read("*a")
            file:close()
        end
        -- 
        local temp = tabDescribe.."\n"..inspect(_tab, {indent="    "})
        str = oldStr.."\n\n==============================>>>>>>\n\n"..temp
    else
        local temp = tabDescribe.."\n"..inspect(_tab, {indent="    "})
        str = temp
    end
    local file = io.open(logPath, "w")
    if file then
        file:write(str)
        file:close()
    end
end
--mod==1追加，mod==2覆盖
function XBDebugLog(_tab,tabDescribe,logPath,mod)
    if not GAME_DEBUG then
        return
    end
    XBLog(_tab,tabDescribe,logPath,mod)
end
-- 
function XBCrashLog(_tab,tabDescribe,logPath,mod)
    XBLog(_tab,tabDescribe,logPath,mod)
end
--   
cclog = function(...)  
    if GAME_DEBUG == true then
        print(string.format(...))  
    end
end  
-- 
function isTableNilOrEmpty(tab)
    if (tab and next(tab) ~= nil) then
        return false;
    else
        return true;
    end
end
-- 
-- CC_DISABLE_GLOBAL = true
-- cc.disable_global()


