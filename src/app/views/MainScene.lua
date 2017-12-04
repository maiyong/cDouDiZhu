local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local Card = require("app.model.Card")
require("app.define")
local TableUtils = require("app.TableUtils")
local TagUtils = require("app.TagUtils")
local mod = require("app.logic.makecards")
local selecteCard = require("app.logic.selectCard")
local User = require("app.model.User")
local currUser = 2 --2为中间，3为右边，4为左边
local beginUser = 0
local nextUser = 0
local AI = require("app.logic.AI")
local centerUser = nil
local rightUser = nil
local leftUser = nil
local scheduleEntry = nil
local AIUtils = require("app.logic.AIUtils")
local JiaoDiZhu = require("app.logic.JiaoDiZhu")
function MainScene:onCreate()
	local layer = cc.Layer:create()
	layer:setTag(TagUtils.mainLayer)
	self:addChild(layer)
	self:initSpriteFrameCache() --加载plist缓存
	local allCard = mod.makeCards() --生成牌
	self:initBackgroundUI(layer, allCard) --加载背景图片并把牌加载到背景
	-- mod.sortCard(allCard)
	-- dump(allCard)
	centerUser = User.new(AI.new(allCard[2]), TableUtils.getCardList(2))
	rightUser = User.new(AI.new(allCard[3]), TableUtils.getCardList(3))
	leftUser = User.new(AI.new(allCard[4]), TableUtils.getCardList(4))

    self:setCenterUserPosition()

	self:setLeftUserPosition()   -- 设置左用户位置

	self:setRightUserPosition()  --设置右用户位置

	self:initClickListener(layer) --选牌listener

	-- self:createChuPaiButton(layer) 

	--随机地主
	beginUser = math.random(2,4) --
	currUser = beginUser
	print("=====地主" .. beginUser)

	-- centerUser:getHandCardNum()
	-- centerUser:getHandCardScore()
    beginUser = 3
    if beginUser == LEFT_USER then
    	leftUser.isBeginUser = true
    elseif beginUser == CENTER_USER then
    	centerUser.isBeginUser = true
	elseif beginUser == RIGHT_USER then
		rightUser.isBeginUser = true
	end

	--叫地主
	JiaoDiZhu.jiaoDiZhu(beginUser, leftUser, rightUser, centerUser, handler(self, self.createJiaoDiZhuButton), 
	handler(self, self.removeCallDZLayer), handler(self, self.createChuPaiButton))
	local button = ccui.Button:create("ftn_jiao.png", "ftn_jiao.png", "ftn_jiao.png", ccui.TextureResType.plistType)
	button:addTouchEventListener(function (sender, state)
		if state == 2 then
			print("fuck")
			self:reStart()
		end
	end)
	button:setPosition(0, display.top)
	layer:addChild(button)
end

function MainScene:reStart()
	TableUtils.clear()
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleEntry)
    local scene = display.newScene("mainScene")
	scene:addChild(require("app.views.MainScene").new())
	display.runScene(scene)
end

