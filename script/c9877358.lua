--灾难等级A-腐蚀贪食虫
function c9877358.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877358)
	e1:SetCost(c9877358.spcost)
	e1:SetTarget(c9877358.sptg)
	e1:SetOperation(c9877358.spop)
	c:RegisterEffect(e1) 
	--to grave and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,1877358)   
	e2:SetCondition(function(e)  
	local re=e:GetHandler():GetReasonEffect()
	return re and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsReason(REASON_EFFECT) end)
	e2:SetTarget(c9877358.tgdtg) 
	e2:SetOperation(c9877358.tgdop) 
	c:RegisterEffect(e2) 
end
function c9877358.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER) end,tp,LOCATION_GRAVE,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST)  
end
function c9877358.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877358.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c9877358.tgdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsAbleToGrave() and c:IsSetCard(0x27e4) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
end 
function c9877358.tgdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsAbleToGrave() and c:IsSetCard(0x27e4) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SendtoGrave(sg,REASON_EFFECT) 
		if x>0 and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,TYPE_MONSTER) and Duel.SelectYesNo(tp,aux.Stringid(9877358,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,TYPE_MONSTER)  
			Duel.Destroy(dg,REASON_EFFECT)
		end  
	end  
end 












