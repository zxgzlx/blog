--扑克管理类
-- PokerManager = class("PokerManager")
PokerManager = {}
local PokerAB = nil
local Pokers = {}
 
CardType = {}
 
--空牌 1, // 非法牌型
CardType.CT_ERROR = 1
--单张 1张牌
CardType.CT_SINGLE = 2
--对子 2张牌
CardType.CT_DOUBLE =3
--顺子
CardType.CT_SINGLE_LINE = 4
--连对
CardType.CT_DOUBLE_LINE = 5
--三条 3张牌
CardType.CT_THREE =6
--3带1 4张牌
CardType.CT_THREE_TAKE_ONE  = 7
--3带2 5张牌
CardType.CT_THREE_TAKE_TWO  = 8
--4带2单 6张牌
CardType.CT_FOUR_TAKE_ONE = 9
--4带2对 8张牌
CardType.CT_FOUR_TAKE_TWO  = 10
--飞机 3顺
CardType.CT_THREE_LINE = 11
--飞机带小翼 3顺+ 同数量单牌
CardType.CT_THREE_LINE_S = 12
--飞机带大翼 3顺+ 同数量双牌
CardType.CT_THREE_LINE_B = 13
--4张同号的炸弹 4张牌
CardType.CT_BOMB_CARD = 14
--双王火箭
CardType.CT_MISSILE_CARD = 15
 
function PokerManager:ctor()
    PokerAB = nil
 
    self.PokerABName = "poker"
    ABManager.getBundle(
        self.PokerABName,
        function(ab)
            PokerAB = ab
            print(PokerAB.name)
        end
    )
    self.Joker = {"black_joker", "red_joker"}
    self.PokersName = {"01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"}
    --黑桃、红心、梅花、方块
    self.PokersType = {"spade_", "heart_", "club_", "diamond_"}
end
 
--设置贴图
function PokerManager:setPoker(target, serverIndex, fuc)
    local index = tonumber(serverIndex)
    if PokerAB then
        if index == 78 then --如果id编号在扑克资源表中
            target.sprite = PokerAB:LoadAsset(self.Joker[1], typeof(U3D.Sprite))
        elseif index == 79 then
            target.sprite = PokerAB:LoadAsset(self.Joker[2], typeof(U3D.Sprite))
        else
            target.sprite = PokerAB:LoadAsset(self.PokersType[self:GetColor(index)] .. self.PokersName[self:GetNumber(index)], typeof(U3D.Sprite))
        end
        fuc()
    end
end
--设置扑克牌背景
function PokerManager:setPokerBG(target, name, fuc)
    if PokerAB then
        if target then
            target.sprite = PokerAB:LoadAsset(name, typeof(U3D.Sprite))
        end
        fuc()
    end
end
--获取花色名称 lua的table从1开始，因此除值后需要加1
function PokerManager:GetColor(serverIndex)
    if serverIndex ~= 79 and serverIndex ~= 78 then
        return math.modf(serverIndex / 16) + 1
    else
        return serverIndex
    end
end
--获取数字
function PokerManager:GetNumber(serverIndex)
    if serverIndex ~= 79 and serverIndex ~= 78 then
        return serverIndex % 16
    else
        return serverIndex
    end
end
--获取卡牌优先级 15 ~ 1（王、2、1、K、Q、J、10 ~ 3）
function PokerManager:GetGrad(serverIndex)
    -- body
    local num = serverIndex % 16
    if num == 1 then
        return 12
    elseif num == 2 then
        return 13
    elseif num > 2 and num < 14 then
        return num - 2
    else
        return num
    end
end
 
--排序
function PokerManager:SortCards(cardsData)
    -- body
    --卡牌排序(先优先级，后花色)
    local cachePos = #cardsData - 1
    while cachePos > 0 do
        local pos = 0
        for i = 1, cachePos do
            if self:GetGrad(cardsData[i]) < self:GetGrad(cardsData[i + 1]) then --判断优先级
                pos = i
                local tmp = cardsData[i] --缓存小值
                cardsData[i] = cardsData[i + 1]
                cardsData[i + 1] = tmp
            end
            if self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 1]) then --判断花色
                if self:GetColor(cardsData[i]) > self:GetColor(cardsData[i + 1]) then
                    pos = i
                    local tmp = cardsData[i]
                    cardsData[i] = cardsData[i + 1]
                    cardsData[i + 1] = tmp
                end
            end
            cachePos = pos
        end
    end
    return cardsData
end
 
