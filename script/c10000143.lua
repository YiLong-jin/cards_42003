--中锤-罗佳
function c10000143.initial_effect(c)
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_DESTROYED) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,10000143) 
	e1:SetCondition(c10000143.atkcon) 
	e1:SetTarget(c10000143.atktg) 
	e1:SetOperation(c10000143.atkop) 
	c:RegisterEffect(e1)  
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,20000143) 
	e1:SetTarget(c10000143.sptg)
	e1:SetOperation(c10000143.spop)
	c:RegisterEffect(e1)
end 
function c10000143.dckfil(c) 
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) 
end 
function c10000143.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10000143.dckfil,1,nil) 
end 
function c10000143.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end 
function c10000143.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsRace(RACE_MACHINE) end,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10000142,0)) then 
		local sc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(0) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		sc:RegisterEffect(e1) 
	else 
		if c:IsRelateToEffect(e) then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_ATTACK) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
			c:RegisterEffect(e1)  
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_DEFENSE) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(500) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2) 
			c:RegisterEffect(e1)  
		end 
	end 
end 
function c10000143.ctfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) 
end  
function c10000143.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c10000143.ctfil,tp,0,LOCATION_MZONE,1,nil,e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xafe3) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c10000143.ctfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10000143.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xafe3) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,nil) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(0xafe3) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end
end

