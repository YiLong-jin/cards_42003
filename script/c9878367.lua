--义云之一闪
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
    --special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetRange(0x08)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_EQUIP+CATEGORY_REMOVE)
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

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetEquipTarget()
	return eg:GetFirst()==ec and ec:IsCode(9878355)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():GetEquipTarget():IsRelateToBattle() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local ec=c:GetEquipTarget()
    if ec and ec:IsRelateToBattle() and not ec:IsImmuneToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        ec:RegisterEffect(e1)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
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
	if chk==0 then return Duel.IsExistingTarget(cm.tgefilter,tp,0x04,0,1,nil,tp)
        and Duel.GetLocationCount(tp,0x08)>0
        and Duel.GetLocationCount(tp,0x04,2,0)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.tgefilter,tp,0x04,0,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x11)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,tp,0x10)
end

function cm.opefilter(c)
    return c:IsType(0x2) and c:IsAbleToRemove()
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
            if Duel.IsExistingMatchingCard(cm.opefilter,tp,0x10,0,1,nil) and Duel.GetLocationCount(1-tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
                local g=Duel.SelectMatchingCard(tp,cm.opefilter,tp,0x10,0,1,3,nil)
                if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
                    local zone=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
                    if tp==1 then
                        zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
                    end
                    local e2=Effect.CreateEffect(c)
                    e2:SetType(EFFECT_TYPE_FIELD)
                    e2:SetCode(EFFECT_DISABLE_FIELD)
                    e2:SetValue(zone)
                    e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
                    Duel.RegisterEffect(e2,tp)
                end
            end
        end
    end
end

function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end