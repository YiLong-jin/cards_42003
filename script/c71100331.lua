--亚历山大 净源教皇
function c71100331.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100331,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71100331)
	e1:SetCost(c71100331.spcost)
	e1:SetTarget(c71100331.sptg)
	e1:SetOperation(c71100331.spop)
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100331,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71100331)
	e2:SetCondition(c71100331.thcon)
	e2:SetTarget(c71100331.thtg)
	e2:SetOperation(c71100331.thop)
	c:RegisterEffect(e2)   
end
function c71100331.costfilter(c)
	return c:IsSetCard(0x47df) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c71100331.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c71100331.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71100331.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c71100331.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100331.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100331.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and bit.band(rc:GetOriginalType(),TYPE_MONSTER)~=0 and not rc:IsSummonLocation(LOCATION_EXTRA)
end
function c71100331.filter(c,e,tp,spchk)
	return c:IsSetCard(0x47df) and (c:IsAbleToHand() or spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c71100331.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(c71100331.filter,tp,LOCATION_DECK,0,1,nil,e,tp,spchk)
	end
end
function c71100331.thop(e,tp,eg,ep,ev,re,r,rp)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c71100331.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,spchk)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if spchk and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and sc:IsType(TYPE_MONSTER)
			and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
	end
end