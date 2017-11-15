--
-- Author: Your Name
-- Date: 2017-10-20 22:25:22
--
local selectedCard = {}
local TableUtils = require("app.TableUtils")

--选择多张卡
function selectedCard.selectedCards(beginPos, endPos, testTable, selectedTable)
	local locationInWorld = endPos
	-- local x = card:getPositionX()  
	-- local y = card:getPositionY()
	local list = TableUtils.getCardList(2)
	local flag = false
	for i = #testTable, 1, -1 do
		local lastCard = list[i + 1]
		local card = testTable[i]
		local x = card:getPositionX()  
		local y = card:getPositionY()
		if endPos.x < beginPos.x then  --右向左拖动
			if i == #list then
				flag = true
			else 
				local lastRect = cc.rect(-65, -85, lastCard:getWidth(), lastCard:getHeight()) 
				local lastPos = lastCard:convertToNodeSpace(endPos)
				if cc.rectContainsPoint(lastRect, lastPos) then
					flag = false
				else 
					flag = true
				end
			end
			local rect = cc.rect(-65, -85, card:getWidth(), card:getHeight())
			local locationInNode = card:convertToNodeSpace(endPos)
			if cc.rectContainsPoint(rect, locationInNode) and flag then
				table.insert(selectedTable, testTable[i])
				table.remove(testTable, i)
			end
		else--左向右
			if i == 1 or i == #TableUtils.getCardList(2) then
				flag = true
			else
				local lastRect = cc.rect(-65, -85, lastCard:getWidth(), lastCard:getHeight()) 
				local lastPos = lastCard:convertToNodeSpace(endPos)
				if cc.rectContainsPoint(lastRect, lastPos) then
					flag = false
				else 
					flag = true
				end
			end
			local rect = cc.rect(-65, -85, card:getWidth(), card:getHeight())
			local locationInNode = card:convertToNodeSpace(endPos)
			if cc.rectContainsPoint(rect, locationInNode) then
				table.insert(selectedTable, testTable[i])
				table.remove(testTable, i)
			end
			local oneCard = nil
			for i = #selectedTable, 1, -1 do --移除隐藏背后的卡
				local vCard = selectedTable[i]
				local beginInNode = vCard:convertToNodeSpace(beginPos)
				local rect = cc.rect(-65, -85, vCard:getWidth(), vCard:getHeight())
				if cc.rectContainsPoint(rect, beginInNode) then
					oneCard = vCard
					table.remove(selectedTable, i)
				end
			end
			if oneCard then
				table.insert(selectedTable, oneCard)
			end
		end
	end
end
--选择一张卡
function selectedCard.selectOneCard(endPos)
	local cardList = TableUtils.getCardList(2)
	for i = #cardList, 1, -1 do
		local card = cardList[i]
		local locationInWorld = endPos
		local x = card:getPositionX()  
		local y = card:getPositionY()
		local lastCard = cardList[i + 1]
		local flag = false
		
		if i == #cardList then
			flag = true
		else 
			local lastRect = cc.rect(-65, -85, lastCard:getWidth(), lastCard:getHeight()) 
			local lastPos = lastCard:convertToNodeSpace(endPos)
			if cc.rectContainsPoint(lastRect, lastPos) then
				flag = false
			else 
				flag = true
			end
		end
		local rect = cc.rect(-65, -85, card:getWidth(), card:getHeight())
		local locationInNode = card:convertToNodeSpace(endPos)
		if cc.rectContainsPoint(rect, locationInNode) and flag then
			card:selected()
			return true
		end
	end
	return false
end

function selectedCard.unSelectedAllCard(endPos)
	local flag = true
	for i,card in ipairs(TableUtils.getCardList(2)) do
		local endPosInNode = card:convertToNodeSpace(endPos)
		local rect = cc.rect(-65, -85, card:getWidth(), card:getHeight())
		if cc.rectContainsPoint(rect, endPosInNode) then
			flag = false
		end
	end
	if flag then
		--放下所有牌
		for i,v in ipairs(TableUtils.getCardList(2)) do
			if not v.isSelected then
				v:selected()
			end
		end
	end
end

return selectedCard