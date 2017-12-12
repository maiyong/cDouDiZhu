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
	self.backuplist = {}
	for k,v in pairs(self.list) do
		self.backuplist[k] = self.backuplist[k] or {}
		self.backuplist[k] = list[k] 
	end
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
	self.doubleTable = AI.classfyDouble(self.list)
	-- dump(self.kingTable, "王")--王
	-- dump(self.boomTable, "炸弹")--炸弹
	-- dump(self.threeTable, "三条")--三条
	-- dump(self.threethreeTable, "三顺")--三顺
	-- dump(self.straightTable, "顺子")--顺子
	-- dump(self.doubleStraightTable, "双顺")--双顺
	-- dump(self.doubleTable, "对子")
	-- dump(self.list, "其他牌")--其他
	-- dump(self.backuplist, "备份list")
end

--假定火箭为8分，炸弹为6分，大王4分，小王3分，一个2为2分,大于6分就叫地主
function AI:getHandCardScore()
	local score = 0
	if getLen(self.kingTable) == 2 then
		score = score + 8
	elseif getLen(self.kingTable) == 1 then
		for k,v in pairs(self.kingTable) do
			if k == 16 then
				score = score + 3
			else
				score = score + 4
			end
		end
	end
	--炸弹
	score = score + 6 * getLen(self.boomTable)
	--2
	score = score + 2 * getLen(self.backuplist[15])
	print("分数为" .. score)
	return score
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
	local num = 1
	for k,v in pairsByKeys(straightTable) do
		local x = 0
		for i,b in pairsByKeys(straightTable) do
			while true do
				x = x + 1
				if x == num or getLen(v) ~= getLen(b) then break end
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
		num = num + 1
	end
	

	--list取连对
	for k,v in pairsByKeys(list) do
		if getLen(v) == 2 then
			local index = 1
			local x = 1
			for k1,v1 in pairsByKeys(list) do
				while true do 
					if x == 1 or getLen(v1) ~= 2 then x = x + 1 break end --continue
					if k1 - k == index and k1 <= 14 then
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
					if j - k == index and j <= 14 then
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
								local tempIndex = 0
								for g,h in pairs(list[i]) do
									tempIndex = g
									break
								end
								table.insert(temp,list[i][tempIndex])
								straightTable[szNum][i] = temp 
								list[i][tempIndex] = nil
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
				if k - i == index and k <= 14 then
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
		if getLen(v) == 3 then
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
		if getLen(v) == 4 then --炸弹
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

--先出单牌
function AI:chudan(isDan)
	--先出单牌因为单牌可以用三条、三顺等带出，所以在出单牌时，
	--应该先检测一下三条＋三顺（中三条）的数量，如果所有三条数量 <= 对子＋单牌数量总和－2时，
	--出单牌，否则出三带1等等。
	local danLen = getLen(self.list)
	local shuangLen = getLen(self.doubleTable)
	local temp = {}
	local len = isDan and {danLen} or {shuangLen}
	local tempList = isDan and self.list or self.doubleTable
	if len[1] > 0 then
		local threeLen = getLen(self.threeTable)
		local threethreeLen = getLen(self.threethreeTable)
		if (danLen + shuangLen - 2) >= (threeLen + threethreeLen) then
			print("出单牌")
			for k,v in pairsByKeys(tempList) do
				-- print("出了" .. k)
				temp[k] = temp[k] or {}
				temp[k] = v
				tempList[k] = nil
				break
			end
		else
			print("出三带一or2")
			if threeLen > 0 then
				for k,v in pairsByKeys(self.threeTable) do
					for k1, v1 in pairsByKeys(tempList) do
						temp[k1] = temp[k1] or {}
						temp[k1] = v1
						tempList[k1] = nil
						break
					end
					temp[k] = temp[k] or {}
					temp[k] = v
					self.threeTable[k] = nil
					break
				end
			-- else
			-- 	for k,v in pairsByKeys(self.threethreeTable) do
			-- 		local tempLen = getLen(v)
			-- 		for k1, v1 in pairsByKeys(tempList) do
			-- 			if tempLen > 0 then
			-- 				tempLen = tempLen - 1
			-- 				temp[k1] = temp[k1] or {}
			-- 				temp[k1] = v1
			-- 				tempList[k1] = nil
			-- 			else
			-- 				break
			-- 			end
			-- 		end
			-- 		temp[k] = temp[k] or {}
			-- 		temp[k] = v
			-- 		self.threeTable[k] = nil
			-- 		break
			-- 	end
			end
		end
		dump(temp)
		if getLen(temp) > 0 then
			return true
		else
			return false
		end
	end
end

function AI:chuShuangShun()
	--直接出
	local len = getLen(self.doubleStraightTable)
	local temp = {}
	if len > 0 then
		for k,v in pairsByKeys(self.doubleStraightTable) do
			temp = v
			table.remove(self.doubleStraightTable, k)
			break
		end
	end
	dump(temp)
	if getLen(temp) > 0 then
		return true
	else
		return false
	end
end

function AI:chuShunZi()
	--直接出
	local len = getLen(self.straightTable)
	local temp = {}
	-- dump(self.straightTable)
	if len > 0 then
		for k,v in pairsByKeys(self.straightTable) do
			temp = v
			self.straightTable[k] = nil
			table.remove(self.straightTable, k)
			break
		end
	end
	dump(temp)
	-- dump(self.straightTable)
	if getLen(temp) > 0 then
		return true
	else
		return false
	end
