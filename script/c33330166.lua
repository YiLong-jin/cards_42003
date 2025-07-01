--双璇乱流
function c33330166.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330166,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33330166+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(c33330166.cost1)
	e1:SetTarget(c33330166.tg1)
	e1:SetOperation(c33330166.op1)
	c:RegisterEffect(e1)
--
end
--
function c33330166.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c33330166.CheckFilter(cg,tp)
	local num=0
	local check=false
	for tc in aux.Next(cg) do
		local ag=Duel.GetMatchingGroup(c33330166.tfilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,tc:GetCode())
		if ag:GetCount()>0 then check=true end
	end
	return check
end
function c33330166.tfilter1(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
		and c:IsCode(code) and c:IsAbleToRemove()
end
function c33330166.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local sg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
		return sg:CheckSubGroup(c33330166.CheckFilter,2,2,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,e:GetHandler())
	local dg=sg:SelectSubGroup(tp,c33330166.CheckFilter,false,2,2,tp)
	local code1=dg:GetFirst():GetCode()
	local code2=dg:GetNext():GetCode()
	e:SetLabel(code1,code2)
	Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c33330166.ofilter1(c,code1,code2)
	return c:IsCode(code1,code2) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function c33330166.op1(e,tp,eg,ep,ev,re,r,rp)
	local code1,code2=e:GetLabel()
	local sg=Duel.GetMatchingGroup(c33330166.ofilter1,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil,code1,code2)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
--