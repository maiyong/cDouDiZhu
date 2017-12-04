--
-- Author: Your Name
-- Date: 2017-11-29 19:41:22
--
local JiaoDiZhu = {}
local TagUtils = require("app.TagUtils")
function JiaoDiZhu.jiaoDiZhu(beginUser, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			if beginUser == LEFT_USER then
		if leftUser.numCards:getHandCardScore() >= DIZHUFEN then
			if rightUser.isBuJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				print("都不叫地主，左家是地主")
				return
			end
			print("左边叫地主")
			leftUser.isJiaoDiZhu = true
			createJiaoDiZhuButton(2)
		else
			if rightUser.isBuJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				print("都不叫地主，洗牌")
				return
			end
			print("左家不叫地主")
			leftUser.isBuJiaoDiZhu = true
			createJiaoDiZhuButton(1)
		end
	elseif beginUser == CENTER_USER then
		createJiaoDiZhuButton(1)
	else
		if rightUser.numCards:getHandCardScore() >= DIZHUFEN then
			if leftUser.isBuJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				print("都不叫地主，右家是地主")
				return
			end
			print("右边叫地主")
			rightUser.isJiaoDiZhu = true
			JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
		else
			if leftUser.isBuJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				print("都不叫地主，洗牌")
				return
			end
			print("右家不叫地主")
			rightUser.isBuJiaoDiZhu = true
			JiaoDiZhu.jiaoDiZhu(LEFT_USER, leftUser, rightUser, centerUser, 
				createJiaoDiZhuButton, removeCallDZLayer, createChuPaiButton)
		end
	end
	end

function JiaoDiZhu.qiangDiZhu(beginUser, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
	if beginUser == LEFT_USER then
		if leftUser.numCards:getHandCardScore() >= DIZHUFEN then
			leftUser.isJiaoDiZhu = true
			if rightUser.isJiaoDiZhu and centerUser.isJiaoDiZhu then
				if leftUser.isBeginUser then
					print("左叫，中抢，右家抢，左家再抢地主，抢完收工")
				else 
					print("中叫，右抢，左家抢，到中")
					createJiaoDiZhuButton(2)
				end
			elseif rightUser.isJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				if leftUser.isBeginUser then
					print("左叫，中不叫，右家抢，轮到左抢，收工")
				else
					print("中不叫，右家叫，左抢，轮到右家叫")
					JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
				end
			elseif rightUser.isBuJiaoDiZhu and centerUser.isJiaoDiZhu then
				if leftUser.isBeginUser then
					print("左叫，中抢，右不抢，轮到左抢，完事")
				elseif centerUser.isBeginUser then
					print("中叫，右不抢，左抢，轮到中抢")
					createJiaoDiZhuButton(2)
				else
					print("右不叫，左叫，中抢，轮到左抢，走完")
				end
			elseif rightUser.isBuJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				print("左来做地主")
			elseif rightUser.isJiaoDiZhu then
				print("右家叫，左抢，轮到中家")
				createJiaoDiZhuButton(2)
			else
				print("=========304")
			end
		else
			leftUser.isBuJiaoDiZhu = true
			if rightUser.isJiaoDiZhu and centerUser.isJiaoDiZhu then
				if leftUser.isBeginUser then
					print("左不叫，中抢，右抢，轮到中")
					-- self:qiangDiZhu(RIGHT_USER)
					createJiaoDiZhuButton(2)
				elseif centerUser.isBeginUser then
					print("中叫，右抢，左不抢，到中")
					createJiaoDiZhuButton(2)
				else
					print("右叫，左不抢，中抢，到右")
					JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
				end
			elseif rightUser.isJiaoDiZhu and centerUser.isBuJiaoDiZhu then
				if leftUser.isBeginUser then
					print("右家为地主")
				else
					print("中不叫，右家叫，左不叫，右家为地主")
				end
			elseif rightUser.isBuJiaoDiZhu and centerUser.isJiaoDiZhu then
				if leftUser.isBeginUser then
					print("左不叫，中叫，右不抢，中为地主，到不了")
				else
					print("中叫，右不抢，左不抢，中为地主")
					removeCallDZLayer()
					createChuPaiButton()
					-- self:qiangDiZhu(RIGHT_USER)
				end
			elseif rightUser.isJiaoDiZhu then
				print("右家叫，左不抢，轮到中家")
				createJiaoDiZhuButton(2)
			else
				print("=======334")
			end
		end
	else
		if rightUser.numCards:getHandCardScore() >= DIZHUFEN then
			rightUser.isJiaoDiZhu = true
			if centerUser.isJiaoDiZhu and leftUser.isJiaoDiZhu then
				if rightUser.isBeginUser then
					print("右叫，左抢，中抢，右家再抢地主，抢完收工")
				else
					print("左叫，中抢，右抢，到左")
					JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
				end
			elseif centerUser.isJiaoDiZhu and leftUser.isBuJiaoDiZhu then
				if rightUser.isBeginUser then
					print("右叫，左不抢，中抢，轮到右抢，收工")
				else
					print("左不叫，中叫，右抢，轮到中家")
					createJiaoDiZhuButton(2)
				end
			elseif centerUser.isBuJiaoDiZhu and leftUser.isJiaoDiZhu then
				if rightUser.isBeginUser then
					print("右叫，左抢，中不抢，轮到右抢，完事")
				elseif centerUser.isBeginUser then
					print("中不叫，右叫，左抢，右抢，完事")
				else
					print("左叫，中不抢，右抢，轮到左")
					JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
				end
			elseif centerUser.isBuJiaoDiZhu and leftUser.isBuJiaoDiZhu then
				print("右来做地主")
			elseif centerUser.isJiaoDiZhu then
				print("中叫，右抢，轮到左家")
				JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			else
				print("-=======366")
			end
		else
			rightUser.isBuJiaoDiZhu = true
			if centerUser.isJiaoDiZhu and leftUser.isJiaoDiZhu then
				if rightUser.isBeginUser then
					print("右不叫，左叫，中抢，轮到左")
					-- self:qiangDiZhu(RIGHT_USER)
					JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
				else
					print("左叫，中抢，右不抢，左地主")
					JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
				end
			elseif centerUser.isJiaoDiZhu and leftUser.isBuJiaoDiZhu then
				if rightUser.isBeginUser then
					print("右不叫，左不叫，中叫，中为地主")
					removeCallDZLayer()
					createChuPaiButton()
				else
					print("左不叫，中叫，右叫，中家为地主")
					removeCallDZLayer()
					createChuPaiButton()
					-- self:qiangDiZhu(LEFT_USER)
				end
			elseif centerUser.isBuJiaoDiZhu and leftUser.isJiaoDiZhu then
				if rightUser.isBeginUser then
					print("右不叫，左叫，中不抢，左为地主，到不了")
				else
					print("左叫，中不抢，右不抢，左为地主")
					-- self:qiangDiZhu(RIGHT_USER)
				end
			elseif centerUser.isJiaoDiZhu then
				print("中叫，右不抢，轮到左")
				JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			else
				print("=====396")
			end
		end
	end
end

function JiaoDiZhu.centerJiaoDiZhu(nodeTag, centerUser, leftUser, rightUser, 
	reStart, removeCallDZLayer, createChuPaiButton, createJiaoDiZhuButton)
	if nodeTag == TagUtils.bjdzBtnTag then
		centerUser.isBuJiaoDiZhu = true
		if leftUser.isBuJiaoDiZhu then
			print("左家不叫，我不叫地主")
			JiaoDiZhu.jiaoDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton,
				removeCallDZLayer, createChuPaiButton)
		elseif leftUser.isBuJiaoDiZhu and rightUser.isBuJiaoDiZhu then
			print("都不叫地主, 我不抢，重新洗牌")
			reStart()
		else
			print("我不叫地主")
			JiaoDiZhu.jiaoDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton,
				removeCallDZLayer, createChuPaiButton)
		end 
	elseif nodeTag == TagUtils.jdzBtnTag then
		centerUser.isJiaoDiZhu = true
		if leftUser.isBuJiaoDiZhu then
			print("左家不叫，我叫地主")
			JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
		elseif leftUser.isBuJiaoDiZhu and rightUser.isBuJiaoDiZhu then
			print("都不叫地主, 我抢了就是我的")
			removeCallDZLayer()
			createChuPaiButton()
		else
			print("我叫地主")
			JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)	
		end 
	end	
