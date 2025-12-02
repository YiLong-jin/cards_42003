--砂狼黑子
function c9877034.initial_effect(c)
	c:SetUniqueOnField(1,0,9877034) 
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877034)
	e1:SetCondition(c9877034.spcon)
	e1:SetTarget(c9877034.sptg)
	e1:SetOperation(c9877034.spop)
	c:RegisterEffect(e1) 
	--equip 
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,1877034)
	e2:SetTarget(c9877034.eqtg)  
	e2:SetOperation(c9877034.eqop) 
	c:RegisterEffect(e2)  
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
	--Destroy
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_DESTROY) 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)   
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,2877034)
	e4:SetCondition(function(e) 
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) end) 
	e4:SetTarget(c9877034.destg) 
	e4:SetOperation(c9877034.desop) 
	c:RegisterEffect(e4)  
end
function c9877034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 
end
function c9877034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877034.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c9877034.eqfil(c) 
	return c.Benqi_duice and c:IsType(TYPE_EQUIP)  
end 
function c9877034.eqgck(g,tp) 
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:GetCount() and g:GetCount()==g:GetClassCount(Card.GetCode) 
end 
function c9877034.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9877034.eqfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c9877034.eqgck,1,4,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c9877034.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877034.eqfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil) 
	if c:IsRelateToEffect(e) and g:CheckSubGroup(c9877034.eqgck,1,4,tp) then 
		local sg=g:SelectSubGroup(tp,c9877034.eqgck,false,1,4,tp) 
		local tc=sg:GetFirst() 
		while tc do 
		if Duel.Equip(tp,tc,c) then   
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(function(e,c)
			return e:GetOwner()==c end)
			tc:RegisterEffect(e1)
		end 
		tc=sg:GetNext() 
		end   
	end  
end 
function c9877034.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(9877036) end,tp,LOCATION_ONFIELD,0,1,nil) end   
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
end 
function c9877034.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
		Duel.BreakEffect() 
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(9877036) end,tp,LOCATION_ONFIELD,0,nil)	
		local sc=g:GetFirst() 
		while sc do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET) 
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		sc:RegisterEffect(e1)
		sc=g:GetNext() 
		end 
	end 
end 




















