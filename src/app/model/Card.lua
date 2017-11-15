--
-- Author: Your Name
-- Date: 2017-10-09 17:27:28
--

-- require("app.define")
local TagUtils = require("app.TagUtils")
require("app.define")
local Card = class("Card", function ()
	return cc.Node:create()
end)


function Card:ctor(cardType, cardNum, cardSize)
	self.isSelected = true
	self.cardNum = cardNum
	self.cardType = cardType
	self:initBG(cardSize)
	local numUpSprite = cc.Sprite:create() --上面数字
	local numDownSpite = cc.Sprite:create() --下面数字
	local typeSprite = cc.Sprite:create() --花色类型
	if cardSize == "big" then
		self:initBigSprite(numUpSprite, numDownSpite, typeSprite, cardType, cardNum)
	elseif cardSize == "middle" then
		self:initMiddleSprite(numUpSprite, numDownSpite, typeSprite, cardType, cardNum)
	end
end


function Card:initBG(cardSize)
	local bg = cc.Sprite:create()
	bg:setTag(TagUtils.cardBg)
	if cardSize == "big" then
		bg:setSpriteFrame("card_big.png")
	elseif cardSize == "middle" then
		bg:setSpriteFrame("card_big.png")
		bg:setScale(0.6)
	elseif cardSize == "small" then
		bg:setSpriteFrame("card_small.png")
	end
	self:addChild(bg)	
end

function Card:initMiddleSprite(numUpSprite, numDownSpite, typeSprite, cardType, cardNum)
	local frame = nil
	local typeFrame = nil
	if cardType == CARD_HONGTAO or cardType == CARD_FANGKUAI then
		if cardNum == 14 then
			frame = "red_1.png"
		elseif cardNum == 15 then
			frame = "red_2.png"
		else 
			frame = string.format("red_%d.png", cardNum)
		end
		if cardType == CARD_HONGTAO then
			typeFrame = "hongtao_big.png"
		else
			typeFrame = "fangkuai_big.png"
		end

	elseif cardType == CARD_MEIHUA or cardType == CARD_HEITAO then 
		if cardNum == 14 then
			frame = "black_1.png"
		elseif cardNum == 15 then
			frame = "black_2.png"
		else 
			frame = string.format("black_%d.png", cardNum)
		end

		if cardType == CARD_MEIHUA then
			typeFrame = "meihua_big.png"
		else
			typeFrame = "heitao_big.png"
		end
	elseif cardType == CARD_JOKER then
		if cardNum == 16 then -- 小王
			frame = "black_joker.png"
			typeFrame = "balck_joker_card.png"
		else
			frame = "red_joker.png"
			typeFrame = "red_joker_card.png"
		end
	end

	local bg = self:getChildByTag(TagUtils.cardBg)
	typeSprite:setSpriteFrame(typeFrame)
	if cardType ~= CARD_JOKER then
		typeSprite:setScale(1.5)
	else
		typeSprite:setScale(0.4)
		numUpSprite:setScale(0.5)
		numDownSpite:setScale(0.5)
	end

	typeSprite:setPosition(bg:getContentSize().width/2, bg:getContentSize().height/2)
	bg:addChild(typeSprite)
	numUpSprite:setSpriteFrame(frame)
	numDownSpite:setSpriteFrame(frame)
	
	
	numDownSpite:setRotation(180)

	numUpSprite:setAnchorPoint(0.5, 1)
	numDownSpite:setAnchorPoint(0.5, 1)
	numUpSprite:setPosition(20, 
		bg:getContentSize().height - 15)
	numDownSpite:setPosition(bg:getContentSize().width - 20,
		10)
	bg:addChild(numUpSprite)
	bg:addChild(numDownSpite)
end

