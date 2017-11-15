--
-- Author: Your Name
-- Date: 2017-10-26 18:31:01
--
local AI = {kingTable = {}, boomTable = {}, threeTable = {},
		threethreeTable = {}, straightTable = {}, doubleStraightTable = {},
	doubleTable = {}}
require("app.define")
AI.__index = AI

function AI.new(list)
	local self = {}
	setmetatable(self, AI)
	self.list = list
	self:classfyCard()
	return self
end
--分析牌
function AI:classfyCard()
	-- dump(list)
	self.kingTable = AI.classfyKing(self.list)
	self.boomTable = AI.classfyBoom(self.list)
 	self.threeTable = AI.classfyThree(self.list)
	self.threethreeTable = AI.classfyThreeThree(self.threeTable)
	self.straightTable, self.list = AI.classfyStraight(self.threeTable, self.list)
	self.doubleStraightTable = AI.classfyDoubleStraight(self.straightTable, self.list)
	-- self.doubleTable = AI.classfyDouble(self.list)
	dump(self.kingTable, "王")--王
	dump(self.boomTable, "炸弹")--炸弹
	dump(self.threeTable, "三条")--三条
	dump(self.threethreeTable, "三顺")--三顺
	dump(self.straightTable, "顺子")--顺子
	dump(self.doubleStraightTable, "双顺")--双顺
	dump(self.doubleTable, "对子")
	dump(self.list, "其他牌")--其他

end

--获取手牌  相对手牌、绝对手牌
function AI:getHandCardNum()
	local handCardNum = 0
	local king = 0
	if getLen(self.kingTable) ~= 0 then --王手牌
		handCardNum = handCardNum + 1
		king = king + 1
	end
	for i=getLen(self.boomTable), 1, -1 do --炸弹
		handCardNum = handCardNum + 1
	end
	local threeNum = 0
	for i=getLen(self.threeTable), 1, -1 do  --三条
		threeNum = threeNum + 1
		handCardNum = handCardNum + 1
	end
	for i=getLen(self.threethreeTable), 1, -1 do  --三顺
		threeNum = threeNum + 1
		handCardNum = handCardNum + 1
	end
	for i=getLen(self.straightTable), 1, -1 do --顺子
		handCardNum = handCardNum + 1
	end
	for i=getLen(self.doubleStraightTable), 1, -1 do --双顺
		handCardNum = handCardNum + 1
	end
	local danNum = 0
	for i=getLen(self.straightTable), 1, -1 do 
		handCardNum = handCardNum + 1
		danNum = danNum + 1
	end
	for i=getLen(self.list), 1, -1 do 
		handCardNum = handCardNum + 1
		danNum = danNum + 1
	end
	if threeNum <= danNum then
		handCardNum = handCardNum - threeNum
	else
		handCardNum = handCardNum - danNum
	end
	local relativeHandCardNum = handCardNum - king
	print("=======" .. handCardNum, relativeHandCardNum)
	return relativeHandCardNum, handCardNum
end

--对子
function AI.classfyDouble(list)
	local doubleTable = {}
	for k,v in pairs(list) do
		if getLen(v) == 2 then
			doubleTable[k] = {}
			doubleTable[k] = v
			list[k] = nil 
		end
	end
	return doubleTable
end
--双顺
function AI.classfyDoubleStraight(straightTable, list)
	--顺子取连对
	local doubleStraightTable1 = {}
	local doubleStraightTable = {}
	for k,v in pairsByKeys(straightTable) do
		local x = 0
		for i,b in pairsByKeys(straightTable) do
			while true do
				x = x + 1
				if x == 1 or getLen(v) ~= getLen(b) then break end
					local flag = true
					for k1,v1 in pairs(v) do
						if not v[k1] or not b[k1] then
							flag = false
							break
						end 
					end
					if flag then
						local temp = {}
						for f,g in pairs(v) do
							local index1 = 0
							local index2 = 0
							for o,c in pairs(v[f]) do
								index1 = o
							end
							for o,c in pairs(b[f]) do
								index2 = o
							end
							doubleStraightTable1[f] = {v[f][index1], b[f][index2]}
						end
						table.insert(doubleStraightTable, doubleStraightTable1)
						straightTable[k] = nil
						straightTable[i] = nil
					else
						print("====顺子不连队")
					end
				break
			end			
		end
	end
	

	--list取连对
	for k,v in pairsByKeys(list) do
		if getLen(v) == 2 then
			local index = 1
			local x = 1
			for k1,v1 in pairsByKeys(list) do
				while true do 
					if x == 1 or getLen(v1) ~= 2 then x = x + 1 break end --continue
					if k1 - k == index then
						index = index + 1
					end
					break
				end
			end
			if index >= 3 then
				local temp1 = {}
				for k2,v2 in pairsByKeys(list) do
					if k2 >= k then
						if index > 0 then
							index = index - 1
							temp1[k2] = temp1[k2] or {}
							temp1[k2] = v2
							list[k2] = nil
						end
					end
				end
				table.insert(doubleStraightTable, temp1)				
			end
		end
	end
	return doubleStraightTable
