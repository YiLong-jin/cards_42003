--巨石遗物的素材 淡淡的忧伤
function c65846753.initial_effect(c)
	c:EnableReviveLimit()
	local e1=aux.AddRitualProcGreater2(c,c65846753.filter,LOCATION_HAND+LOCATION_DECK,nil,c65846753.matfilter,true)
	e1:SetDescription(aux.Stringid(65846753,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65846753)
	e1:SetCost(c65846753.rscost)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65846753+1)
	e2:SetCondition(c65846753.thcon)
	e2:SetTarget(c65846753.thtg)
	e2:SetOperation(c65846753.thop)
	c:RegisterEffect(e2)
end
function c65846753.filter(c,e,tp,chk)
	return c:IsSetCard(0x138) and (not chk or c~=e:GetHandler())
end
function c65846753.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end
function c65846753.rscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c65846753.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_RITUAL and c:IsPreviousLocation(LOCATION_HAND) and c:IsReason(REASON_RELEASE)
end
function c65846753.filter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0x138) and Duel.IsExistingMatchingCard(c65846753.filter2,tp,LOCATION_DECK,0,1,nil,lv)
end
function c65846753.filter2(c,lv)
	return c:IsLevel(lv) and c:IsAbleToHand() and c:GetType()&0x81==0x81
end
function c65846753.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65846753.filter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846753.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c65846753.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65846753.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65846753.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
	local sc=g:GetFirst()
	if sc then
		Duel.SendtoHand(sc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sc)
	end
end