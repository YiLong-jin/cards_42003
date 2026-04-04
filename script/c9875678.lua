--协证曲的复归
function c9875678.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e1:SetCountLimit(1,9875678+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9875678.actg)
	e1:SetOperation(c9875678.acop) 
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,1875678)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9875678.sptg)
	e2:SetOperation(c9875678.spop)
	c:RegisterEffect(e2)
end
function c9875678.acfil(c,e,tp)
	return c:IsSetCard(0x2ea7) and c:IsType(TYPE_MONSTER)
end
function c9875678.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9875678.acfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9875678.acfil,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c9875678.aspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(9875680) 
end 
function c9875678.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(function(e,te) 
		return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1) 
		if tc:IsCode(9875674) and Duel.IsExistingMatchingCard(c9875678.aspfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9875678,0)) then 
			local sg=Duel.SelectMatchingCard(tp,c9875678.aspfil,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end 
	end 
end 
function c9875678.spfilter(c,e,tp)
	return c:IsSetCard(0x2ea7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9875678.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9875678.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9875678.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9875678.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end






