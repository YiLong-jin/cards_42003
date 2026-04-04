--驰驭天之型
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
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_MOVE)
    e4:SetRange(0x08)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCondition(cm.damcon)
    e4:SetTarget(cm.damtg)
	e4:SetOperation(cm.damop)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,1))
    e5:SetCategory(CATEGORY_EQUIP+CATEGORY_TODECK+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
    e5:SetProperty(EFFECT_FLAG_DELAY)
    e5:SetRange(0x08)
	e5:SetCountLimit(1,m)
    e5:SetCondition(cm.eqcon)
    e5:SetCost(cm.eqcost)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	c:RegisterEffect(e5)
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
    local tc=e:GetHandler():GetEquipTarget()
    return tc and tc:IsCode(9878355) and eg:IsExists(cm.condfilter,1,nil,tc,tp)
end

function cm.tgdfilter(c)
    return c.Kazanari_Tsubasa and c:IsAbleToHand()
end

function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgdfilter,tp,0x10,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
end

function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local tc=Duel.SelectMatchingCard(tp,cm.tgdfilter,tp,0x10,0,1,1,nil):GetFirst()
    if tc then
        Duel.HintSelection(Group.FromCards(tc))
        if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
            if tc:IsLocation(0x02) then
                Duel.ConfirmCards(1-tp,tc)
            end
            Duel.BreakEffect()
            local c=e:GetHandler()
            if c:IsRelateToChain() then
                c:AddCounter(0x1,1)
            end
        end
    end
end

function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and re:IsActiveType(0x1)
end

function cm.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1,2,REASON_COST) end
    c:RemoveCounter(tp,0x1,2,REASON_COST)
end

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,0x0c,1,nil,0x6) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,0x0c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x01)
end

function cm.tgefilter(c,tc,tp)
    return c.Kazanari_Tsubasa and c:IsType(TYPE_EQUIP) and not c:IsCode(m) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(tc)
end

function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,0x0c,1,1,nil,0x6)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.Destroy(g,REASON_EFFECT)~=0 then
            Duel.BreakEffect()
            local c=e:GetHandler()
            local tc=c:GetEquipTarget()
            if tc and Duel.GetLocationCount(tp,0x08)>0 then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
                local ec=Duel.SelectMatchingCard(tp,cm.tgefilter,tp,0x11,0,1,1,nil,tc,tp):GetFirst()
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
                end
            end
        end
    end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end