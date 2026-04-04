
--气炎之苍剑
local cm,m=GetID()

--风鸣翼字段伪造
--get c.Kazanari_Tsubasa
cm.Kazanari_Tsubasa=true

function cm.initial_effect(c)
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
    --direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(cm.drcon)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_TO_GRAVE)
    e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,m)
    e5:SetCondition(cm.eqcon)
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

function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget():IsCode(9878355)
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

function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tgefilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgefilter,tp,0x04,0,1,nil,tp) and Duel.GetLocationCount(tp,0x08)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.tgefilter,tp,0x04,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x11)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x30)
end

function cm.opefilter(c)
    return c:GetType()==-0x40002 and c:IsAbleToHand() and c:IsFaceup()
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
            if Duel.IsExistingMatchingCard(cm.opefilter,tp,0x30,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
                local rg=Duel.SelectMatchingCard(tp,cm.opefilter,tp,0x30,0,1,1,nil)
                if #rg>0 then
                    Duel.SendtoHand(rg,nil,REASON_EFFECT)
                    Duel.ConfirmCards(1-tp,rg)
                end
            end
        end
    end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end