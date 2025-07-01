--永霜零式_兰斯洛特
function c71100172.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x7d9),2,2) 
	--sp des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,71100172) 
	e1:SetCondition(c71100172.spdscon)
	e1:SetTarget(c71100172.spdstg) 
	e1:SetOperation(c71100172.spdsop) 
	c:RegisterEffect(e1) 
end
function c71100172.spdscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end 
function c71100172.spfil(c,e,tp) 
	return c:IsSetCard(0x7d9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c71100172.spdstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100172.spfil,tp,LOCATION_GRAVE,0,2,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end 
function c71100172.spdsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c71100172.spfil,tp,LOCATION_GRAVE,0,2,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then 
		local sg=Duel.SelectMatchingCard(tp,c71100172.spfil,tp,LOCATION_GRAVE,0,2,2,nil,e,tp) 
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then 
			Duel.Destroy(c,REASON_EFFECT) 
		end  
	end 
end 



