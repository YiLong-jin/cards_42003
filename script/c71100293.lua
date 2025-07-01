--公司魔女·紧急停堆模式“AZ-5”
function c71100293.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100293,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,71100293)
	e1:SetCondition(c71100293.condition)
	e1:SetTarget(c71100293.target)
	e1:SetOperation(c71100293.operation)
	c:RegisterEffect(e1)
end


function c71100293.filter(c)
	return c:IsSetCard(0x7d0) and c:IsType(TYPE_MONSTER) and (c:IsReason(REASON_EFFECT) or c:IsReason(REASON_COST)) 
end
function c71100293.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (re and re:IsActivated()) then return false end
	return eg:IsExists(c71100293.filter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c71100293.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND)  and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function c71100293.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100293.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71100293.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FIEND)  and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c71100293.cfilter2(c)
	return c:IsCode(71100037)
end
function c71100293.stfilter(c)
	return c71100293.cfilter2(c) and c:IsSSetable()
end
function c71100293.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c71100293.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0
		and e:GetHandler():IsLocation(LOCATION_GRAVE)
		and Duel.GetMatchingGroup(c71100293.cfilter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)>=4
		and Duel.IsExistingMatchingCard(c71100293.stfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(71100293,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		local sg=Duel.SelectMatchingCard(tp,c71100293.stfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SSet(tp,sg)
	end
end