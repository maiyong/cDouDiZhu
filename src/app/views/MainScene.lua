local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local Card = require("app.model.Card")
require("app.define")
local TableUtils = require("app.TableUtils")
local mod = require("app.logic.makecards")
local selecteCard = require("app.logic.selectCard")

local AI = require("app.logic.AI")
function MainScene:onCreate()
	local layer = cc.Layer:create()
	self:addChild(layer)
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	spriteFrameCache:addSpriteFrames("frame/card.plist")
	spriteFrameCache:addSpriteFrames("bg/background.plist")
	spriteFrameCache:addSpriteFrames("btn/button.plist")
	local bg = cc.Sprite:create()
	bg:setSpriteFrame("bg_1.png")
	bg:setPosition(display.cx, display.cy)
	layer:addChild(bg)

	local stable = cc.Sprite:create()
	stable:setSpriteFrame("bg_table.png")
	stable:setPosition(stable:getContentSize().width/2, display.cy)
	layer:addChild(stable)
	local allCard = mod.makeCards()
	mod.sortCard(allCard)
	-- dump(allCard)
	local beginX = stable:getContentSize().width/4
    for i,v in ipairs(allCard) do
    	local w = 0
    	for j, p in pairsByKeys(v) do
			for k,q in pairsByKeys(p) do
				local card = nil
				if i == 1 then
		    		card = Card.new(q, j, "middle")
					card:setPosition(beginX * 1.6 + w * card:getWidth() * 0.6, display.top - card:getHeight() * 0.8)
					w = w + 1
					stable:addChild(card)	    
				else
					card = Card.new(q, j, "big")
					w = w + 1
					stable:addChild(card)
				end	
				TableUtils.insertCardList(i, card)
			end
		end
    end
    local myCardList = TableUtils.getCardList(2)
    self:refreshCard1Position()

	local leftCardList = TableUtils.getCardList(3)
	local beginY = (display.height + 50 - (25 * (#leftCardList - 1) + leftCardList[1]:getWidth()))/2
	for i, v in pairsByKeys(leftCardList) do
		v:setRotation(90)
		v:setScale(0.8)
		v:changePosition()
		v:setPosition(v:getHeight() * 0.6 * 0.8, beginY + i * 25 * 0.8)
	end
	local rightCardList = TableUtils.getCardList(4)
	for i, v in pairsByKeys(rightCardList) do
		v:setRotation(-90)
		v:setScale(0.8)
		v:setPosition(display.width - v:getHeight() * 0.6 * 0.8, beginY + i * 25 * 0.8)
	end

	local chupaiTable = {}
	local chupai = cc.Sprite:create("btn/btn_blue_small.png")
	-- chupai:init("btn_blue_big_1.png", "btn_blue_big_2.png", "btn_blue_big_1.png", ccui.TextureResType.plistType)
	chupai:setPosition(display.cx, myCardList[1]:getPositionY() + chupai:getContentSize().height * 1.5 + myCardList[1]:getHeight()/2)
	local font = cc.Sprite:create("fonts/btnfont_chupai.png")
	font:setPosition(chupai:getContentSize().width/2, chupai:getContentSize().height/2 - 3)
	chupai:addChild(font)

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		local location = touch:getLocation()
		local node = event:getCurrentTarget()
		local locationInNode = node:convertToNodeSpace(location)
		local size = node:getContentSize()
		local rect = cc.rect(33, 0, size.width * 0.62, size.height * 960/1000)
		if cc.rectContainsPoint(rect, locationInNode) then
			node:runAction(cc.ScaleTo:create(0.1, 0.9))
			return true
		end
		return false
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function (touch, event)
		-- body
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
		local node = event:getCurrentTarget()
		node:runAction(cc.ScaleTo:create(0.1, 1.0))
		local w = 0
		for i = #TableUtils.getCardList(2), 1, -1 do
			card = TableUtils.getCardList(2)[i]
			if not card.isSelected then
				--出牌
				w = w + 1
				TableUtils.removeCardFromList(2, card)
				table.insert(chupaiTable, card)
				-- card:removeFromParent()
				-- card:setPosition(display.cx + w * 25, display.cy)
			end
		end
		local beginX = (display.width - (25 * (#chupaiTable - 1) + chupaiTable[1]:getWidth()))/2
		w = 0
		local zOrder = 1
		for i = #chupaiTable, 1 , -1 do
			v = chupaiTable[i]
			w = w + 1
			v:setPosition(beginX + w * 25, display.cy)
			v:setLocalZOrder(zOrder)
			zOrder = zOrder + 1
			-- layer:addChild(v)
		end
		self:refreshCard1Position()
	end, cc.Handler.EVENT_TOUCH_ENDED)
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, chupai)
	layer:addChild(chupai)
	self:initClickListener(layer)
	local ai = AI.new(allCard[2])
	ai:getHandCardNum()
	-- AI.new(allCard[3])
	-- AI.new(allCard[4])
end

function MainScene:refreshCard1Position()
    local myCardList = TableUtils.getCardList(2)
    if #myCardList <= 0 then return end
    local beginX = (display.width - (25 * (#myCardList - 1) + myCardList[1]:getWidth()))/2
	for i, v in pairsByKeys(myCardList) do
		v:setPosition(beginX + 50 + (i - 1) * 25 , v:getHeight() * 0.6)
	end
end

function MainScene:initClickListener(layer)
	local beginPos = nil
	local endPos = nil
	local movePos = nil 
	local testTable = {}	--选牌临时table
	self.selectedTable = {}	--选中的牌
	local oldtime = 0
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		beginPos = touch:getLocation()
		movePos = nil
		movePos = nil
		testTable = {}
		self.selectedTable = {}
		for i,v in ipairs(TableUtils.getCardList(2)) do
			testTable[i] = v
		end
		return true
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function (touch, event)
		movePos = touch:getLocation()
  		selecteCard.selectedCards(beginPos, movePos, testTable, self.selectedTable)
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
		endPos = touch:getLocation()
		local isClick = true
		if not movePos or math.abs(endPos.x - beginPos.x) < 23 then
			if selecteCard.selectOneCard(endPos) then
				isClick = false
			end
		end
		for i = #self.selectedTable, 1, -1 do
			self.selectedTable[i]:selected()
			isClick = false
		end
		if os.time() - oldtime < 1 and isClick then   --放下牌
			selecteCard.unSelectedAllCard(endPos)
		else 
			oldtime = os.time()
		end
		print("======touchX=" .. touch:getLocation().x)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(function (touch, event)
	end, cc.Handler.EVENT_TOUCH_CANCELLED)
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
end

return MainScene
