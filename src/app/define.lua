--
-- Author: lin
-- Date: 2017-09-28 11:35:37
-- Desc: 宏定义

-- 卡牌基本花色
CARD_HONGTAO = 3        	-- 红桃
CARD_HEITAO = 4 			-- 黑桃
CARD_MEIHUA = 2 			-- 梅花
CARD_FANGKUAI = 1 			-- 方块
CARD_JOKER = 5 				-- 王

-- 出牌基本类型
HANDOUT_DANGE = 100  		-- 单个
HANDOUT_DUIZI = 101  		-- 对子
HANDOUT_SHUNZI = 102  		-- 顺子
HANDOUT_LIANDUI = 103  		-- 连对
HANDOUT_SANDAI_1 = 104  	-- 三带单
HANDOUT_SANDAI_2 = 105  	-- 三带对子
HANDOUT_FEIJI_1 = 106 		-- 飞机带单
HANDOUT_FEIJI_2 = 107  		-- 飞机带对子
HANDOUT_SIDAIER = 108  		-- 四带二
HANDOUT_ZHADAN = 109 		-- 炸弹
HANDOUT_HUOJIAN = 110  		-- 火箭

--假定火箭为8分，炸弹为6分，大王4分，小王3分，一个2为2分,大于6分就叫地主
LEFT_USER = 4
CENTER_USER = 2
RIGHT_USER = 3

--地主分
DIZHUFEN = 6