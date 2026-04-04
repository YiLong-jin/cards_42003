--决意的灰暗星-天堂
function c9875685.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2ea7),4,2)
	c:EnableReviveLimit() 
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9875685,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,9875685) 
	e1:SetTarget(c9875685.sptg) 
	e1:SetOperation(c9875685.spop) 
	c:RegisterEffect(e1) 
	--to grave and dis 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(9875685,2))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1875685) 
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end)
	e2:SetTarget(c9875685.tgdtg) 
	e2:SetOperation(c9875685.tgdop)
	c:RegisterEffect(e2)  
end 
function c9875685.sckfil(c,tp) 
	return c:IsType(TYPE_CONTINUOUS) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp)   
end 
function c9875685.spfil(c,e,tp) 
	return c:IsCode(9875674) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c9875685.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c9875685.sckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c9875685.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c9875685.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9875685.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c9875685.tgfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave() 
end 
function c9875685.tgdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875685.tgfil,tp,LOCATION_SZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9875685.tgfil,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0) 
end 
function c9875685.tgdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsSetCard(0x2ea7) and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875685,0)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end 
end 
   









