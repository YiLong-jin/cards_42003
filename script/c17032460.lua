--新序系8 以太索贝克
function c17032460.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c17032460.ovfilter,aux.Stringid(17032460,1),2,c17032460.xyzop)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c17032460.thcon)
	e1:SetTarget(c17032460.thtg)
	e1:SetOperation(c17032460.thop)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17032460,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c17032460.cost)
	e3:SetTarget(c17032460.target)
	e3:SetOperation(c17032460.operation)
	c:RegisterEffect(e3)
end
c17032460.New_Order=8
function c17032460.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and (c:IsDiscardable() or c:IsAbleToHand())
end
function c17032460.ovfilter(c)
	return c:IsFaceup() and c.New_Order and c:IsRank(6)
end
function c17032460.xyzop(e,tp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,17032500)
	local loc=LOCATION_HAND
	if fe then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c17032460.cfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c17032460.cfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,17032500)
		fe:UseCountLimit(tp)
		Duel.SendtoHand(tc,nil,REASON_COST)
	else
		Duel.SendtoGrave(tc,REASON_DISCARD+REASON_COST)
	end
end
function c17032460.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c17032460.thfilter(c)
	return c:IsCode(17032510) and c:IsAbleToHand()
end
function c17032460.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17032460.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17032460.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17032460.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17032460.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c17032460.filter(c,tp)
	if (not c:IsType(TYPE_FIELD)) and Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return false end
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(false,false,false)~=nil
end
function c17032460.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c17032460.filter,tp,LOCATION_HAND,0,1,nil,tp) end
end
function c17032460.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(17032460,0))
	local tc=Duel.SelectMatchingCard(tp,c17032460.filter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local loc=nil
	if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE else loc=LOCATION_SZONE end
	if tc then
		Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		e:SetLabelObject(te:GetLabelObject())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		if not tc:IsType(TYPE_FIELD+TYPE_CONTINUOUS) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
end
