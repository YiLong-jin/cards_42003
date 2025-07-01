--万圣夜想曲 佐迪亚
function c10700801.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_HAND)
	e0:SetOperation(c10700801.adjustop)
	c:RegisterEffect(e0)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c10700801.target)
	e1:SetOperation(c10700801.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+10700801)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c10700801.target)
	e2:SetOperation(c10700801.operation)
	c:RegisterEffect(e2) 
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700801,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,10700803)
	e3:SetCondition(c10700801.thcon)
	e3:SetCost(c10700801.thcost)
	e3:SetTarget(c10700801.thtg)
	e3:SetOperation(c10700801.thop)
	c:RegisterEffect(e3)
end
function c10700801.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPublic() and c:GetFlagEffect(10700802)==0 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700801,e,0,0,0,0)
		c:RegisterFlagEffect(10700802,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif not c:IsPublic() and c:GetFlagEffect(10700801)>0 then
		c:ResetFlagEffect(10700802)
	end
end
function c10700801.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700801.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700801.handfilter,tp,LOCATION_HAND,0,1,nil)
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10700801.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)) end
end
function c10700801.handfilter(c)
	return not c:IsPublic()
end
function c10700801.operation(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c10700801.handfilter,tp,LOCATION_HAND,0,1,nil) then
		ops[off]=aux.Stringid(10700801,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10700801.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(10700801,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c10700801.handfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10700801,4))
	elseif opval[op]==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700801.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c10700801.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c10700801.cfilter(c)
	return ((c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD))) and c:IsAbleToGraveAsCost()
end
function c10700801.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700801.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700801.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10700801.thfilter(c)
	return c:IsSetCard(0x7c9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700801.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10700801.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700801.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10700801.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10700801.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end