--被检体：刚种蚀菌T
function c71100593.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100593,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,19211363)
	e1:SetCondition(c71100593.srcon)
	e1:SetTarget(c71100593.srtg)
	e1:SetOperation(c71100593.srop)
	c:RegisterEffect(e1)  
	--sp
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(FFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11100593) 
	e2:SetTarget(c71100593.esptg)
	e2:SetOperation(c71100593.espop)
	c:RegisterEffect(e2)
end 
function c71100593.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c71100593.srfilter(c)
	return (c:IsSetCard(0x7d0) or (c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT))) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c71100593.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100593.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71100593.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71100593.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71100593.tarfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x7d0) and c:IsLevelBelow(4) 
end 
function c71100593.espfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7d0) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c71100593.esptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return c71100593.tarfil(chkc) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c71100593.tarfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c71100593.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	local g=Duel.SelectTarget(tp,c71100593.tarfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71100593.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.SelectMatchingCard(tp,c71100593.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local og=Group.FromCards()
		local tc=Duel.GetFirstTarget() 
		if tc:IsRelateToEffect(e) then 
			og:AddCard(tc) 
		end 
		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then 
			og:AddCard(c) 
		end 
		if og:GetCount()>0 then 
			Duel.Overlay(sc,og) 
		end 
		local e1=Effect.CreateEffect(sc)
		e1:SetDescription(aux.Stringid(71100593,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(aux.tgoval) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1,true)
		if not sc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			sc:RegisterEffect(e2,true)
		end
	end 
end 








