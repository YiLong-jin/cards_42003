--看起来很会爆裂的黑江
function c9878624.initial_effect(c)
	aux.AddCodeList(c,9877918)

	aux.EnableChangeCode(c,9877918,LOCATION_MZONE+LOCATION_GRAVE)


	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(9878624,0))  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_SUMMON_SUCCESS)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,9878624)  
	e3:SetCost(c9878624.discost)
	e3:SetTarget(c9878624.destg)  
	e3:SetOperation(c9878624.desop)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e4)  
end
function c9878624.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c9878624.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function c9878624.desop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.Destroy(g,REASON_EFFECT)  
	end  
end  