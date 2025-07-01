--墟界天使核心
function c30553213.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,30553213)
	e1:SetCost(c30553213.cost)
	e1:SetTarget(c30553213.target)
	e1:SetOperation(c30553213.activate)
	c:RegisterEffect(e1)
	--to deck top
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30553213,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c30553213.tdtg)
	e2:SetOperation(c30553213.tdop)
	c:RegisterEffect(e2)
end
function c30553213.tdfilter(c)
	return c:IsSetCard(0x302)-- and c:IsType(TYPE_MONSTER)
end
function c30553213.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30553213.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE,0)>1 end
end
function c30553213.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(30553213,2))
	local g=Duel.SelectMatchingCard(tp,c30553213.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		else
			Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
		end
	end
end
function c30553213.costfilter(c)
	return c:IsSetCard(0x302) and not c:IsPublic() and c:IsAbleToDeck()
end
function c30553213.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c30553213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c30553213.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2)
	end
	local g=Duel.SelectMatchingCard(tp,c30553213.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g:GetFirst())
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g:GetFirst(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c30553213.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
	local mc=e:GetLabelObject()
		if mc:IsRelateToEffect(e) then
	   Duel.SendtoDeck(mc,tp,0,REASON_EFFECT) 
	end
	end
end