end

function JiaoDiZhu.centerQiangDiZhu(nodeTag, leftUser, rightUser, centerUser, 
	removeCallDZLayer, createChuPaiButton)
	if nodeTag == TagUtils.bjdzBtnTag then
		if leftUser.isBuJiaoDiZhu and rightUser.isBuJiaoDiZhu then
			print("都不抢地主,我来做地主，开始打牌")
			removeCallDZLayer()
			createChuPaiButton()
			return
		end
		-- print("不抢地主")
		-- self:qiangDiZhu(RIGHT_USER)
		centerUser.isBuJiaoDiZhu = true
		if leftUser.isJiaoDiZhu and rightUser.isJiaoDiZhu then
			if centerUser.isBeginUser then
				print("我叫，右家抢，左家抢，到我不抢地主，<左家为地主>，抢完收工")
				-- self:qiangDiZhu(RIGHT_USER)
			else
				print("右家叫，左家抢，我不抢地主")
				JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			end
		elseif leftUser.isJiaoDiZhu and rightUser.isBuJiaoDiZhu then
			if centerUser.isBeginUser then
				print("我叫，右家不叫，左家抢，轮到我不叫，左家为地主")
			else
				print("右家不叫，左家叫，我不叫，左家为地主")
				-- self:qiangDiZhu(LEFT_USER)
			end
		elseif leftUser.isBuJiaoDiZhu and rightUser.isJiaoDiZhu then
			if centerUser.isBeginUser then
				if centerUser.isJiaoDiZhu then
					print("我叫，右抢，左不抢，轮到我不抢，右家为地主")
				elseif centerUser.isBuJiaoDiZhu then
					print("我不叫，右叫，左不抢，中不抢，右为地主")
				else
					print("lalala")
				end
			else	
				print("右叫，左不抢，我不抢，右为地主")
				-- self:qiangDiZhu(RIGHT_USER)
			end
		elseif leftUser.isJiaoDiZhu then
			print("左家叫，我不抢，轮到右家")
			JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
		else
			print("GGGGG201")
		end
	elseif nodeTag == TagUtils.jdzBtnTag then
		centerUser.isJiaoDiZhu = true
		if leftUser.isJiaoDiZhu and rightUser.isJiaoDiZhu then
			if centerUser.isBeginUser then
				print("中叫，右家抢，左家抢，到我抢地主，抢完收工")
				removeCallDZLayer()
				createChuPaiButton()
			elseif rightUser.isJiaoDiZhu then
				print("右家叫，左家抢，我抢地主")
				JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			else
				print("左家叫，我叫/不叫，右叫,到左")
				JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			end
		elseif leftUser.isJiaoDiZhu and rightUser.isBuJiaoDiZhu then
			if centerUser.isBeginUser then
				print("我叫，右家不叫，左家抢，轮到我抢, 完事")
				removeCallDZLayer()
				createChuPaiButton()
			else
				print("右家不叫，左家叫，我抢，轮到左家")
				JiaoDiZhu.qiangDiZhu(LEFT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			end
		elseif leftUser.isBuJiaoDiZhu and rightUser.isJiaoDiZhu then
			if centerUser.isBeginUser then
				print("我叫，右抢，左不抢，轮到我抢，完事")
				removeCallDZLayer()
				createChuPaiButton()
			elseif rightUser.isBeginUser then
				print("右叫，左不抢，我抢，轮到右抢")
				JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
			else
				print("左不叫，我叫，右叫, 轮到我为地主")
				removeCallDZLayer()
				createChuPaiButton()
			end
		elseif leftUser.isJiaoDiZhu then
			print("左家叫，我抢，轮到右家")
			JiaoDiZhu.qiangDiZhu(RIGHT_USER, leftUser, rightUser, centerUser, createJiaoDiZhuButton, 
	removeCallDZLayer, createChuPaiButton)
		else
			print("====GGGGG229")
		end
	end
end
return JiaoDiZhu