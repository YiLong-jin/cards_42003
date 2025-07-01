--阴云仙－积状云
function c10701679.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_THUNDER),2,1,nil,nil,99)  
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701679,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10701679)
	e1:SetCondition(c10701679.drcon)
	e1:SetCost(c10701679.drcost)
	e1:SetTarget(c10701679.drtg)
	e1:SetOperation(c10701679.drop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c10701679.drcon2)
	c:RegisterEffect(e2)
	--draw2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701679,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10701680)
	e3:SetTarget(c10701679.drtg2)
	e3:SetOperation(c10701679.drop2)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701679,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c10701679.atcon)
	e4:SetTarget(c10701679.attg)
	e4:SetOperation(c10701679.atop)
	c:RegisterEffect(e4) 
end
function c10701679.drcon(e)
	return e:GetHandler():GetOverlayCount()<3
end
function c10701679.drcon2(e)
	return e:GetHandler():GetOverlayCount()>=3
end
function c10701679.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=c:GetOverlayGroup()
	local ct=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(ct)
end
function c10701679.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,ct)
end
function c10701679.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if Duel.Draw(tp,ct,REASON_EFFECT) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g:GetCount()<ct then return end
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,ct,ct,nil)
		aux.PlaceCardsOnDeckBottom(tp,sg)
	end
end
function c10701679.drtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsAttribute(ATTRIBUTE_LIGHT) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10701679.drop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c10701679.cfilter1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c10701679.atcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701679.cfilter1,1,nil,1-tp)
end
function c10701679.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)
	if chk==0 then return #g>0 end
end
function c10701679.atfilter(c)
	return c:IsCanOverlay()
end
function c10701679.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701679.atfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
	if #mg>0 then
		Duel.Overlay(c,mg)
	end
end