--由比鹤乃-原点突破
function c9877878.initial_effect(c)
	aux.AddCodeList(c,9877877)

	aux.EnableChangeCode(c,9877877,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877878,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9877878)
	e1:SetCost(c9877878.spcost)
	e1:SetTarget(c9877878.sptg)
	e1:SetOperation(c9877878.spop)
	c:RegisterEffect(e1)
end
function c9877878.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c9877878.thfilter(c)
	return aux.IsCodeListed(c,9877877) and c:IsAbleToHand()
end
function c9877878.ckfil(c) 
	return c:IsFaceup() and aux.IsCodeListed(c,9877877) and c:IsType(TYPE_FUSION)  
end
function c9877878.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9877878.rfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c9877878.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9877878.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c9877878.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877878.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   local g=Duel.SelectMatchingCard(tp,c9877878.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0 and Duel.IsExistingMatchingCard(c9877878.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) 
		 and Duel.SelectYesNo(tp,aux.Stringid(9877878,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g1)
			Duel.Destroy(g1,REASON_EFFECT)
		end
	end
end
