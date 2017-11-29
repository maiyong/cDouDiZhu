--
-- Author: chenlinhui
-- Date: 2017-09-28 16:47:49
-- Desc: 洗牌

local mod = {}

package.path = package.path .. ";D:/cocos/doudizhu/cDouDiZhu/src/?.lua"
require("app.define")
math.randomseed(tostring(os.time()):reverse():sub(1, 6))  

local function getARandomCard(lCard)
	local num = #lCard 
	if num <= 0 then
		return {}
	end
	local iRan = math.random(1, num)
	local result = lCard[iRan]
	table.remove(lCard, iRan)
	return lCard, result
end

function mod.makeCards()
	-- 初始牌库
	local temp = {}
	for i=1, 54 do
		temp[i] = i
	end

	local function getCard(num)
		if num <= 0 then 
			return {}
		end
		local result = {}
		local list = {}
		for i=1, num do
			local t, r = getARandomCard(temp)
			temp = t
			local iType = math.ceil(r/13)
			if not result[iType] then 
				result[iType] = {}
			end
			if iType >= 5 then -- "王"
				r = r%13+15
				if not list[r] then
					list[r] = {}
				end
				table.insert(result[iType], r)
				table.insert(list[r], iType)
			else
				r = (r%13<=2 and 13+r%13) or r%13
				if not list[r] then
					list[r] = {}
				end
				table.insert(result[iType], r)
				table.insert(list[r], iType)
			end
		end
		return list
	end

	function test()
		local s = {
		-- [4] = {[1] = 1, [2] = 2}, 
		-- [5] = {[1] = 1, [2] = 2},
		-- [6] = {[1] = 1, [2] = 2},
		[7] = {[1] = 1},
    	-- [8] = {[1] = 1, [2] = 2},
    	-- [9] = {[1] = 1, [2] = 2},
    	-- [10] = {[1] = 3, [2] = 2, [3] = 1},
    	-- [11] = {[1] = 1, [4] = 4},
    	-- [12] = {[1] = 1, [2] = 2},
    	-- [13] = {[1] = 1, [3] = 3, [2] = 4, [4] = 2},
    	-- [16] = {[1] = 5},
    	-- [17] = {[1] = 5}
    	}
    		-- table.remove(temp, 1)table.remove(temp, 14)
    		-- table.remove(temp, 18)table.remove(temp, 24)
    		-- table.remove(temp, 27)table.remove(temp, 33)
    		-- table.remove(temp, 35)table.remove(temp, 39)
    		-- table.remove(temp, 41)table.remove(temp, 42)
    		-- table.remove(temp, 43)table.remove(temp, 44)
    		-- table.remove(temp, 47)table.remove(temp, 49)
    		-- table.remove(temp, 50)table.remove(temp, 53)
    		-- table.remove(temp, 54)
    	return s 
	end
	local r = {
		[4] = {[1] = 1, [2] = 2}, 
		[5] = {[1] = 1, [2] = 2, [3] = 4},
		[6] = {[1] = 2},
		-- [7] = {[1] = 2, [3] = 4, [2] = 1, [4] = 3},
    	[8] = {[1] = 4, [2] = 2},
    	-- [9] = {[1] = 3, [4] = 4},
    	-- [10] = {[1] = 3, [2] = 2, [3] = 1},
    	-- [11] = {[1] = 1, [4] = 4},
    	-- [12] = {[1] = 1, [2] = 2},
    	-- [13] = {[1] = 1, [3] = 3, [2] = 4},
    	-- [16] = {[1] = 5},
    	-- [17] = {[1] = 5}
    }

    local l = {
		[4] = {[1] = 1, [2] = 2}, 
		[5] = {[1] = 1, [2] = 2, [3] = 4},
		[6] = {[1] = 2},
		[7] = {[1] = 2, [3] = 4, [2] = 1, [4] = 3},
    	[8] = {[1] = 4, [2] = 2},
    	-- [9] = {[1] = 3, [4] = 4},
    	-- [10] = {[1] = 3, [2] = 2, [3] = 1},
    	-- [11] = {[1] = 1, [4] = 4},
    	-- [12] = {[1] = 1, [2] = 2},
    	-- [13] = {[1] = 1, [3] = 3, [2] = 4},
    	[16] = {[1] = 5},
    	[17] = {[1] = 5}
    }

	-- local lCard_2 = test()
	local lCard_2 = getCard(17)
	local lCard_1 = getCard(3)
	local lCard_3 = getCard(17)
	local lCard_4 = getCard(17)

	return {lCard_1, lCard_2, lCard_3, lCard_4}
end




--排序
function mod.sortCard(allCard)
	local keyList = {}
	local newList = {}
	for k,v in pairs(allCard) do
		for j,q in pairs(v) do
			if not keyList[k] then
				keyList[k] = {}
			end		
			table.insert(keyList[k], j)
		end
	end
	for i,v in ipairs(keyList) do
		table.sort(v)
	end
	for k,v in pairs(keyList) do
		for j,q in pairs(v) do
			newList[k] = newList[k] or {}
			newList[k][q] = allCard[k][q] 
		end
	end
	allCard = newList
end
-- dump(makeCards())

-- require("collectcards")
-- collectcard.showMessage()

return mod