--星辰偶像-情怀
function c9879382.initial_effect(c)
	c:EnableCounterPermit(0x7e2)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9877262,1))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e12:SetType(EFFECT_TYPE_QUICK_O) 
	e12:SetCode(EVENT_FREE_CHAIN) 
	e12:SetHintTiming(0,TIMING_END_PHASE)
	e12:SetRange(LOCATION_MZONE) 
	e12:SetCountLimit(1,9879382) 
	e12:SetCondition(function(e) 
	return e:GetHandler():GetCounter(0x7e2)>=1 end)
	e12:SetTarget(c9879382.sptg) 
	e12:SetOperation(c9879382.spop)  
	c:RegisterEffect(e12) 
end
function c9879382.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanHaveCounter(0x7e2)  
end 
function c9879382.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879382.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c9879382.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879382.spfil,tp,LOCATION_DECK,0,nil,e,tp) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 