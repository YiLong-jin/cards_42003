--夏日玲奈·枫
function c9877903.initial_effect(c)
	aux.AddCodeList(c,9877895,9877896,9877897)

	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,9877903) 
	e1:SetTarget(c9877903.sptg1) 
	e1:SetOperation(c9877903.spop1) 
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877903,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,1877903)
	e3:SetCondition(c9877903.remcon)
	e3:SetTarget(c9877903.destg)
	e3:SetOperation(c9877903.desop)
	c:RegisterEffect(e3)
end
function c9877903.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) )
end 
function c9877903.sptg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9877903.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE) 
end 
function c9877903.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877903.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end


function c9877903.spfilter(c,e,tp)
	return (aux.IsCodeListed(c,9877895) or aux.IsCodeListed(c,9877896) or aux.IsCodeListed(c,9877897) ) and c:IsType(TYPE_MONSTER)  and c:IsAbleToHand()
end
function c9877903.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c9877903.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877903.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877903.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877903.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end