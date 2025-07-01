--驱动女神 涅普缇努
function c71100278.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100278,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100278)
	e1:SetCondition(c71100278.condition)
	e1:SetTarget(c71100278.target)
	e1:SetOperation(c71100278.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(71100278,ACTIVITY_CHAIN,c71100278.chainfilter)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100278,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,71101278)
	e2:SetTarget(c71100278.tgtg)
	e2:SetOperation(c71100278.tgop)
	c:RegisterEffect(e2)
end
function c71100278.chainfilter(re,tp,cid)
	return not ((re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and re:GetHandler():IsSetCard(0x17df))
end
function c71100278.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(71100278,tp,ACTIVITY_CHAIN)~=0
end
function c71100278.filter(c,e,tp)
	return c:IsSetCard(0x17df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71100278.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71100278.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c71100278.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c71100278.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c71100278.tgfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGrave() and c:IsSetCard(0x17df)
end
function c71100278.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100278.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71100278.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71100278.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end