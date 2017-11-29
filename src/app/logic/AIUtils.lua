--
-- Author: Your Name
-- Date: 2017-11-27 18:21:03
--
local AIUtils = {}

function AIUtils.isAccord(list)
	if AIUtils.isKing(list) then
		print("是王炸")
		return true
	elseif AIUtils.isBoom(list) then
		print("是炸弹")
		return true
    elseif AIUtils.isSiDaiEr(list) then
    	print("是四带二")
    	return true
    elseif AIUtils.isThree(list) then
    	print("是三条")
    	return true
    elseif AIUtils.isThreeDai(list) then
    	print("是三带")
    	return true
    elseif AIUtils.isThreeThree(list) then
    	print("是飞机")
	    return true
	elseif AIUtils.isShunZi(list) then
		print("是顺子")
		return true
	elseif AIUtils.isShuangShun(list) then
		print("是双顺")
		return true
	elseif AIUtils.isDuiZi(list) then
		print("是对子")
		return true
	elseif AIUtils.isDan(list) then
		print("是单")
		return true
	else
		print("啥也不是")
		return false
	end 
    return false
end


function AIUtils.isKing(list)
    if getLen(list) == 2 then
    	local index = 16
    	for k,v in pairsByKeys(list) do
    		if k == index then
    			index = index + 1
    		else
    		 	return false
    		 end 
    	end
        return true
    end
    return false
end

function AIUtils.isBoom(list)
	if getLen(list) == 1 then
		for k,v in pairsByKeys(list) do
			if getLen(v) ~= 4 then
				return false
			end
		end
		return true
	end
	return false 
end

--四带二
function AIUtils.isSiDaiEr(list)
	local boom = {}
	for k,v in pairsByKeys(list) do
		if getLen(v) == 4 then
			boom[k] = boom[k] or {}
			boom[k] = list[k]
			list[k] = nil
		end
	end
	if getLen(boom) ~= 0 then
		--四带一对
		if getLen(list) == 1 then
			for k,v in pairs(list) do
				if getLen(v) == 2 then
					return true
				end
			end
		end
		--四带两个
		if getLen(list) == 2 then
			local len = 0
			for k,v in pairsByKeys(list) do
				if len == 0 then
					len = getLen(v)
					if len > 2 then
						for k,v in pairs(boom) do
							list[k] = v
						end
						return false
					end
				else
					if getLen(v) == len then
						return true
					end
				end

			end
		end
	end
	for k,v in pairs(boom) do
		list[k] = v
	end
	return false
end

--三条
function AIUtils.isThree(list)
	if getLen(list) == 1 then
		for k,v in pairs(list) do
			if getLen(v) == 3 then
				return true
			end
		end
	end
	return false
end

--三带1或三带2
function AIUtils.isThreeDai(list)
	if getLen(list) == 2 then
		local three = nil
		for k,v in pairs(list) do
			if getLen(v) == 3 then
				three = list[k]
				list[k] = nil
			end
		end
		if three then
			for k,v in pairs(list) do
				if getLen(v) <= 2 then
					return true
				end
			end
		end
	end
	return false
end

--飞机
function AIUtils.isThreeThree(list)
	local index = 1
	local num = 1
	local plist = {}
	for k,v in pairsByKeys(list) do
		local index1 = 1
		for k1,v1 in pairsByKeys(list) do
			while true do
				if index1 <= index then break end
				if getLen(v) == 3 then
					if getLen(v1) == 3 then
						if k1 - k == num then
							num = num + 1
							plist[k1] = plist[k1] or {}
							plist[k1] = list[k1]
							list[k1] = nil
						end
					end
				end
				break
			end
			index1 = index1 + 1
		end
		if getLen(plist) >= 1 then
			plist[k] = plist[k] or {}
			plist[k] = list[k]
			list[k] = nil
			local vlen = 0
			if getLen(plist) == getLen(list) then
				for k2,v2 in pairs(list) do
					if vlen == 0 then
						vlen = getLen(v2)
					else
						if vlen ~= getLen(v2) or vlen > 2 then
							for k3,v3 in pairs(plist) do
								list[k3] = list[k3] or {}
								list[k3] = v3
							end
							return false						
						end
					end
				end
			else
				for k,v in pairs(list) do
					if getLen(v) == 2 and getLen(plist) == 2 then
						return true
					else
						for k3,v3 in pairs(plist) do
							list[k3] = list[k3] or {}
							list[k3] = v3
						end
						return false
					end
				end
			end
			return true
		end
		index = index + 1
	end
	return false
end

--是否为顺子
function AIUtils.isShunZi(list)
	local index = 1
	if getLen(list) < 5 then
		return false
	end
	for k,v in pairsByKeys(list) do
		local num = 1 
		for k1,v1 in pairsByKeys(list) do
			while true do if num == 1 then break end
				if getLen(v) == 1 and getLen(v1) == 1 then
					if k1 - k == index then
						index = index + 1
					else
						return false
					end
				else
					return false
				end
				break
			end
			num = num + 1
		end
		return true
	end
end

function AIUtils.isShuangShun(list)
	local index = 1
	if getLen(list) < 3 then
		return false
	end
	for k,v in pairsByKeys(list) do
		local num = 1 
		for k1,v1 in pairsByKeys(list) do
			while true do if num == 1 then break end
				if getLen(v) == 2 and getLen(v1) == 2 then
					if k1 - k == index then
						index = index + 1
					else
						return false
					end
				else
					return false
				end
				break
			end
			num = num + 1
		end
		return true
	end
end

function AIUtils.isDuiZi(list)
	if getLen(list) == 1 then
		for k,v in pairs(list) do
			if getLen(v) == 2 then
				return true
			else
				return false
			end
		end
	end
	return false
end

function AIUtils.isDan(list)
	if getLen(list) == 1 then
		for k,v in pairs(list) do
			if getLen(v) == 1 then
				return true
			else
				return false
			end
		end
	end
	return false
end

return AIUtils