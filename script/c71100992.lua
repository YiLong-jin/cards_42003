-- 神奥大尊 帕路奇犽 (71100992)
-- 效果：不能通常召唤，除外手卡/卡组守备力2718的怪兽来特殊召唤
-- ①：特殊召唤时强制发动，检索记述卡名的魔法卡
-- ②：双方主要阶段（2速），移动场上怪兽到其他主要怪兽区域，原本攻击力上升1500
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

    -- ②：双方主要阶段，移动场上怪兽（2速）
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id+1)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e3:SetCondition(this.mvcon)
    e3:SetTarget(this.mvtg)
    e3:SetOperation(this.mvop)
    c:RegisterEffect(e3)

    -- 原本攻击力动态更新（基于flag计数）
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_SET_BASE_ATTACK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(this.atkval)
    c:RegisterEffect(e4)
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

-- ====== ②：移动怪兽到其他主要怪兽区域 ======
function this.mvcon(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function this.mvfilter(c,tp)
    if not c:IsLocation(LOCATION_MZONE) then return false end
    local seq=c:GetSequence()
    if seq>4 then return false end -- 只处理主怪兽区域
    return true
end

function this.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and this.mvfilter(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(this.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,this.mvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end

function this.mvop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local cp=tc:GetControler()
    local seq=tc:GetSequence()
    if seq>4 then return end
    -- 找到另一个可用的主怪兽区域
    local avail=-1
    for i=0,4 do
        if i~=seq and Duel.CheckLocation(cp,LOCATION_MZONE,i) then
            avail=i
            break
        end
    end
    if avail==-1 then return end
    -- 移动怪兽
    Duel.MoveSequence(tc,avail)
    -- 记录次数，用于原本攻击力计算
    local c=e:GetHandler()
    c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
end

-- ====== 原本攻击力 ======
function this.atkval(e,c)
    return c:GetFlagEffect(id)*1500
end
