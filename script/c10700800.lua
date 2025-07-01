--奇幻梦境的AliCE
function c10700800.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)   
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700800,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c10700800.cost)
	e1:SetTarget(c10700800.target)
	e1:SetOperation(c10700800.operation)
	c:RegisterEffect(e1) 
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c10700800.cttg1)
	e2:SetOperation(c10700800.ctop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	e3:SetTarget(c10700800.cttg2)
	e3:SetOperation(c10700800.ctop2)
	c:RegisterEffect(e3)
end
--Lead counter
c10700800.counter_add_list={0x107c}
function c10700800.gcfilter(c,ct)
	return c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED) and c:IsCanAddCounter(0x107c,ct)
end
function c10700800.cfilter(c)
	return c:IsAbleToHand()
end
function c10700800.cttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c10700800.cfilter,nil)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c10700800.gcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ct) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x107c)
end
function c10700800.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c10700800.cfilter,nil)
	if ct>0 then
		local g=Duel.SelectMatchingCard(tp,c10700800.gcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ct)
		local tc=g:GetFirst()
		if tc then
			tc:AddCounter(0x107c,ct)
		end
	end
end
function c10700800.cfilter2(c)
	return c:IsAbleToDeck() or c:IsAbleToExtra()
end
function c10700800.cttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c10700800.cfilter2,nil)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c10700800.gcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ct) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ct,0,0x107c)
end
function c10700800.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c10700800.cfilter2,nil)
	if ct>0 then
		local g=Duel.SelectMatchingCard(tp,c10700800.gcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ct)
		local tc=g:GetFirst()
		if tc then
			tc:AddCounter(0x107c,ct)
		end
	end
end
function c10700800.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x107c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x107c,3,REASON_COST)
end
function c10700800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c10700800.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10700800,3))
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		tc:ReverseInDeck()
	end
end