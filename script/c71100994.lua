-- 亚空裂斩 (71100994)
-- 速攻魔法
-- ①：以场上1张卡为对象才能发动。那个破坏。没能因这个效果把卡破坏的场合，可以选场上1张卡送去墓地。
-- ②：场上有攻击力不为0而守备力是2718的怪兽2种类存在的场合，自己主要阶段才能发动。墓地的这张卡加入手卡。
local this,id,ofs=GetID()

function this.initial_effect(c)
    -- ①：破坏 + 可选送墓
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetTarget(this.tg1)
    e1:SetOperation(this.op1)
    c:RegisterEffect(e1)

    -- ②：墓地回收效果
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,id+ofs)
    e2:SetCondition(this.cond2)
    e2:SetTarget(this.tg2)
    e2:SetOperation(this.op2)
    c:RegisterEffect(e2)
end

-- ====== 效果①：破坏 + 可选送墓 ======

function this.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function this.op1(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local destroyed=false
    if tc:IsRelateToEffect(e) then
        destroyed=(Duel.Destroy(tc,REASON_EFFECT)~=0)
    end
    -- 没能破坏的场合，可以选场上1张卡送去墓地
    if not destroyed then
        local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
        if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
            local sg=g:Select(tp,1,1,nil)
            if #sg>0 then
                Duel.SendtoGrave(sg,REASON_EFFECT)
            end
        end
    end
end

-- ====== 效果②：墓地回收 ======

-- 攻击力不为0而守备力2718的怪兽
function this.atkdeffilter(c)
    return c:IsFaceup() and c:GetAttack()~=0 and c:GetDefense()==2718
end

function this.cond2(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    if ph~=PHASE_MAIN1 and ph~=PHASE_MAIN2 then return false end
    -- 场上有攻击力不为0而守备力2718的怪兽2种类存在
    local g=Duel.GetMatchingGroup(this.atkdeffilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if #g<2 then return false end
    -- 需要2种类（不同卡名）
    return g:GetClassCount(Card.GetCode)>=2
end

function this.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end

function this.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
    end
end
