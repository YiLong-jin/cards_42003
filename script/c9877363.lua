--灾难等级C-感染异尸
function c9877363.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,9877363) 
	e1:SetTarget(c9877363.sptg)
	e1:SetOperation(c9877363.spop)
	c:RegisterEffect(e1)   
	--to grave
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,1877363) 
	e2:SetTarget(c9877363.tgtg) 
	e2:SetOperation(c9877363.tgop) 
	c:RegisterEffect(e2)  
end
function c9877363.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877363.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local x=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(9877363,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_MONSTER) 
			Duel.Destroy(dg,REASON_EFFECT)
		end 
	end
end
function c9877363.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGrave() and c:IsSetCard(0x27e4) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c9877363.spfil(c,e,tp) 
	return c:IsSetCard(0x27e4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end 
function c9877363.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToGrave() and c:IsSetCard(0x27e4) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		local x=Duel.SendtoGrave(dg,REASON_EFFECT) 
		if x>0 and Duel.IsExistingMatchingCard(c9877363.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9877363,1)) then 
			Duel.BreakEffect() 
			local sg=Duel.SelectMatchingCard(tp,c9877363.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)   
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
		end 
	end 
end 








