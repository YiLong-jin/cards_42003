--Savior Theatre
function c99970180.initial_effect(c)
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e2)
	
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970180,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,99970180)
	e1:SetCost(c99970180.spcost)
	e1:SetTarget(c99970180.sptg)
	e1:SetOperation(c99970180.spop)
	c:RegisterEffect(e1)
	
		--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99970180,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,99970180)
	e3:SetCost(c99970180.cost)
	e3:SetTarget(c99970180.target)
	e3:SetOperation(c99970180.operation)
	c:RegisterEffect(e3)
end
function c99970180.check(c)
	return c:IsAbleToDeckAsCost() and c:IsFaceup() and c:IsAttack(1500) and c:IsDefense(1500) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c99970180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then return Duel.IsExistingMatchingCard(c99970180.check,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99970180.check,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,tp,REASON_COST)
end
function c99970180.thcheck(c)
	return c:IsSetCard(0x1661) and c:IsAbleToHand()
end
function c99970180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970180.thcheck,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE)
end
function c99970180.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970180.thcheck,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 













function c99970180.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c99970180.spfilter1,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c99970180.spfilter1,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c99970180.spfilter1(c,e,tp)
	return c:IsDefense(1800) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_TUNER)
end
function c99970180.spfilter(c,e,tp)
	return c:IsSetCard(0x1661) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970180.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c99970180.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c99970180.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970180.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end




