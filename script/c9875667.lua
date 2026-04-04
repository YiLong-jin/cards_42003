--击龙要塞-艾莉希雅
function c9875667.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--to grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE) 
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,9875667)
	e2:SetTarget(c9875667.tgtg) 
	e2:SetOperation(c9875667.tgop) 
	c:RegisterEffect(e2) 
	--to hand  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,1875667)
	e3:SetCondition(c9875667.thcon) 
	e3:SetTarget(c9875667.thtg) 
	e3:SetOperation(c9875667.thop) 
	c:RegisterEffect(e3) 
end
function c9875667.tgfil(c) 
	return c:IsAbleToGrave() and c:IsSetCard(0x2ea7)   
end 
function c9875667.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9875667.tgfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c9875667.tgop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9875667.tgfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoGrave(sg,REASON_EFFECT) 
	end 
end 
function c9875667.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x2ea7)   
end  
function c9875667.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
end 
function c9875667.tspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(9875674) 
end
function c9875667.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9875667.tspfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(9875667,0)) then 
		local sg=Duel.SelectMatchingCard(tp,c9875667.tspfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)			
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9875667.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9875667.splimit(e,c)
	return not c:IsSetCard(0x2ea7) 
end
















