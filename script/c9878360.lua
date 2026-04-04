--骑刃之一闪-终雷
local cm,m=GetID()

--风鸣翼字段伪造
--get c.Kazanari_Tsubasa
cm.Kazanari_Tsubasa=true

function cm.initial_effect(c)
	c:EnableCounterPermit(0x1)
    --Activate
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_EQUIP)
	e9:SetType(EFFECT_TYPE_ACTIVATE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e9:SetTarget(cm.eqtarget)
	e9:SetOperation(cm.eqoperation)
	c:RegisterEffect(e9)
    --Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
	c:RegisterEffect(e1)
    --Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(500)
	c:RegisterEffect(e2)
    --
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,0))
    e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_MOVE)
    e4:SetRange(0x08)
    e4:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(cm.damcon)
	e4:SetTarget(cm.damtg)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_TO_GRAVE)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,m)
    e5:SetCondition(cm.eqcon)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(cm.regop)
    e3:SetLabelObject(e5)
	c:RegisterEffect(e3)
end

function cm.eqtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function cm.eqoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function cm.condfilter(c,tc,tp)
    return c==tc and c:IsPreviousLocation(0x04) and c:IsLocation(0x04) and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=tp)
end

function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.condfilter,1,nil,e:GetHandler():GetEquipTarget(),tp)
end

function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1,1) end
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end

function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Damage(1-tp,300,REASON_EFFECT) then
        local c=e:GetHandler()
        if c:IsRelateToChain() then
            c:AddCounter(0x1,1)
        end
    end
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetCounter(0x1))
end

function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(0x0c)
end

function cm.tgefilter(c,tp)
    return c:IsFaceup() and c:IsCode(9878355) and Duel.IsExistingMatchingCard(cm.tgefilter2,tp,0x11,0,1,nil,c,tp)
end

function cm.tgefilter2(c,tc,tp)
    return c.Kazanari_Tsubasa and c:IsType(TYPE_EQUIP) and not c:IsCode(m) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(tc)
end

function cm.tgefilter3(c)
    return c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tgefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgefilter,tp,0x04,0,1,nil,tp)
        and Duel.GetLocationCount(tp,0x08)>0
        and e:GetLabel()>0 and Duel.IsExistingMatchingCard(cm.tgefilter3,tp,0x10,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.tgefilter,tp,0x04,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x11)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,e:GetLabel(),tp,0x10)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel()*400)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToChain() and Duel.GetLocationCount(tp,0x08)>0 then
        local c=e:GetHandler()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	    local ec=Duel.SelectMatchingCard(tp,cm.tgefilter2,tp,0x11,0,1,1,nil,tc,tp):GetFirst()
        if ec and Duel.Equip(tp,ec,tc) then
            --equip limit
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetLabelObject(tc)
            e1:SetValue(cm.eqlimit)
            ec:RegisterEffect(e1)
            Duel.BreakEffect()
            if Duel.IsExistingMatchingCard(cm.tgefilter3,tp,0x10,0,1,nil) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	            local g=Duel.SelectMatchingCard(tp,cm.tgefilter3,tp,0x10,0,1,e:GetLabel(),nil)
                if #g>0 then
                    Duel.HintSelection(g)
                    local ct=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
                    Duel.Recover(tp,ct*400,REASON_EFFECT)
                end
            end
        end
    end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end