function MainScene:createJiaoDiZhuButton(tType) -- 1叫地主 --2抢地主
	if tType == 2 then
		self:removeCallDZLayer()
	end
	local layer = self:getChildByTag(TagUtils.mainLayer)
	local callDZLayer = cc.Layer:create()
	callDZLayer:setTag(TagUtils.callDZLayer)
	layer:addChild(callDZLayer)
	--[[铃铛--]]
	local clockBg = cc.Sprite:create("frame/clock.png")
	clockBg:setPosition(display.cx,  centerUser.cards[1]:getPositionY() + clockBg:getContentSize().height * 1.5 + centerUser.cards[1]:getHeight()/2)
	callDZLayer:addChild(clockBg)
	local timeShi = cc.Sprite:createWithSpriteFrameName("font_2_2.png")
	local timeGe = cc.Sprite:createWithSpriteFrameName("font_2_0.png")
	timeShi:setScale(0.8, 0.8)
	clockBg:addChild(timeShi)
	timeShi:setPosition(clockBg:getContentSize().width/2 - timeShi:getContentSize().width/3, clockBg:getContentSize().height/2 -5)
	clockBg:addChild(timeGe)
	timeGe:setScale(0.8, 0.8)
	timeGe:setPosition(clockBg:getContentSize().width/2 + timeGe:getContentSize().width/3, clockBg:getContentSize().height/2 - 5)
	local time = 20
	scheduleEntry = clockBg:getScheduler():scheduleScriptFunc(function ()
		time = time - 1
		if time < 0 then
			-- self:removeCallDZLayer()
			return
		end
		timeShi:setSpriteFrame(string.format("font_2_%d.png", time/10))
		timeGe:setSpriteFrame(string.format("font_2_%d.png", time%10))
	end, 1, false)
    --[[地主按钮--]]
	local jdzBg = cc.Sprite:create("btn/btn_yellow_small.png")
	callDZLayer:addChild(jdzBg)
	jdzBg:setPosition(clockBg:getPositionX() + jdzBg:getContentSize().width * 2/3, clockBg:getPositionY())
	jdzBg:setTag(TagUtils.jdzBtnTag)

	local frameName = "ftn_jiao.png"
	if tType == 2 then
		frameName = "ftn_qiang.png"
	end
	local jdz_jText = cc.Sprite:createWithSpriteFrameName(frameName)
	local jdz_dText = cc.Sprite:createWithSpriteFrameName("ftn_di.png")
	local jdz_zText = cc.Sprite:createWithSpriteFrameName("ftn_zhu.png")
	jdzBg:addChild(jdz_jText)
	jdz_jText:setPosition(jdzBg:getContentSize().width/2 - jdz_jText:getContentSize().width/2 - 5, jdzBg:getContentSize().height/2 - 5)
	jdz_jText:setScale(0.6, 0.6)
	jdzBg:addChild(jdz_dText)
	jdz_dText:setScale(0.6, 0.6)
	jdz_dText:setPosition(jdzBg:getContentSize().width/2, jdzBg:getContentSize().height/2 - 5)
	jdzBg:addChild(jdz_zText)
	jdz_zText:setScale(0.6, 0.6)
	jdz_zText:setPosition(jdzBg:getContentSize().width/2 + jdz_jText:getContentSize().width/2 + 5, jdzBg:getContentSize().height/2 - 5)
	local bjdzBg = cc.Sprite:create("btn/btn_yellow_small.png") 
	bjdzBg:setTag(TagUtils.bjdzBtnTag)
	bjdzBg:setPosition(clockBg:getPositionX() - bjdzBg:getContentSize().width * 2/3, clockBg:getPositionY())
	local bjdz_bText = cc.Sprite:createWithSpriteFrameName("ftn_bu.png")
	local bjdz_jText = cc.Sprite:createWithSpriteFrameName(frameName)
	bjdzBg:addChild(bjdz_bText)
	bjdzBg:addChild(bjdz_jText)
	bjdz_bText:setScale(0.6, 0.6)
	bjdz_jText:setScale(0.6, 0.6)
	bjdz_bText:setPosition(jdzBg:getContentSize().width/2 - bjdz_jText:getContentSize().width/2,jdzBg:getContentSize().height/2 - 5)
	bjdz_jText:setPosition(jdzBg:getContentSize().width/2 + bjdz_jText:getContentSize().width/2,jdzBg:getContentSize().height/2 - 5)
	callDZLayer:addChild(bjdzBg)

	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		local location = touch:getLocation()
		local node = event:getCurrentTarget()
		local locationInNode = node:convertToNodeSpace(location)
		local rect = cc.rect(0, 0, node:getContentSize().width, node:getContentSize().height)
		if cc.rectContainsPoint(rect, locationInNode) then
			node:setScale(0.9, 0.9)
			return true
		end
		return false
	end, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(function (touch, event)
		-- body
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
		local node = event:getCurrentTarget()
		node:setScale(1.0, 1.0)
		if tType == 1 then --叫地主
			JiaoDiZhu.centerJiaoDiZhu(node:getTag(), centerUser, leftUser, rightUser,
				handler(self, self.reStart), handler(self, self.removeCallDZLayer),
				handler(self, self.createChuPaiButton),handler(self,self.createJiaoDiZhuButton))
		else
			JiaoDiZhu.centerQiangDiZhu(node:getTag(), leftUser, rightUser, centerUser, 
				handler(self,self.removeCallDZLayer), handler(self,self.createChuPaiButton),
				handler(self,self.createJiaoDiZhuButton))	
		end
	end, cc.Handler.EVENT_TOUCH_ENDED)

	local listener2 = listener:clone()

	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, jdzBg)
	dispatcher:addEventListenerWithSceneGraphPriority(listener2, bjdzBg)
