--色孽天甘
function c21400073.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,21400073) 
	e1:SetTarget(c21400073.sptg)
	e1:SetOperation(c21400073.spop)
	c:RegisterEffect(e1)	
	--tograve
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400073)
	e2:SetTarget(c21400073.tgtg)
	e2:SetOperation(c21400073.tgop)
	c:RegisterEffect(e2)
end
function c21400073.spfilter(c,tp)
	return c:IsSetCard(0x5210) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c)>0 
end
function c21400073.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c21400073.spfilter,tp,LOCATION_MZONE,0,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c21400073.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	local rg=Duel.SelectMatchingCard(tp,c21400073.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp) 
	if rg and rg:GetCount()>0 then
		Duel.HintSelection(rg)
		if Duel.SendtoHand(rg,nil,REASON_EFFECT)~=0 and rg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c21400073.tgfilter(c)
	return c:IsSetCard(0x5210) and c:IsAbleToGrave()
end
function c21400073.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400073.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21400073.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400073.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
