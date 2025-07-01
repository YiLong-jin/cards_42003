--来发大的？
function c69969170.initial_effect(c)
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969170,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,69969170)
	e1:SetCondition(c69969170.condition)
	e1:SetTarget(c69969170.target)
	e1:SetOperation(c69969170.activate)
	c:RegisterEffect(e1)
end
function c69969170.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x69b)
end
function c69969170.cfilter2(c)
	return c:IsFaceup() and c:IsCode(69969153)
end
function c69969170.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c69969170.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.GetTurnPlayer()==tp or Duel.IsExistingMatchingCard(c69969170.cfilter2,tp,LOCATION_ONFIELD,0,1,nil))
end
function c69969170.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c69969170.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end