--排序 从小到大
function PokerManager:SortCardsSmallToBig(cardsData)
    -- body
    --卡牌排序(先优先级，后花色)
    local cachePos = #cardsData - 1
    while cachePos > 0 do
        local pos = 0
        for i = 1, cachePos do
            if self:GetGrad(cardsData[i]) > self:GetGrad(cardsData[i + 1]) then --判断优先级
                pos = i
                cardsData[i],cardsData[i+1] = cardsData[i+1],cardsData[i]
            end
            if self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 1]) then --判断花色
                if self:GetColor(cardsData[i]) > self:GetColor(cardsData[i + 1]) then
                    pos = i
                    cardsData[i],cardsData[i+1] = cardsData[i+1],cardsData[i]
                end
            end
            cachePos = pos
        end
    end
    return cardsData
end
 
--获取牌型
function PokerManager:GetCardType(cardsData)
    cardsData = self:SortCards(cardsData)
    -- body
    local cardsCount = #cardsData --卡牌数量
    if cardsCount == 0 then --空牌
        return CardType.CT_ERROR
    elseif cardsCount == 1 then --单张
        return CardType.CT_SINGLE
    elseif cardsCount == 2 then --对子、火箭
        if self:IsMissile(cardsData) then
            return CardType.CT_MISSILE_CARD
        end
        if self:IsDouble(cardsData) then
            return CardType.CT_DOUBLE
        end
        return CardType.CT_ERROR
    elseif cardsCount == 3 then --三条
        if self:IsThree(cardsData) then
            return CardType.CT_THREE
        end
    elseif cardsCount == 4 then --炸弹、三带一
        if self:IsBomb(cardsData) then
            return CardType.CT_BOMB_CARD
        end
        if self:IsThreeTakeOne(cardsData) then
            return CardType.CT_THREE_TAKE_ONE
        end
    elseif cardsCount >= 5 then --三带二，连对，飞机，顺子
        if cardsCount == 5 then --三带二
            if self:IsThreeTakeTwo(cardsData) then
                return CardType.CT_THREE_TAKE_TWO
            end
        elseif cardsCount == 6 then --四带两单
            if self:IsFourTakeTwo(cardsData) then
                return CardType.CT_FOUR_TAKE_ONE
            end
        elseif cardsCount == 8 then --四带两对
            if self:IsFourTakeTwoDouble(cardsData) then
                return CardType.CT_FOUR_TAKE_TWO
            end
        end
 
        if cardsCount >= 8 then --飞机
            if self:IsThreeLine(cardsData) then
                return CardType.CT_THREE_LINE
            elseif self:IsThreeLineAndSWing(cardsData) then
                return CardType.CT_THREE_LINE_S
            elseif self:IsThreeLineAndBWing(cardsData) then
                return CardType.CT_THREE_LINE_B
            end
        end
        if cardsCount > 5 and cardsCount % 2 == 0 then --连对
            if self:IsDoubleLine(cardsData) then
                return CardType.CT_DOUBLE_LINE
            end
        end
        if self:IsSingleLine(cardsData) then --顺子
            return CardType.CT_SINGLE_LINE
        end
    end
    return CardType.CT_ERROR
end
--能出牌与否
function PokerManager:CanShow(selfPokers, showPokers)
    if #selfPokers < #showPokers then
        return nil
    end
    local type = self:GetCardType(showPokers)
    print("type=============>" .. type)
    local show = {}
    if #show > 0 then
        return show
    else
        return nil
    end
end
--对子
function PokerManager:IsDouble(cardsData)
    -- body
    if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) then
        return true
    end
    return false
end
 
--火箭(王炸)
function PokerManager:IsMissile(cardsData)
    -- body
    if (cardsData[1] == 78 or cardsData[1] == 79) and (cardsData[2] == 78 or cardsData[2] == 79) then
        return true
    end
    return false
end
 
--三条
function PokerManager:IsThree(cardsData)
    -- body
    if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[3]) then
        return true
    end
    return false
end
 
--炸弹
function PokerManager:IsBomb(cardsData)
    -- body
    if #cardsData == 4 then
        if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[3]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[4]) then
            return true
        end
    end
    return false
end
 
--三带一
function PokerManager:IsThreeTakeOne(cardsData)
    -- body
    if self:IsBomb(cardsData) then
        return false
    end
    if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[3]) then
        return true
    end
    if self:GetGrad(cardsData[2]) == self:GetGrad(cardsData[3]) and self:GetGrad(cardsData[2]) == self:GetGrad(cardsData[4]) then
        return true
    end
    return false
