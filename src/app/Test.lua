--
-- Author: Your Name
-- Date: 2017-11-28 15:15:09
--
function pairsByKeys(t)  
    local a = {}  
    for n in pairs(t) do  
        a[#a+1] = n  
    end  
    table.sort(a)  
    local i = 0  
    return function()  
        i = i + 1  
        return a[i], t[a[i]]  
    end  
end 

function getLen(t)
    local a = 0
    if type(t) ~= "table" then
        return a
    end
    for n in pairs(t) do
        a = a + 1
    end
    return a
end


function dump(data, max_level, prefix)  
    if type(prefix) ~= "string" then  
        prefix = ""  
    end  
    if type(data) ~= "table" then  
        print(prefix .. tostring(data))  
    else  
        print(data)  
        if max_level ~= 0 then  
            local prefix_next = prefix .. "    "  
            print(prefix .. "{")  
            for k,v in pairs(data) do  
                io.stdout:write(prefix_next .. k .. " = ")  
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then  
                    print(v)  
                else  
                    if max_level == nil then  
                        dump(v, nil, prefix_next)  
                    else  
                        dump(v, max_level - 1, prefix_next)  
                    end  
                end  
            end  
            print(prefix .. "}")  
        end  
    end  
end  

package.path = package.path .. ";D:/cocos/doudizhu/cDouDiZhu/src/?.lua"
local mod = require("app.logic.makecards")
local AIUtils = require("app.logic.AIUtils")
local centUser = mod.makeCards()[2]
-- dump(centUser)
AIUtils.isAccord(centUser)