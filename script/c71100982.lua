-- 神奥大尊 帝牙卢卡 (71100982)
-- 效果：不能通常召唤，除外手卡/卡组守备力2718的怪兽来特殊召唤
-- ①：特殊召唤时强制发动，检索记述卡名的魔法卡
-- ②：双方主要阶段（2速），除外场上怪兽直到下次战斗阶段开始，返回时攻击力变为对方LP一半
local this,id,ofs=GetID()

function this.initial_effect(c)
    -- 不能通常召唤
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e0)

    -- 特殊召唤手续：除外手卡/卡组守备力2718的怪兽
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(this.spcon)
    e1:SetOperation(this.spop)
    c:RegisterEffect(e1)

    -- ①：特殊召唤成功时强制发动，检索记述卡名的魔法卡
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,id)
    e2:SetTarget(this.thtg)
    e2:SetOperation(this.thop)
    c:RegisterEffect(e2)

    -- ②：双方主要阶段，除外场上怪兽（2速）
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id+1)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetCondition(this.rmcon)
    e3:SetTarget(this.rmtg)
    e3:SetOperation(this.rmop)
    c:RegisterEffect(e3)
end

-- ====== 特殊召唤手续 ======
function this.costfilter(c,tp)
    return c:GetDefense()==2718
        and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK))
        and c:IsAbleToRemoveAsCost()
        and Duel.GetMZoneCount(tp,c)>0
end

function this.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(this.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,tp)
end

function this.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,this.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,e:GetHandler(),tp)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end

-- ====== ①：检索魔法卡 ======
function this.thfilter(c)
    return c:IsType(TYPE_SPELL) and aux.IsCodeListed(c,id) and c:IsAbleToHand()
end

function this.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function this.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,this.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

-- ====== ②：暂时除外 ======
function this.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function this.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function this.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local fid=tc:GetFieldID()
    if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
        -- 标记被除外的怪兽，用于后续追踪
        tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_TEMP_REMOVE,0,1,fid)
        -- 注册下次战斗阶段开始时返回的效果
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(tp)
        e1:SetOperation(this.retop)
        e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
        Duel.RegisterEffect(e1,tp)
    end
end

function this.retop(e,tp,eg,ep,ev,re,r,rp)
    local fid=e:GetLabel()
    local dtp=e:GetLabelObject()
    -- 通过 flag effect label 追踪被除外的怪兽
    local g=Duel.GetMatchingGroup(function(c) return c:GetFlagEffectLabel(id)==fid end,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
    if #g>0 then
        local tc=g:GetFirst()
        if Duel.ReturnToField(tc) and tc:IsFaceup() then
            -- 回到场上时攻击力变为对方基本分一半
            local e1=Effect.CreateEffect(tc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetValue(function(e,c) return math.ceil(Duel.GetLP(1-dtp)/2) end)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e1)
        end
    end
end