end
 
--三带二
function PokerManager:IsThreeTakeTwo(cardsData)
    -- body
    if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[3]) then
        if self:GetGrad(cardsData[4]) == self:GetGrad(cardsData[5]) then
            return true
        end
    end
    if self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[4]) and self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[5]) then
        if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) then
            return true
        end
    end
    return false
end
 
--四带二
function PokerManager:IsFourTakeTwo(cardsData)
    -- body
    if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[3]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[4]) then
        return true
    end
    if self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[4]) and self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[5]) and self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[6]) then
        return true
    end
    return false
end
 
--四带两对
function PokerManager:IsFourTakeTwoDouble(cardsData)
    -- body
    if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[3]) and self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[4]) then
        if self:GetGrad(cardsData[5]) == self:GetGrad(cardsData[6]) and self:GetGrad(cardsData[7]) == self:GetGrad(cardsData[8]) then
            return true
        end
    end
    if self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[4]) and self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[5]) and self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[6]) then
        if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[7]) == self:GetGrad(cardsData[8]) then
            return true
        end
    end
    if self:GetGrad(cardsData[5]) == self:GetGrad(cardsData[6]) and self:GetGrad(cardsData[5]) == self:GetGrad(cardsData[7]) and self:GetGrad(cardsData[5]) == self:GetGrad(cardsData[8]) then
        if self:GetGrad(cardsData[1]) == self:GetGrad(cardsData[2]) and self:GetGrad(cardsData[3]) == self:GetGrad(cardsData[4]) then
            return true
        end
    end
    return false
end
 
--顺子
function PokerManager:IsSingleLine(cardsData)
    -- body
    local length = #cardsData
    for i = 1, length do
        if cardsData[i] == 78 or cardsData[i] == 79 or self:GetGrad(cardsData[i]) == 13 then --顺子不包括大小王 and 2
            return false
        end
        if i + 1 < length then
            if self:GetGrad(cardsData[i]) - self:GetGrad(cardsData[i + 1]) ~= 1 then
                return false
            end
        end
    end
    return true
end
 
--连对
function PokerManager:IsDoubleLine(cardsData)
    -- body
    local length = #cardsData
    for i = 1, length do
        if cardsData[i] == 78 or cardsData[i] == 79 or self:GetGrad(cardsData[i]) == 13 then --连对不包括大小王 and 2
            return false
        end
    end
    for i = 1, length, 2 do
        if self:GetGrad(cardsData[i]) ~= self:GetGrad(cardsData[i + 1]) then
            return false
        end
        if i + 2 < length then
            if self:GetGrad(cardsData[i]) - self:GetGrad(cardsData[i + 2]) ~= 1 then
                return false
            end
        end
    end
    return true
