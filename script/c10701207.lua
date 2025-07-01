--超级烈焰加农炮
function c10701207.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701207+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10701207.activate)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701207,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10701208)
	e2:SetTarget(c10701207.target)
	e2:SetOperation(c10701207.operation)
	c:RegisterEffect(e2)   
end
function c10701207.filter(c)
	return c:IsSetCard(0x32) and c:IsAbleToGrave()
end
function c10701207.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701207.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701207,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		  Duel.Damage(1-tp,500,REASON_EFFECT)
		end
	end
end
function c10701207.filter1(c)
	return c:IsSetCard(0x32,0xb9) and c:IsAbleToGrave() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c10701207.filter2(c)
	return c:IsSetCard(0x81) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10701207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701207.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701207.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10701207.filter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		if cg:GetCount()>0  and Duel.SelectYesNo(tp,aux.Stringid(10701207,2)) then
		  Duel.BreakEffect()
		  Duel.Destroy(cg,REASON_EFFECT)
		end
	end
end