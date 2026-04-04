--Zacadia 复活者
function c9875682.initial_effect(c)
	aux.AddCodeList(c,9875667)
	--to grave and to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,9875682)
	e1:SetTarget(c9875682.tghtg) 
	e1:SetOperation(c9875682.tghop) 
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9875682)
	e2:SetTarget(c9875682.sptg) 
	e2:SetOperation(c9875682.spop) 
	c:RegisterEffect(e2) 
end 
function c9875682.thfil(c) 
	return c:IsAbleToHand() and aux.IsCodeListed(c,9875667)   
end 
function c9875682.tghtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(9875667) end,tp,LOCATION_SZONE,0,1,nil) and e:GetHandler():IsAbleToGrave() and Duel.IsExistingMatchingCard(c9875682.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0) 
end 
function c9875682.tghop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9875682.thfil,tp,LOCATION_DECK,0,nil)
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and g:GetCount()>0 then 
		Duel.BreakEffect() 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
	end 
end 
function c9875682.sckfil(c) 
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsSetCard(0x2ea7) and c:IsPreviousLocation(LOCATION_ONFIELD)
end 
function c9875682.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return eg:IsExists(c9875682.sckfil,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end  
function c9875682.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 





