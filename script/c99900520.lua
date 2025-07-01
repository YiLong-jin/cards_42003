--傲娇的决斗者
function c99900520.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99900520)
	e1:SetCondition(c99900520.condition)
	e1:SetCost(c99900520.cost)
	e1:SetTarget(c99900520.target)
	e1:SetOperation(c99900520.operation)
	c:RegisterEffect(e1)
end
function c99900520.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=Duel.GetLP(1-tp)-1000
end
function c99900520.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c99900520.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0)>0 and Duel.IsPlayerCanDraw(tp,1)  end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99900520.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.BreakEffect()
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/1000)
	Duel.Draw(tp,d,REASON_EFFECT)
end