end
--飞机 （3顺）
function PokerManager:IsThreeLine(cardsData)
    local length = #cardsData
    --找出连续三张，并且连续三张不能是 2
    local threeCache = {}
    for i = 1, length do
        if i + 2 <= length then
            if self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 1]) and self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 2]) then
                if self:IsContainGrad(threeCache, cardsData[i]) == false then
                    threeCache[#threeCache + 1] = cardsData[i]
                end
            end
        else
            break
        end
    end
    if #threeCache * 3 == length then
        return true
    else
        return false
    end
end
 
--飞机带小翅膀
function PokerManager:IsThreeLineAndSWing(cardsData)
    -- body
    local length = #cardsData
    --找出连续三张，并且连续三张不能是 2
    local threeCache = {}
    for i = 1, length do
        if i + 2 <= length then
            if self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 1]) and self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 2]) then
                if self:IsContainGrad(threeCache, cardsData[i]) == false then
                    threeCache[#threeCache + 1] = cardsData[i]
                end
            end
        else
            break
        end
    end
 
    --查找三张是否连续
    local threeCacheLength = #threeCache
    if threeCacheLength > 1 then
        for i = 1, threeCacheLength do
            if i + 1 < threeCacheLength then
                if self:GetGrad(threeCache[i]) - self:GetGrad(threeCache[i + 1]) ~= 1 then
                    return false
                end
            end
        end
    else
        return false
    end
    --只能是带一个或是带一对
    --计算带牌数量
    if threeCacheLength * (3 + 1) == length then
        return true
    else
        return false
    end
end
 
--飞机带大翅膀
function PokerManager:IsThreeLineAndBWing(cardsData)
    -- body
    local length = #cardsData
    --找出连续三张，并且连续三张不能是 2
    local threeCache = {}
    for i = 1, length do
        if i + 2 <= length then
            if self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 1]) and self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 2]) then
                if self:IsContainGrad(threeCache, cardsData[i]) == false then
                    threeCache[#threeCache + 1] = cardsData[i]
                end
            end
        else
            break
        end
    end
 
    --查找三张是否连续
    local threeCacheLength = #threeCache
    if threeCacheLength > 1 then
        for i = 1, threeCacheLength do
            if i + 1 < threeCacheLength then
                if self:GetGrad(threeCache[i]) - self:GetGrad(threeCache[i + 1]) ~= 1 then
                    return false
                end
            end
        end
    else
        return false
    end
 
    local doubleCache = {}
    if threeCacheLength * (3 + 2) == length then
        --找对子，对子数量 = 三条的数量
        for i = 1, length, 2 do
            if i + 2 < length then
                if self:GetGrad(cardsData[i]) == self:GetGrad(cardsData[i + 1]) then
                    for j = 1, threeCacheLength do
                        if self:IsContainGrad(threeCache, cardsData[i]) == false and self:IsContainGrad(doubleCache, cardsData[i]) == false then
                            doubleCache[#doubleCache + 1] = cardsData[i]
                        end
                    end
                end
            end
        end
        if #doubleCache == threeCacheLength then
            return true
        end
    end
    return false
end
--是否包含同级牌
function PokerManager:IsContainGrad(data, value)
    -- body
    local length = #data
    if length == 0 then
        return false
    end
    for i = 1, length do
        if self:GetGrad(data[i]) == self:GetGrad(value) then
            return true
        end
    end
    return false
end
--比较牌型和大小
function PokerManager:ComparePokers(type, _pokes, _targetpokers)
    _pokes = self:SortCards(_pokes)
    _targetpokers = self:SortCards(_targetpokers)
    --判断对手牌型是否是王炸
    if type == CardType.CT_MISSILE_CARD then
        return false
    end
    --如果自己出的牌是王炸
    if self:IsMissile(_pokes) then
        print("自己出的牌是王炸")
        return true
    end
    --如果对手牌型是炸弹
    if type == CardType.CT_BOMB_CARD then
        if self:IsBomb(_pokes) then
            if self:GetGrad(_pokes[1]) > self:GetGrad(_targetpokers[1]) then
                return true
            else
                print("Bomb is low")
                return false
            end
        else
            --自己出的不是炸弹
            return false
        end
    else
        --对手出的牌型非炸弹
        
        --如果自己出的是炸弹
        if self:IsBomb(_pokes) then
            return true
        end
 
        if #_pokes == #_targetpokers then
            if type == self:GetCardType(_pokes) then
                if self:GetGrad(_pokes[1]) > self:GetGrad(_targetpokers[1]) then
                    return true
                else
                    --首张牌优先级不够对手高
                    print("first is low")
                    return false
                end
            else
                --牌型不一致
                print("type is not the same")
                return false
            end
        else
            --出的牌数量不一致
            print("count is not the same")
            return false
        end
    end
end
--提示出牌
function PokerManager:TipsSendPokers(prepokers, selfpokers)
    --获取牌的牌型
    local t = PokerManager:GetCardType(prepokers)
    if t == CardType.CT_ERROR then
        --如果不成牌型
        return {}
    elseif  t == CardType.CT_BOMB_CARD then
        --如果是炸弹
        local minNum = self:SortCardsSmallToBig(prepokers)[1]
        local resultArr = self:FindAllBombAndMissile(selfpokers,self:GetGrad(minNum))
        if resultArr and #resultArr > 0 then
            return resultArr
        else
            return {}
        end
    else
        --其他所有牌型
        local resultArr = {}
 
        local minNum = self:GetGrad(self:SortCardsSmallToBig(prepokers)[1])
        --获取当前牌型的牌
        if t == CardType.CT_SINGLE then
            resultArr = self:FindAllSingle(selfpokers,minNum)
        elseif t == CardType.CT_DOUBLE then
            resultArr = self:FindAllDouble(selfpokers,minNum)
        elseif t == CardType.CT_THREE then
            resultArr = self:FindAllThree(selfpokers,minNum)
        elseif t == CardType.CT_SINGLE_LINE then
            resultArr = self:FindAllSingleLine(selfpokers,minNum,#prepokers)
        elseif t == CardType.CT_DOUBLE_LINE then
            resultArr = self:FindAllDoubleLine(selfpokers,minNum,#prepokers/2)
        elseif t == CardType.CT_THREE_TAKE_ONE then
            resultArr = self:FindAllThreeTakeOne(selfpokers,minNum)
        elseif t == CardType.CT_THREE_TAKE_TWO then
            resultArr = self:FindAllThreeTakeTwo(selfpokers,minNum)
        elseif t == CardType.CT_FOUR_TAKE_ONE then
            resultArr = self:FindAllFourTakeOne(selfpokers,minNum)
        elseif t == CardType.CT_FOUR_TAKE_TWO then
            resultArr = self:FindAllFourTakeTwo(selfpokers,minNum)
        elseif t == CardType.CT_THREE_LINE then
            resultArr = self:FindAllThreeLine(selfpokers,minNum,#prepokers/3)
        elseif t == CardType.CT_THREE_LINE_S then
            resultArr = self:FindAllThreeLineS(selfpokers,minNum,#prepokers/4)
        elseif t == CardType.CT_THREE_LINE_B then
            resultArr = self:FindAllThreeLineB(selfpokers,minNum,#prepokers/5)
        end
 
        --获取所有的炸弹和王炸
        for k,v in pairs(self:FindAllBombAndMissile(selfpokers)) do
            table.insert(resultArr,v)
        end
        return resultArr
    end
end
 
--根据牌优先级合并成一个哈希表
function PokerManager:TOHashTable(selfPoker)
    local hashTable = {}
    for i=1,16 do
        hashTable[i] = {}
    end
    for k,v in pairs(selfPoker) do
        if v < 78 then
            table.insert(hashTable[self:GetGrad(v)],v)
        elseif v == 78 then
            hashTable[-1] = v
        elseif v == 79 then
            hashTable[-2] = v
        end
    end
    return hashTable
end
 
--找出所有符合条件的炸弹和王炸
function PokerManager:FindAllBombAndMissile(selfPokers,min)
    if min then
        if min == 16 then
            return false
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
    for i=min+1,#hashTable do
        if #hashTable[i] == 4 then
            table.insert(resultArr,hashTable[i])
        end
    end
    if hashTable[-1] and hashTable[-2] then
        table.insert(resultArr,{hashTable[-1],hashTable[-2]})
    end
    return resultArr
end
 
--找出所有符合条件的炸弹
function PokerManager:FindAllBomb(selfPokers,min)
    if min then
        if min == 16 then
            return false
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
    for i=min+1,#hashTable do
        if #hashTable[i] == 4 then
            table.insert(resultArr,hashTable[i])
        end
    end
    return resultArr
end
 
--找出所有符合条件的单牌
function PokerManager:FindSingles(selfPokers,min)
    if min then
        if min == 16 then
            return false
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    for i=min+1,#hashTable do
        if #hashTable[i] == 1 then
            table.insert(resultArr,hashTable[i])
        end
    end
    return resultArr
end
 
--找出所有符合条件的单牌
function PokerManager:FindAllSingle(selfPokers,min)
    if min then
        if min == 16 then
            return false
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    for i=min+1,#hashTable do
        if #hashTable[i] == 1 then
            table.insert(resultArr,hashTable[i])
        end
    end
 
    for i=min+1,#hashTable do
        if #hashTable[i] == 2 then
            table.insert(resultArr,{hashTable[i][1]})
            table.insert(resultArr,{hashTable[i][2]})
        end
    end
 
    for i=min+1,#hashTable do
        if #hashTable[i] == 3 then
            table.insert(resultArr,{hashTable[i][1]})
            table.insert(resultArr,{hashTable[i][2]})
            table.insert(resultArr,{hashTable[i][3]})
        end
    end
 
    return resultArr
end
 
--找出所有符合条件的对子
function PokerManager:FindAllDouble(selfPokers,min)
    if min then
        if min == 16 then
            return false
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
    for i=min+1,#hashTable do
        if #hashTable[i] == 2 then
            table.insert(resultArr,hashTable[i])
        elseif #hashTable[i] == 3 then
            table.insert(resultArr,{hashTable[i][1], hashTable[i][2]})
        end
    end
    return resultArr
end
 
--找出所有符合条件的三条
function PokerManager:FindAllThree(selfPokers,min)
    if min then
        if min == 16 then
            return false
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
    for i=min+1,#hashTable do
        if #hashTable[i] == 3 then
            table.insert(resultArr,hashTable[i])
        end
    end
    return resultArr
end
 
--找出所有符合条件的顺子
function PokerManager:FindAllSingleLine(selfPokers,min,count)
    -- print("min,count:",min,count)
    if min then
        if min == 16 then
            return {}
        end
    else
        min = 0
    end
 
    if count then
        if count == 13 then
            return {}
        end
        if count > #selfPokers then
            return {}
        end
    else
        count = 5
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    for i=min+1,16-count do
        local tempArr = {}
        for j=0,count-1 do
            if #hashTable[i+j] > 0 then
                table.insert(tempArr,hashTable[i+j][1])
            else
                break
            end
        end
        if #tempArr == count then
            table.insert(resultArr,tempArr)
        end
    end
    return resultArr
end
 
--找出所有符合条件的连对
function PokerManager:FindAllDoubleLine(selfPokers,min,count)
    -- print("min,count:",min,count)
    if min then
        if min == 16 then
            return {}
        end
    else
        min = 0
    end
 
    if count then
        if count == 13 then
            return {}
        end
        if count > #selfPokers then
            return {}
        end
    else
        count = 3
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    for i=min+1,16-count do
        local tempArr = {}
        for j=0,count-1 do
            if #hashTable[i+j] > 1 then
                table.insert(tempArr,hashTable[i+j][1])
                table.insert(tempArr,hashTable[i+j][2])
            else
                break
            end
        end
        if #tempArr == count*2 then
            table.insert(resultArr,tempArr)
        end
    end
    return resultArr
end
 
--找出所有符合条件的三带一
function PokerManager:FindAllThreeTakeOne(selfPokers,min)
    if min then
        if min == 16 then
            return {}
        end
        if #selfPokers < 4 then
            return {}
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    local threeArr = self:FindAllThree(selfPokers,min)
    if #threeArr > 0 then
        --找一个要带的单牌
        local singleCard = nil
        local singleArr = self:FindSingles(selfPokers)
        if #singleArr > 0 then
            singleCard = singleArr[1][1]
        else
            --没有单牌，优先从对子里找一个
            for i=1,#hashTable do
                if #hashTable[i]==2 then
                    singleCard = hashTable[i][1]
                    break
                end
            end
            --没有对子，从3条里找一个
            if singleCard == nil then
                for i=1,#hashTable do
                    if #hashTable[i]==3 and i ~= min then
                        singleCard = hashTable[i][1]
                        break
                    end
                end
            end
        end
        if singleCard then
            for i=1,#threeArr do
                table.insert(threeArr[i],singleCard)
                table.insert(resultArr,threeArr[i])
            end
            return resultArr
        else
            return {}
        end
    else
        return {}
    end
end
 
--找出所有符合条件的三带二
function PokerManager:FindAllThreeTakeTwo(selfPokers,min)
    if min then
        if min == 16 then
            return {}
        end
        if #selfPokers < 5 then
            return {}
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    local threeArr = self:FindAllThree(selfPokers,min)
    if #threeArr > 0 then
        --找一对要带的对子
        local doubleCardArr = {}
        local doubleArr = self:FindAllDouble(selfPokers)
        if #doubleArr > 0 then
            doubleCardArr = doubleArr[1]
        else
            for i=1,#hashTable do
                if #hashTable[i]==3 and i ~= min then
                    doubleCardArr = hashTable[i]
                    table.insert(doubleCardArr,hashTable[i][1])
                    table.insert(doubleCardArr,hashTable[i][2])
                    break
                end
            end
        end
        if #doubleCardArr == 2 then
            for i=1,#threeArr do
                table.insert(threeArr[i],doubleCardArr[1])
                table.insert(threeArr[i],doubleCardArr[2])
                table.insert(resultArr,threeArr[i])
            end
            return resultArr
        else
            return {}
        end
    else
        return {}
    end
end
 
--找出所有符合条件的四带两单
function PokerManager:FindAllFourTakeOne(selfPokers,min)
    if min then
        if min == 16 then
            return {}
        end
        if #selfPokers < 6 then
            return {}
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    local fourArr = self:FindAllBomb(selfPokers,min)
    if #fourArr > 0 then
        --找2个要带的单牌
        local singleCardArr = {}
        local singleArr = self:FindSingles(selfPokers)
        if #singleArr > 0 then
            for i=1,#singleArr do
                table.insert(singleCardArr,singleArr[i][1])
                if #singleCardArr == 2 then
                    break
                end
            end
        end
        if #singleCardArr < 2 then
            --没有2张单牌，优先从对子里找
            for i=1,#hashTable do
                if #hashTable[i]==2 then
                    if #singleCardArr == 0 then
                        singleCardArr = hashTable[i]
                    else
                        table.insert(singleCardArr,hashTable[i][1])
                    end
                    break
                end
            end
            --没有对子，从3条里找
            if #singleCardArr == 0 then
                for i=1,#hashTable do
                    if #hashTable[i]==3 and i ~= min then
                        table.insert(singleCardArr,hashTable[i][1])
                        if #singleCardArr == 0 then
                            table.insert(singleCardArr,hashTable[i][2])
                        end
                        break
                    end
                end
            end
        end
        if #singleCardArr == 2 then
            for i=1,#fourArr do
                table.insert(fourArr[i],singleCardArr[1])
                table.insert(fourArr[i],singleCardArr[2])
                table.insert(resultArr,fourArr[i])
            end
            return resultArr
        else
            return {}
        end
    else
        return {}
    end
end
 
--找出所有符合条件的四带两对
function PokerManager:FindAllFourTakeTwo(selfPokers,min)
    if min then
        if min == 16 then
            return {}
        end
        if #selfPokers < 8 then
            return {}
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    local fourArr = self:FindAllBomb(selfPokers,min)
    if #fourArr > 0 then
        --找2个要带的对子
        local doubleCardArr = {}
        local doubleArr = self:FindAllDouble(selfPokers)
        if #doubleArr == 2 then
            table.insert(doubleCardArr,doubleArr[1][1])
            table.insert(doubleCardArr,doubleArr[1][2])
            table.insert(doubleCardArr,doubleArr[2][1])
            table.insert(doubleCardArr,doubleArr[2][2])
        else
            if #doubleArr == 1 then
                table.insert(doubleCardArr,doubleArr[1][1])
                table.insert(doubleCardArr,doubleArr[1][2])
            end
            --不够2个对子，从3条里找2个
            if #doubleCardArr < 4 then
                for i=1,#hashTable do
                    if #hashTable[i]==3 and i ~= min then
                        table.insert(doubleCardArr,hashTable[i][1])
                        table.insert(doubleCardArr,hashTable[i][2])
                        if #doubleCardArr == 4 then
                            break
                        end
                    end
                end
            end
        end
        if #doubleCardArr == 4 then
            for i=1,#fourArr do
                table.insert(fourArr[i],doubleCardArr[1])
                table.insert(fourArr[i],doubleCardArr[2])
                table.insert(fourArr[i],doubleCardArr[3])
                table.insert(fourArr[i],doubleCardArr[4])
                table.insert(resultArr,fourArr[i])
            end
            return resultArr
        else
            return {}
        end
    else
        return {}
    end
end
 
--找出所有符合条件的飞机(三顺)
function PokerManager:FindAllThreeLine(selfPokers,min,count)
    if min then
        if min == 16 then
            return {}
        end
    else
        min = 0
    end
 
    if count then
        if count == 13 then
            return {}
        end
        if count > #selfPokers then
            return {}
        end
    else
        count = 3
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    for i=min+1,16-count do
        local tempArr = {}
        for j=0,count-1 do
            if #hashTable[i+j] > 2 then
                table.insert(tempArr,hashTable[i+j][1])
                table.insert(tempArr,hashTable[i+j][2])
                table.insert(tempArr,hashTable[i+j][3])
            else
                break
            end
        end
        if #tempArr == count*3 then
            table.insert(resultArr,tempArr)
        end
    end
    return resultArr
end
 
--找出所有符合条件的飞机带小翼(三顺+同数量单牌)
function PokerManager:FindAllThreeLineS(selfPokers,min,count)
    if min then
        if min == 16 then
            return {}
        end
        if #selfPokers < 12 then
            return {}
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    local threeArr = self:FindAllThreeLine(selfPokers,min,count)
    if #threeArr > 0 then
        --找count个要带的单牌
        local singleCardArr = {}
        local singleArr = self:FindSingles(selfPokers)
        if #singleArr > 0 then
            for i=1,#singleArr do
                table.insert(singleCardArr,singleArr[i][1])
                if #singleCardArr >= count then
                    break
                end
            end
        end
 
        if #singleCardArr<count then
            --不够单牌，优先从对子里找
            for i=1,#hashTable do
                if #hashTable[i]==2 then
                    table.insert(singleCardArr,hashTable[i][1])
                    if #singleCardArr<count then
                        table.insert(singleCardArr,hashTable[i][2])
                    else
                        break
                    end
                end
            end
        end
        if #singleCardArr<count then
            --不够单牌，从3条里找
            for i=1,#hashTable do
                if #hashTable[i]==3 and i ~= min then
                    -- singleCardArr = hashTable[i][1]
                    -- break
                    for j=1,#hashTable[i] do
                        table.insert(singleCardArr,hashTable[i][j])
                        if #singleCardArr >= count then
                            break
                        end
                    end
                    if #singleCardArr >= count then
                        break
                    end
                end
            end
        end
        if #singleCardArr == count then
            for i=1,#threeArr do
                for j=1,#singleCardArr do
                    table.insert(threeArr[i],singleCardArr[j])
                end
                table.insert(resultArr,threeArr[i])
            end
            return resultArr
        else
            return {}
        end
    else
        return {}
    end
end
 
--找出所有符合条件的飞机带大翼(三顺+同数量对子)
function PokerManager:FindAllThreeLineB(selfPokers,min,count)
    if min then
        if min == 16 then
            return {}
        end
        if #selfPokers < 15 then
            return {}
        end
    else
        min = 0
    end
 
    local hashTable = self:TOHashTable(selfPokers)
    local resultArr = {}
 
    local threeArr = self:FindAllThreeLine(selfPokers,min,count)
    if #threeArr > 0 then
        --找count个要带的对子
        local doubleCardArr = {}
        local doubleArr = self:FindAllDouble(selfPokers)
        if #doubleArr > 0 then
            for i=1,#doubleArr do
                table.insert(doubleCardArr,doubleArr[i][1])
                table.insert(doubleCardArr,doubleArr[i][2])
                if #doubleCardArr >= count*2 then
                    break
                end
            end
        end
 
        if #doubleCardArr<count*2 then
            --不够对子，从3条里找
            for i=1,#hashTable do
                if #hashTable[i]==3 and i ~= min then
                    table.insert(doubleCardArr,hashTable[i][1])
                    table.insert(doubleCardArr,hashTable[i][2])
                    if #doubleCardArr >= count*2 then
                        break
                    end
                end
            end
        end
        if #doubleCardArr == count*2 then
            for i=1,#threeArr do
                for j=1,#doubleCardArr do
                    table.insert(threeArr[i],doubleCardArr[j])
                end
                table.insert(resultArr,threeArr[i])
            end
            return resultArr
        else
            return {}
        end
    else
        return {}
    end
end

function print_dump(data, showMetatable, lastCount)
    if type(data) ~= "table" then
        --Value
        if type(data) == "string" then
            io.write("\"", data, "\"")
        else
            io.write(tostring(data))
        end
    else
        --Format
        local count = lastCount or 0
        count = count + 1
        io.write("{\n")
        --Metatable
        if showMetatable then
            for i = 1,count do io.write("\t") end
            local mt = getmetatable(data)
            io.write("\"__metatable\" = ")
            print_dump(mt, showMetatable, count)    -- 如果不想看到元表的元表，可将showMetatable处填nil
            io.write(",\n")     --如果不想在元表后加逗号，可以删除这里的逗号
        end
        --Key
        for key,value in pairs(data) do
            for i = 1,count do io.write("\t") end
            if type(key) == "string" then
                io.write("\"", key, "\" = ")
            elseif type(key) == "number" then
                io.write("[", key, "] = ")
            else
                io.write(tostring(key))
            end
            print_dump(value, showMetatable, count) -- 如果不想看到子table的元表，可将showMetatable处填nil
            io.write(",\n")     --如果不想在table的每一个item后加逗号，可以删除这里的逗号
        end
        --Format
        for i = 1,lastCount or 0 do io.write("\t") end
        io.write("}")
    end
    --Format
    if not lastCount then
        io.write("\n")
    end
end
 
local myPoker = {22,38,54,23,39,55,24,40,56,9,10,26,11,27,12,28}

local conv = {}
for k, v in pairs(myPoker) do
    conv[k] = PokerManager:GetGrad(v)
end
print("=======================")
print_dump(conv)
 
-- local r = PokerManager:TipsSendPokers({3,19,35,4,20,36,5,21,37,6,22,7,23,8,24},myPoker)
local r = PokerManager:TipsSendPokers({6, 22},myPoker)
print_dump(r)
print("要出的牌", PokerManager:GetGrad(6))
print("count:",#r)
print("\n")
for i=1,#r do
    if #r[i] == 1 then
        -- print("value:",r[i][1])
        print("value:",PokerManager:GetGrad(r[i][1]))
    else
        for k,v in pairs(r[i]) do
            io.write(PokerManager:GetGrad(v)," ")
        end
    end
    print("\n")
end