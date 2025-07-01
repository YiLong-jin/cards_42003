--新序系10 以太荷鲁斯
function c17032470.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c17032470.ovfilter,aux.Stringid(17032470,1),2,c17032470.xyzop)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17032470,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c17032470.cost)
	e1:SetTarget(c17032470.target)
	e1:SetOperation(c17032470.operation)
	c:RegisterEffect(e1)
end
c17032470.New_Order=10
function c17032470.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and (c:IsDiscardable() or c:IsAbleToHand())
end
function c17032470.ovfilter(c)
	return c:IsFaceup() and c.New_Order and c:IsRank(8)
end
function c17032470.xyzop(e,tp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,17032500)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c17032470.cfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c17032470.cfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,17032500)
		fe:UseCountLimit(tp)
		Duel.SendtoHand(tc,nil,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
	end
end
function c17032470.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17032470.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if e:GetHandler():IsLocation(LOCATION_HAND) then ct=ct-1 end
	if chk==0 then return ct>0 and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c17032470.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(1-tp,aux.TRUE,ct,ct,nil,1-tp)
		Duel.Destroy(sg,REASON_RULE)
	end
end