end



--分类顺子
function AI.classfyStraight(threeTable, list)
	for k,v in pairs(threeTable) do
		list[k] = list[k] or {}
		list[k] = threeTable[k]	
	end	
	local straightTable = {}
	straightTable, list, threeTable = AI.getStraightFromList(threeTable, list)
	for k,v in pairsByKeys(threeTable) do
		list[k] = nil
	end
	return straightTable, list, threeTable
end
--分类顺子
function AI.getStraightFromList(threeTable, list)
	local straightTable = {} 
	local szNum = 0
	--第一步从list拉取顺子
	for k,v in pairsByKeys(list) do   ---从list遍历出顺子從
		local vLen = 1
		if type(v) == "table" then
			vLen = getLen(v)
		end    
		for u = 1, vLen do
			local index = 1
			local x = 0
			for j,p in pairsByKeys(list) do
				x = x + 1
				while true do if x == 1 then break end  --1的时候continue
					if j - k == index then
						index = index + 1
					end
					break
				end
			end
			if index >= 5 then
				szNum = szNum + 1
				straightTable[szNum] = {}
				for i,n in pairsByKeys(list) do
					if i >= k then
						if index > 0 then
							straightTable[szNum][i] = straightTable[szNum][i] or {}
							if getLen(list[i]) == 1 then
								local value = nil
								for t,tt in pairs(list[i]) do
									value = tt
								end
								table.insert(straightTable[szNum][i],value)
								list[i] = nil
							else
								local temp = {}
								table.insert(temp, list[i][1])
								straightTable[szNum][i] = temp 
								list[i][1] = nil
								if getLen(list[i]) == 2 then
									threeTable[i] = nil
								end
							end
						end
						index = index - 1
					end
				end
			end
		end      
	end
	return straightTable, list, threeTable
end

--三连
function AI.classfyThreeThree(threeTable)
	local threethreeTable = {}
	local temp = {}
	for i,t in pairsByKeys(threeTable) do
		local index = 1
		temp = {}
		temp[i] = temp[i] or {}
		temp[i] = t
		-- table.insert(temp[i], t)
		local j = 0
		for k,v in pairsByKeys(threeTable) do
			j = j + 1
			local flag = false
			while true do if j == 1 then break end --跳过第一个
				if i - k == index then
					index = index + 1
					temp[k] = temp[k] or {}
					temp[k] = v
				else 
					flag = true
				end
				break
			end
			if flag then break end
		end	
		if getLen(temp) == 1 then 
			temp = nil 
		else
			for k,v in pairsByKeys(temp) do
				threeTable[k] = nil
			end
			table.insert(threethreeTable, temp)
		end
	end
	return threethreeTable
end

--分类三条
function AI.classfyThree(list)
	local threeTable = {}
	for k,v in pairs(list) do
		if #v == 3 then
			if not threeTable[k] then
				threeTable[k] = {}
			end
			for s,b in pairs(v) do
				table.insert(threeTable[k], v[s])
			end
			-- table.remove(list, k)
			list[k] = nil
		end
	end
	return threeTable
end

--分类大王
function AI.classfyKing(list)
	local kingTable = {}
	for i,v in pairs(list) do
		if i == 16 then --大王
			if not kingTable[16] then
				kingTable[16] = {}
			end
			table.insert(kingTable[16], v[1])
			list[i] = nil
		elseif i == 17 then 
			if not kingTable[17] then
				kingTable[17] = {}
			end
			table.insert(kingTable[17], v[1])
			list[i] = nil
		end
	end	
	return kingTable
end

--分类炸弹
function AI.classfyBoom(list)
	local boomTable = {}
	for i,v in pairs(list) do
		if #v == 4 then --炸弹
			if not boomTable[i] then
				boomTable[i] = {}
			end
			table.insert(boomTable[i], v[1])
			table.insert(boomTable[i], v[2])
			table.insert(boomTable[i], v[3])
			table.insert(boomTable[i], v[4])
			list[i] = nil
		end
	end
	return boomTable
end

--出牌
function AI.chupai(cardList)

end

--跟牌
function AI.genpai(cardList, cards)

end

return AI