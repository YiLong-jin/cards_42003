--灾难等级A-血疫螂蝎
function c9877356.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877356)
	e1:SetCost(c9877356.spcost)
	e1:SetTarget(c9877356.sptg)
	e1:SetOperation(c9877356.spop)
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED)  
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1877356)
	e2:SetCondition(c9877356.ddcon) 
	e2:SetTarget(c9877356.ddtg)  
	e2:SetOperation(c9877356.ddop) 
	c:RegisterEffect(e2) 
end
function c9877356.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c9877356.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877356.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9877356.ddckfil(c,tp) 
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER) 
end 
function c9877356.ddcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c9877356.ddckfil,1,nil,tp)  
end 
function c9877356.thfil(c) 
	return c:IsSetCard(0x27e4)  and c:IsAbleToHand() 
end 
function c9877356.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9877356.thfil,tp,LOCATION_DECK,0,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end  
function c9877356.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877356.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then  
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
		if x>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877356,0)) then 
			Duel.BreakEffect()
			local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil) 
			Duel.Destroy(dg,REASON_EFFECT)
		end 
	end 
end 