end

function AI:chuSanShun()
	--因为三顺出牌可以带两张（或更多）单牌或两个（或更多）对子，所以与出三条一样，
	--需要检测是否有单牌或对子。如果有足够多的单牌或对子， 则将其带出。如果有单牌，
	--但没有足够多的单牌，则检查是否有6连以上的连牌，如果有将连牌的最小张数当作单牌带出。
	--如果有对子，但没有足够多的对子，则检 查是否有4连以上的双顺，如果有将双顺的最小对子当作对子带出。
	--在带牌时，除非是只剩两手牌，否则不能带王或2。 
	local len = getLen(self.threethreeTable)
	local temp = {}
	if len > 0 then
		print("三顺")
		local threeNum = 0
		for k,v in pairsByKeys(self.threethreeTable) do
			-- temp[k] = temp[k] or {}
			temp = v
			threeNum = getLen(v)
			self.threethreeTable[k] = nil
			break
		end
		local num = self:getHandCardNum()
		local listNum = getLen(self.list)
		local doubleNum = getLen(self.doubleTable)
		if getLen(self.list) >= threeNum then
			local index = 1
			for k,v in pairsByKeys(self.list) do
				if index > threeNum then
					break
				end
				temp[k] = temp[k] or {}
				temp[k] = v
				self.list[k] = nil
				index = index + 1
 	        end 
		elseif getLen(self.doubleTable) >= threeNum then
			local index = 1
			for k,v in pairsByKeys(self.doubleTable) do
				if index > threeNum then
					break
				end
				temp[k] = temp[k] or {}
				temp[k] = v
				self.doubleTable[k] = nil
				index = index + 1
 	        end
        else 
        	if listNum > 0 then
        		dump(self.straightTable)
        		for k,v in pairsByKeys(self.straightTable) do
        			if getLen(v) >= 5 + threeNum - listNum then
        				local index = 1
        				for k1,v1 in pairsByKeys(v) do
        					if index > threeNum - listNum then
        						break
        					end
        					temp[k1] = temp[k1] or {}
        					temp[k1] = v1
        					v[k1] = nil
        					index = index + 1
        				end
        				for k1,v1 in pairs(self.list) do
        					temp[k1] = temp[k1] or {}
        					temp[k1] = v1
        					self.list[k1] = nil
        				end
        				break
        			end
        		end
        		dump(self.straightTable)
        	elseif doubleNum > 0 then
        		for k,v in pairsByKeys(self.doubleStraightTable) do
        			if getLen(v) >= 3 + threeNum - doubleNum then
        				local index = 1
        				for k1,v1 in pairsByKeys(v) do
        					if index > threeNum - doubleNum then
        						break
        					end
        					temp[k1] = temp[k1] or {}
        					temp[k1] = v1
        					v[k1] = nil
        					index = index + 1
        				end
        				for k1,v1 in pairs(self.doubleTable) do
        					temp[k1] = temp[k1] or {}
        					temp[k1] = v1
        					self.doubleTable[k1] = nil
        				end
        				break
        			end
        		end
        	else
        		print("=======")
        	end
		end
	end
	dump(temp)
	-- dump(self.straightTable)
	if getLen(temp) > 0 then
		return true
	else
		return false
	end
end

function AI:chuSanTiao()
	--2 三条的出牌原则：因为三条出牌可以带一张单牌或一个对子，所以在出三条时需要检测是否有单牌，
	--如果有，则带一张最小的单牌，如果没有，则再检测是否存在对子，如果有，则跟一个最小的对子，
	--如果单牌和对子都没有，则出三条。          在带牌时，除非是只剩两手牌，否则不能带王或2。          
	local len = getLen(self.threeTable)
	local temp = {}
	if len > 0 then
		local num = self:getHandCardNum()
		if getLen(self.list) > 0 then
			for k,v in pairsByKeys(self.list) do
				if k > 14 then
					if num == 2 then
						temp[k] = temp[k] or {}
						temp[k] = v
						self.list[k] = nil
					end
				else 
					temp[k] = temp[k] or {}
					temp[k] = v
					self.list[k] = nil
				end
				break
			end
		else
			for k,v in pairsByKeys(self.doubleTable) do
				if k > 14 then
					if num == 2 then
						temp[k] = temp[k] or {}
						temp[k] = v
						self.list[k] = nil
					end
				else 
					temp[k] = temp[k] or {}
					temp[k] = v
					self.list[k] = nil
				end
				break
			end
		end
		for k,v in pairsByKeys(self.threeTable) do
			temp[k] = temp[k] or {}
			temp[k] = v
			self.list[k] = nil	
			break
		end
	end
	dump(temp)
	-- dump(self.straightTable)
	if getLen(temp) > 0 then
		return true
	else
		return false
	end
end

--出牌
function AI:chupai()
	if self:chudan(1) then
		print("单或者3带1")
	elseif self:chudan() then
		print("双或者三带二")
	elseif self:chuShuangShun() then
		print("双顺")
	elseif self:chuShunZi() then
		print("顺子")
	elseif self:chuSanShun() then
		print("出三顺")		
	elseif self:chuSanTiao() then
		print("出三条")
	end
end

--跟牌
function AI:genpai(cardList, cards)

end

return AI