end

function MainScene:removeCallDZLayer()
	local a = self:getChildByTag(TagUtils.mainLayer)
	local b = a:getChildByTag(TagUtils.callDZLayer)
	if b then
		b:removeFromParent()
	end
	if scheduleEntry then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleEntry)
	end
	print("停掉监听器")
end

function MainScene:createChuPaiButton()
	print("====创建啊")
	local layer = self:getChildByTag(TagUtils.mainLayer)
	local callDZLayer = cc.Layer:create()
	callDZLayer:setTag(TagUtils.callDZLayer)
	layer:addChild(callDZLayer)
	--[[铃铛--]]
	local clockBg = cc.Sprite:create("frame/clock.png")
	clockBg:setPosition(display.cx,  centerUser.cards[1]:getPositionY() + clockBg:getContentSize().height * 1.5 + centerUser.cards[1]:getHeight()/2)
	callDZLayer:addChild(clockBg)
	local timeShi = cc.Sprite:createWithSpriteFrameName("font_2_2.png")
	local timeGe = cc.Sprite:createWithSpriteFrameName("font_2_0.png")
	timeShi:setScale(0.8, 0.8)
	clockBg:addChild(timeShi)
	timeShi:setPosition(clockBg:getContentSize().width/2 - timeShi:getContentSize().width/3, clockBg:getContentSize().height/2 -5)
	clockBg:addChild(timeGe)
	timeGe:setScale(0.8, 0.8)
	timeGe:setPosition(clockBg:getContentSize().width/2 + timeGe:getContentSize().width/3, clockBg:getContentSize().height/2 - 5)
	local time = 20
	scheduleEntry = clockBg:getScheduler():scheduleScriptFunc(function ()
		time = time - 1
		if time < 0 then
			-- self:removeCallDZLayer()
			return
		end
		timeShi:setSpriteFrame(string.format("font_2_%d.png", time/10))
		timeGe:setSpriteFrame(string.format("font_2_%d.png", time%10))
	end, 1, false)
	local chupaiTable = {}
	local chupaiTable_old = {}
	local chupai = cc.Sprite:create("btn/btn_blue_small.png")
	chupai:setTag(TagUtils.cpBtnTag)
	-- chupai:init("btn_blue_big_1.png", "btn_blue_big_2.png", "btn_blue_big_1.png", ccui.TextureResType.plistType)
	chupai:setPosition(clockBg:getPositionX() + chupai:getContentSize().width * 2/3, clockBg:getPositionY())
	local chupai_text = cc.Sprite:create("fonts/btnfont_chupai.png")
	chupai_text:setPosition(chupai:getContentSize().width/2, chupai:getContentSize().height/2 - 3)
	chupai:addChild(chupai_text)

	local buchu = cc.Sprite:create("btn/btn_blue_small.png")
	buchu:setTag(TagUtils.byBtnTag)
	buchu:setPosition(clockBg:getPositionX() - buchu:getContentSize().width * 2/3, clockBg:getPositionY())
	local buchu_text = cc.Sprite:create("fonts/btnfont_buyao.png")
	buchu_text:setPosition(buchu:getContentSize().width/2, buchu:getContentSize().height/2 - 3)
	buchu:addChild(buchu_text)

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
	end, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(function (touch, event)
		local node = event:getCurrentTarget()
		chupaiTable = {}
		node:runAction(cc.ScaleTo:create(0.1, 1.0))
		if node:getTag() == TagUtils.byBtnTag then
			print("不要，到下家")
		else
			local w = 0
			local temp = {}
			for i = #centerUser.cards, 1, -1 do
				card = centerUser.cards[i]
				if not card.isSelected then
					--出牌
					w = w + 1
					table.insert(chupaiTable, card)
					temp[card.cardNum] = temp[card.cardNum] or {}
					table.insert(temp[card.cardNum], card.cardType)
				end
			end
			dump(temp)
			if not AIUtils.isAccord(temp) then
				print("你的牌不符合标准")
				return 
			end
			if getLen(chupaiTable_old) >0 then
				for k,v in pairs(chupaiTable_old) do
					v:removeFromParent()
				end
			end
			chupaiTable_old = chupaiTable
			for i,v in ipairs(chupaiTable) do
				TableUtils.removeCardFromList(2, v)
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
			self:setCenterUserPosition()
		end

	end, cc.Handler.EVENT_TOUCH_ENDED)
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	local buchu_listener = listener:clone()
	dispatcher:addEventListenerWithSceneGraphPriority(buchu_listener, buchu)
	dispatcher:addEventListenerWithSceneGraphPriority(listener, chupai)
	callDZLayer:addChild(chupai)
	callDZLayer:addChild(buchu)
