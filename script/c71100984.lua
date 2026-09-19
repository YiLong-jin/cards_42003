-- 时间咆哮 (71100984)
-- 速攻魔法
-- ①：自己场上有「神奥大尊 帝牙卢卡」或者那个卡名记述的卡的场合，以场上·墓地1张卡为对象才能发动。
--     那张卡除外。没能因这个效果把卡除外的场合，可以把这个效果发动时连锁的效果无效。
-- ②：把墓地的这张卡除外才能发动。自己墓地·除外状态的守备力是2718的怪兽任意数量回到卡组。
--     把3张以上回到卡组的场合，自己抽1张。
local this,id,ofs=GetID()

function this.initial_effect(c)
    aux.AddCodeList(c,71100982)  -- 神奥大尊 帝牙卢卡

    -- ①：除外 + 可能无效连锁效果
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetCondition(this.cond1)
    e1:SetTarget(this.tg1)
    e1:SetOperation(this.op1)
    c:RegisterEffect(e1)

    -- ②：墓地回收效果
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+1)
    e2:SetCost(this.cost2)
    e2:SetTarget(this.tg2)
    e2:SetOperation(this.op2)
    c:RegisterEffect(e2)
end

-- ====== 效果①：除外 ======

-- 条件：场上有「神奥大尊 帝牙卢卡」或记载其卡名的表侧卡
function this.cfilter1(c)
    return c:IsFaceup() and (c:IsCode(71100982) or aux.IsCodeListed(c,71100982))
end

function this.cond1(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(this.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end

function this.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsAbleToRemove() end
    if chk==0 then
        return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function this.op1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local removed=false
    if tc:IsRelateToEffect(e) then
        removed=(Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0)
    end
    -- 没能除外的场合，可以无效发动时连锁的效果
    if not removed then
        this.negate_chain(e,tp)
    end
end

-- 无效这张卡发动时连锁的效果（即这张卡作为C2+时，C1的效果）
function this.negate_chain(e,tp)
    local chain_num=Duel.GetCurrentChain()
    if chain_num<=1 then return end
    -- 检查前一个链节点是否可以被无效
    if not Duel.IsChainDisablable(chain_num-1) then return end
    -- 可选：询问玩家是否无效
    if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
    Duel.Hint(HINT_CARD,tp,id)
    Duel.NegateEffect(chain_num-1)
end

-- ====== 效果②：墓地回收 ======

-- cost：把墓地的这张卡除外
function this.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() end
    Duel.Remove(c,POS_FACEUP,REASON_COST)
end

-- 守备力2718的怪兽过滤器
function this.deffilter(c)
    return c:IsDefense(2718) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and c:IsFaceup()
end

function this.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(this.deffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function this.op2(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(this.deffilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
    if #g==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,1,#g,nil)
    if #sg==0 then return end
    Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    if ct>=3 then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
