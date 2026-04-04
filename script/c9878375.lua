--义云之落泪
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
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
    --special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetRange(0x08)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_REMOVE)
	e5:SetRange(0x08)
    e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m)
    e5:SetCondition(cm.descon)
    e5:SetCost(cm.descost)
	e5:SetTarget(cm.destg)
	e5:SetOperation(cm.desop)
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

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
	return eg:GetFirst()==ec and ec:IsCode(9878355)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x1,1) end
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetEquipTarget()
    if tc and not tc:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(800)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        if c:IsRelateToChain() then
            c:AddCounter(0x1,1)
        end
    end
end

function cm.condfilter(c,tp)
    return c:IsPreviousLocation(0x10) and c:IsType(0x6) and c:IsPreviousControler(tp)
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.condfilter,1,nil,tp)
end

function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local ct=c:GetCounter(0x1)
    if chk==0 then return c:IsCanRemoveCounter(tp,0x1,ct,REASON_EFFECT) end
    c:RemoveCounter(tp,0x1,ct,REASON_EFFECT)
    e:SetLabel(ct)
end

function cm.tgefilter(c,tc)
    return c:IsFaceup() and c:IsCode(9878355) and c:CheckEquipTarget(tc)
end

function cm.tgefilter2(c,tp)
    return c.Kazanari_Tsubasa and c:IsType(TYPE_EQUIP) and not c:IsCode(m) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and Duel.IsExistingMatchingCard(cm.tgefilter,tp,0x04,0,1,nil,c)
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return duel.GetFieldGroupCount(tp,0,0x0c)>0 and e:GetHandler():IsAbleToGrave() and Duel.IsExistingMatchingCard(cm.tgefilter2,tp,0x11,0,1,nil,tp) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,e:GetLabel(),1-tp,0x0c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x11)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,e:GetLabel(),nil)
    if #g>0 then
        Duel.HintSelection(g)
        if Duel.Destroy(g,REASON_EFFECT)~=0 then
            Duel.BreakEffect()
            local c=e:GetHandler()
            if c:IsRelateToChain() and Duel.SendtoGrave(c,REASON_EFFECT) then
                if Duel.GetLocationCount(tp,0x08)>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
                    local ec=Duel.SelectMatchingCard(tp,cm.tgefilter2,tp,0x11,0,1,1,nil,tp):GetFirst()
                    if ec then
                        local mg=Duel.GetMatchingGroup(cm.tgefilter,tp,0x04,0,nil,ec)
                        if #mg>=2 then
                            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
                            mg=mg:Select(tp,1,1,nil)
                        end
                        local tc=mg:GetFirst()
                        if Duel.Equip(tp,ec,tc) then
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
    end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end