--万圣夜想曲 双生天马
function c10700995.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_HAND)
	e0:SetOperation(c10700995.adjustop)
	c:RegisterEffect(e0)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c10700995.target)
	e1:SetOperation(c10700995.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+10700995)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c10700995.target)
	e2:SetOperation(c10700995.operation)
	c:RegisterEffect(e2)  
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3909436,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10700995)
	e3:SetCondition(c10700995.thcon)
	e3:SetTarget(c10700995.thtg)
	e3:SetOperation(c10700995.thop)
	c:RegisterEffect(e3)   
end
function c10700995.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPublic() and c:GetFlagEffect(10700996)==0 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700995,e,0,0,0,0)
		c:RegisterFlagEffect(10700996,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif not c:IsPublic() and c:GetFlagEffect(10700995)>0 then
		c:ResetFlagEffect(10700996)
	end
end
function c10700995.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10700995.fdfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10700995.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingMatchingCard(c10700995.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil))
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10700995.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)) end
end
function c10700995.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b2=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingMatchingCard(c10700995.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10700995.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(10700995,0)},
			{b2,aux.Stringid(10700995,1)},
			{true,aux.Stringid(197042,2)})
	if op==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tc=Duel.SelectMatchingCard(tp,c10700995.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_UPDATE_ATTACK)
		  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		  e1:SetValue(800)
		  e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		  tc:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_UPDATE_DEFENSE)
		  tc:RegisterEffect(e2)
	   end
	   Duel.SpecialSummonComplete()
	elseif op==2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	   local g=Duel.SelectMatchingCard(tp,c10700995.fdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.HintSelection(g)
		  Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	   end
	end
end
function c10700995.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsPreviousLocation(LOCATION_MZONE+LOCATION_HAND) and c:IsPreviousPosition(POS_FACEUP)) or c:IsPreviousLocation(LOCATION_OVERLAY)
end 
function c10700995.thfilter(c) 
	return c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c10700995.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700995.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700995.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10700995.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end