--彩虹 彩
function c65846100.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetCountLimit(1,65846100)
	e0:SetTarget(c65846100.thtg2)
	e0:SetOperation(c65846100.thop2)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c65846100.thcon)
	e3:SetTarget(c65846100.thtg)
	e3:SetOperation(c65846100.thop)
	c:RegisterEffect(e3)
end
c65846100.SetCard_ZJ_CH=true
function c65846100.thfilter2(c)
	return c.SetCard_ZJ_CH and c:IsType(0x1) and c:IsAbleToHand() 
end
function c65846100.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846100.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65846100.thop2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65846100.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65846100.thfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65846100.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) or c:IsRace(RACE_FAIRY)) and c:IsLocation(LOCATION_EXTRA)
end
function c65846100.thfilter(c)
	return c:IsType(0x2) and c:IsAbleToHand() and c.SetCard_ZJ_CH and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c65846100.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO and rc:IsRace(RACE_FAIRY)
end
function c65846100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846100.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.GetFlagEffect(tp,65846100)==0 end
	Duel.RegisterFlagEffect(tp,65846100,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c65846100.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846100.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end