end

function MainScene:setCenterUserPosition()
    local myCardList = centerUser.cards
    if #myCardList <= 0 then return end
    local beginX = (display.width - (25 * (#myCardList - 1) + myCardList[1]:getWidth()))/2
	for i, v in pairsByKeys(myCardList) do
		v:setPosition(beginX + 50 + (i - 1) * 25 , v:getHeight() * 0.6)
	end
end

function MainScene:setRightUserPosition()
	local rightCardList = TableUtils.getCardList(3)
	local beginY = (display.height + 50 - (25 * (#rightCardList - 1) + rightCardList[1]:getWidth()))/2
	for i, v in pairsByKeys(rightCardList) do
		v:setRotation(-90)
		v:setScale(0.8)
		v:setPosition(display.width - v:getHeight() * 0.6 * 0.8, beginY + i * 25 * 0.8)
	end
end

function MainScene:setLeftUserPosition()
	local leftCardList = TableUtils.getCardList(4)
	local beginY = (display.height + 50 - (25 * (#leftCardList - 1) + leftCardList[1]:getWidth()))/2
	for i, v in pairsByKeys(leftCardList) do
		v:setRotation(90)
		v:setScale(0.8)
		v:changePosition()
		v:setPosition(v:getHeight() * 0.6 * 0.8, beginY + i * 25 * 0.8)
	end
end

function MainScene:initBackgroundUI(layer, allCard)
	local bg = cc.Sprite:create()	--背景
	bg:setSpriteFrame("bg_1.png")
	bg:setPosition(display.cx, display.cy)
	layer:addChild(bg)

	local stable = cc.Sprite:create()
	stable:setSpriteFrame("bg_table.png")
	stable:setPosition(stable:getContentSize().width/2, display.cy)
	layer:addChild(stable)

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
end

function MainScene:initSpriteFrameCache()
	local spriteFrameCache = cc.SpriteFrameCache:getInstance()
	spriteFrameCache:addSpriteFrames("frame/card.plist")
	spriteFrameCache:addSpriteFrames("bg/background.plist")
	spriteFrameCache:addSpriteFrames("btn/button.plist")
	display.loadSpriteFrames("fonts/font.plist", "fonts/font.png")
end

function MainScene:initClickListener(layer)
	local beginPos = nil
	local endPos = nil
	local movePos = nil 
	local testTable = {}	--选牌临时table
	self.selectedTable = {}	--选中的牌
	-- local oldtime = 0
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:setSwallowTouches(true)
	listener:registerScriptHandler(function (touch, event)
		beginPos = touch:getLocation()
		movePos = nil
		movePos = nil
		testTable = {}
		self.selectedTable = {}
		for i,v in ipairs(centerUser.cards) do
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
		-- if os.time() - oldtime < 1 and isClick then   --放下牌
		-- 	selecteCard.unSelectedAllCard(endPos)
		-- else 
		-- 	oldtime = os.time()
		-- end
		print("======touchX=" .. touch:getLocation().x)
	end, cc.Handler.EVENT_TOUCH_ENDED)
	listener:registerScriptHandler(function (touch, event)
	end, cc.Handler.EVENT_TOUCH_CANCELLED)
	local dispatcher = cc.Director:getInstance():getEventDispatcher()
	dispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
end

return MainScene
