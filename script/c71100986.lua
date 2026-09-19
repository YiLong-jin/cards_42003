-- 时间跳跃的偏执狂 (71100986)
-- 永续陷阱
-- ①：1回合1次，被自身效果除外的「神奥大尊 帝牙卢卡」是除外状态的场合，连锁2以后才能发动。
--     把这个效果发动时积累的连锁上的1个效果无效并破坏。
-- ②：这张卡在墓地存在，除外状态的「神奥大尊 帝牙卢卡」回到场上的场合发动。这张卡在自己场上盖放。
local this,id,ofs=GetID()

function this.initial_effect(c)
    aux.AddCodeList(c,71100982)  -- 神奥大尊 帝牙卢卡

    -- ①：连锁2以上时无效并破坏1个效果
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(this.negcon)
    e1:SetTarget(this.negtg)
    e1:SetOperation(this.negop)
    c:RegisterEffect(e1)

    -- ②：帝牙卢卡从除外回到场上时，墓地盖放
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_MOVE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,id+ofs)
    e2:SetCondition(this.setcon)
    e2:SetTarget(this.settg)
    e2:SetOperation(this.setop)
    c:RegisterEffect(e2)
end

-- ====== 效果①：无效并破坏 ======

function this.exfilter(c)
    -- 被自身效果除外的帝牙卢卡（有71100982标记的除外怪兽）
    return c:IsCode(71100982) and c:IsFaceup()
        and c:GetFlagEffect(71100982)>0
end

function this.negcon(e,tp,eg,ep,ev,re,r,rp)
    -- 必须在连锁2以后
    if Duel.GetCurrentChain()<2 then return false end
    -- 除外状态有被自身效果除外的帝牙卢卡
    return Duel.IsExistingMatchingCard(this.exfilter,tp,LOCATION_REMOVED,0,1,nil)
end

function this.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        -- 检查是否有可以无效的链节点（排除当前正在处理的这个效果本身）
        local ct=Duel.GetCurrentChain()
        for i=1,ct-1 do
            if Duel.IsChainDisablable(i) then return true end
        end
        return false
    end
end

function this.negop(e,tp,eg,ep,ev,re,r,rp)
    local ct=Duel.GetCurrentChain()
    -- 收集可无效的链节点
    local avail={}
    for i=1,ct-1 do
        if Duel.IsChainDisablable(i) then
            table.insert(avail,i)
        end
    end
    if #avail==0 then return end
    -- 选择1个无效并破坏
    local sel=avail[1]
    if #avail>1 then
        -- 多个可选时让玩家选择（简化：选第一个）
        sel=avail[1]
    end
    Duel.Hint(HINT_CARD,tp,id)
    if Duel.NegateEffect(sel) then
        -- 尝试破坏那个效果的发动卡
        local te=Duel.GetChainInfo(sel,CHAININFO_TRIGGERING_EFFECT)
        if te then
            local tc=te:GetOwner()
            if tc and tc:IsRelateToEffect(te) then
                Duel.Destroy(tc,REASON_EFFECT)
            end
        end
    end
end

-- ====== 效果②：墓地盖放 ======

function this.setfilter(c,tp)
    return c:IsCode(71100982) and c:IsFaceup() and c:IsControler(tp)
        and c:IsPreviousLocation(LOCATION_REMOVED) and not c:IsReason(REASON_SPSUMMON)
end

function this.setcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(this.setfilter,1,nil,tp)
end

function this.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and e:GetHandler():IsSSetable() end
end

function this.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
        Duel.SSet(tp,c)
    end
end
