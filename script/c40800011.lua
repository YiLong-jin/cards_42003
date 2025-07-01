--芝士 青
function c40800011.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,40800000)
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40800011)
	e1:SetCost(c40800011.cost)
	e1:SetTarget(c40800011.thtg)
	e1:SetOperation(c40800011.thop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c40800011.spcon)
	e2:SetTarget(c40800011.sptg2)
	e2:SetOperation(c40800011.spop2)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c40800011.negcon)
	e4:SetCost(c40800011.negcost)
	e4:SetTarget(c40800011.negtg)
	e4:SetOperation(c40800011.negop)
	--c:RegisterEffect(e4)
end
c40800011.SetCard_RR_ZS=true 
function c40800011.spfilter2(c,tp)
	return c.SetCard_RR_ZS
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
end
function c40800011.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c40800011.spfilter2,1,REASON_SPSUMMON,true,e:GetHandler(),tp)
end
function c40800011.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,true,REASON_SPSUMMON):Filter(c40800011.spfilter2,e:GetHandler(),tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c40800011.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
end
function c40800011.negfilter(c,tp)
	return c:IsFaceup() and c.SetCard_RR_ZS and c:IsOnField() and c:IsControler(tp)
end
function c40800011.negcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c40800011.negfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c40800011.costfilter2(c)
	return c:IsCode(40800000) and c:IsAbleToExtraAsCost()
end
function c40800011.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() or Duel.IsExistingMatchingCard(c40800011.costfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c40800011.costfilter2,tp,LOCATION_GRAVE,0,nil)
	if e:GetHandler():IsReleasable() then
		g:AddCard(e:GetHandler())
	end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoDeck(tc,nil,2,REASON_COST)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
	end
end
function c40800011.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c40800011.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
--e1
function c40800011.costfilter(c)
	return c:IsCode(40800000) and (c:IsAbleToGraveAsCost() and c:IsLocation(LOCATION_EXTRA+LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeckOrExtraAsCost())
end
function c40800011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(function(c) return c:IsCode(40800000) and c:IsAbleToGraveAsCost() end,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(function(c) return c:IsAbleToDeckOrExtraAsCost() and c:IsCode(40800000) end,tp,LOCATION_GRAVE,0,1,nil)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c40800011.costfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_EXTRA+LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		Duel.SendtoGrave(g,REASON_COST)
	else
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
function c40800011.thfilter(c)
	return aux.IsCodeListed(c,40800000)  and c:IsType(0x6) and c:IsAbleToHand()
end
function c40800011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40800011.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40800011.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40800011.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end