function Card:initBigSprite(numUpSprite, numDownSpite, typeSprite, cardType, cardNum)
	local frame = nil   --数字frame
	local typeFrame = nil   --花色frame
	if cardType == CARD_HONGTAO or cardType == CARD_FANGKUAI then
		if cardNum == 14 then
			frame = "red_1.png"
		elseif cardNum == 15 then
			frame = "red_2.png"
		else 
			frame = string.format("red_%d.png", cardNum)
		end
		if cardType == CARD_HONGTAO then
			typeFrame = "hongtao_big.png"
		else
			typeFrame = "fangkuai_big.png"
		end

	elseif cardType == CARD_MEIHUA or cardType == CARD_HEITAO then 
		if cardNum == 14 then
			frame = "black_1.png"
		elseif cardNum == 15 then
			frame = "black_2.png"
		else 
			frame = string.format("black_%d.png", cardNum)
		end

		if cardType == CARD_MEIHUA then
			typeFrame = "meihua_big.png"
		else
			typeFrame = "heitao_big.png"
		end
	elseif cardType == CARD_JOKER then
		if cardNum == 16 then -- 小王
			frame = "black_joker.png"
			typeFrame = "balck_joker_card.png"
		else
			frame = "red_joker.png"
			typeFrame = "red_joker_card.png"
		end
	end 	

	local bg = self:getChildByTag(TagUtils.cardBg)
	typeSprite:setSpriteFrame(typeFrame)
	typeSprite:setPosition(bg:getContentSize().width/2, bg:getContentSize().height/2)
	bg:addChild(typeSprite)
	numUpSprite:setSpriteFrame(frame)
	numUpSprite:setTag(TagUtils.cardUpNum)
	numDownSpite:setSpriteFrame(frame)
	numDownSpite:setTag(TagUtils.cardDownNum)
	
	numUpSprite:setScale(0.6)
	numDownSpite:setScale(0.6)
	
	numDownSpite:setRotation(180)

	numUpSprite:setAnchorPoint(0.5, 1)
	numDownSpite:setAnchorPoint(0.5, 1)
	numUpSprite:setPosition(15, 
		bg:getContentSize().height - 15)
	numDownSpite:setPosition(bg:getContentSize().width - 15,
		10)
	bg:addChild(numUpSprite)
	bg:addChild(numDownSpite)
	if cardType ~= CARD_JOKER then
		local typeUpSprite = cc.Sprite:create()
		local typeDownSprite = cc.Sprite:create()
		typeUpSprite:setSpriteFrame(typeFrame)
		typeUpSprite:setTag(TagUtils.cardUpType)
		typeUpSprite:setScale(0.7)
		typeUpSprite:setPosition(numUpSprite:getPositionX(), numUpSprite:getPositionY() - 40)
		bg:addChild(typeUpSprite)

		typeDownSprite:setSpriteFrame(typeFrame)
		typeDownSprite:setScale(0.7)
		typeDownSprite:setTag(TagUtils.cardDownType)
		typeDownSprite:setRotation(180)
		typeDownSprite:setPosition(numDownSpite:getPositionX(), numDownSpite:getPositionY() + 40)
		bg:addChild(typeDownSprite)
	end
end

function Card:changePosition()
	local bg = self:getChildByTag(TagUtils.cardBg)
	local upNum = bg:getChildByTag(TagUtils.cardUpNum)
	upNum:setPosition(bg:getContentSize().width - 15, bg:getContentSize().height - 15)
	local upType = bg:getChildByTag(TagUtils.cardUpType)
	if upType then
		upType:setPosition(upNum:getPositionX(), upNum:getPositionY() - 40)
	end
	local downNum = bg:getChildByTag(TagUtils.cardDownNum)
	downNum:setPosition(15, 10)
	local downType = bg:getChildByTag(TagUtils.cardDownType)
	if downType then
		downType:setPosition(downNum:getPositionX(), downNum:getPositionY() + 40)
	end
end

function Card:selected()
	if self.isSelected then
		self:setPosition(self:getPositionX(), self:getPositionY() * 1.2)
		self.isSelected = false
	else
		self:setPosition(self:getPositionX(), self:getPositionY() / 1.2 )
		self.isSelected = true
	end
end

function Card:getHeight()
	return self:getChildByTag(TagUtils.cardBg):getContentSize().height
end

function Card:getWidth()
	return self:getChildByTag(TagUtils.cardBg):getContentSize().width
end

return Card