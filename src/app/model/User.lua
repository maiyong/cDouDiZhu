--
-- Author: Your Name
-- Date: 2017-11-27 19:35:35
--
local User = {}
User.__index = User
function User.new(numCards, cards)
	local self = {}
	setmetatable(self, User)
	self.numCards = numCards
	self.cards = cards
	self.isBuJiaoDiZhu = false
	self.isJiaoDiZhu = false
	self.isBeginUser = false
	return self
end

return User