--情怀的希望
function c99940270.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c99940270.lcheck)
	aux.AddLinkProcedure(c,nil,2,2,c99940270.lcheck)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99940270,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99940270)
	e1:SetCondition(c99940270.thcon)
	e1:SetTarget(c99940270.thtg)
	e1:SetOperation(c99940270.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99940271)
	e2:SetCost(c99940270.cost)
	e2:SetTarget(c99940270.target)
	e2:SetOperation(c99940270.activate)
	e2:SetLabel(0)
	c:RegisterEffect(e2)
-------------------------------------------------------------------------------------------------------
end
function c99940270.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM) or g:IsExists(Card.IsAttack,1,nil,1550)
end
-------------------------------------------------------------------------------------------------------
function c99940270.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99940270.thfilters(c)
	return c:IsCode(99940240) and c:IsAbleToHand()
end
function c99940270.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940270.thfilters,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99940270.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99940270.thfilters,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		end
end
-------------------------------------------------------------------------------------------------------
function c99940270.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c99940270.costfilter1(c,tp)
	return ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c99940270.costfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_EXTRA,0,1,c,c:GetOriginalRace(),c:GetOriginalAttribute(),c:GetCode(),tp)
end
function c99940270.costfilter2(c,race,att,code,tp)
	return ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup())  and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and bit.band(race,c:GetOriginalRace())==0 and bit.band(att,c:GetOriginalAttribute())==0
		and Duel.IsExistingMatchingCard(c99940270.thfilter,tp,LOCATION_DECK,0,1,nil,race,att,code,c:GetCode())
end
function c99940270.thfilter(c,race,att,code1,code2)
	return bit.band(race,c:GetOriginalRace())==0 and bit.band(att,c:GetOriginalAttribute())==0
		and c:IsType(TYPE_MONSTER) and (c:IsLevelAbove(5) or c:IsType(TYPE_PENDULUM)) and c:IsAbleToHand()
end
function c99940270.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c99940270.costfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c99940270.costfilter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tp)
	local race=g1:GetFirst():GetOriginalRace()
	local att=g1:GetFirst():GetOriginalAttribute()
	local code=g1:GetFirst():GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c99940270.costfilter2,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_EXTRA,0,1,1,g1:GetFirst(),race,att,code,tp)
	e:SetLabel(race,att,code,g2:GetFirst():GetCode())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99940270.activate(e,tp,eg,ep,ev,re,r,rp)
	local race,att,code1,code2=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99940270.thfilter,tp,LOCATION_DECK,0,1,1,nil,race,att,code1,code2)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end