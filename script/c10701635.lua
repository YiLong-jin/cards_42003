--古代妖之舞
function c10701635.initial_effect(c)
	aux.AddCodeList(c,25862681,4179255)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10701635)
	e2:SetCondition(c10701635.drcon)
	e2:SetTarget(c10701635.drtg)
	e2:SetOperation(c10701635.drop)
	c:RegisterEffect(e2)  
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701635,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,10701636)
	e3:SetTarget(c10701635.settg)
	e3:SetOperation(c10701635.setop)
	c:RegisterEffect(e3)  
end
function c10701635.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=Duel.GetLP(1-tp)+1000
end
function c10701635.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,math.floor(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))/1000)) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,math.floor(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))/1000))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,math.floor(math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))/1000-1))
end
function c10701635.drop(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/1000)
	if Duel.Draw(tp,d,REASON_EFFECT) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g:GetCount()<d-1 then return end
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(p,d-1,d-1,nil)
		aux.PlaceCardsOnDeckTop(tp,sg)
	end
end
function c10701635.stfilter(c)
	return aux.IsCodeListed(c,25862681) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and (c:IsLocation(LOCATION_GRAVE+LOCATION_DECK) or c:IsFaceup())
end
function c10701635.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10701635.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function c10701635.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701635.stfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end