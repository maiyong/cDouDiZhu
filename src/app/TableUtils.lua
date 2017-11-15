--
-- Author: Your Name
-- Date: 2017-10-16 09:24:13
--
local TableUtils = {}

local cardList = {}

function TableUtils.insertCardList(index, card)
	if not cardList[index] then
		cardList[index] = {}
	end
	table.insert(cardList[index], card)
end

function TableUtils.getCardList(index)
	return cardList[index]
end

function TableUtils.removeCardFromList(index, card)
	for i, v in ipairs(cardList[index]) do
		if card == cardList[index][i] then
			table.remove(cardList[index], i)
		end
	end
end

return TableUtils