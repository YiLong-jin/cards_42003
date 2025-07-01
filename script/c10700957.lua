--魔弹取引之谷
function c10700957.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)   
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c10700957.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5) 
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700957,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(c10700957.cost)
	e3:SetTarget(c10700957.target)
	e3:SetOperation(c10700957.operation)
	c:RegisterEffect(e3)
end
function c10700957.atktg(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c10700957.cfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x108) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(c10700957.thfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c10700957.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10700957.thfilter(c,type1)
	return c:IsSetCard(0x108) and c:IsAbleToHand() and not c:IsType(type1)
end
function c10700957.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10700957.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	end
	local g=Duel.SelectMatchingCard(tp,c10700957.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		e:SetLabel(1)
	elseif tc:IsType(TYPE_SPELL) then
		e:SetLabel(2)
	elseif tc:IsType(TYPE_TRAP) then
		e:SetLabel(3)
	end
	if tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c10700957.thfilter1(c)
	return c:IsSetCard(0x108) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c10700957.thfilter2(c)
	return c:IsSetCard(0x108) and c:IsAbleToHand() and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_TRAP))
end
function c10700957.thfilter3(c)
	return c:IsSetCard(0x108) and c:IsAbleToHand() and (c:IsType(TYPE_MONSTER) or c:IsType(TYPE_SPELL))
end
function c10700957.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 local g=Duel.SelectMatchingCard(tp,c10700957.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	 if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	 end
	elseif e:GetLabel()==2 then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 local g=Duel.SelectMatchingCard(tp,c10700957.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	 if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	 end
	elseif e:GetLabel()==3 then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	 local g=Duel.SelectMatchingCard(tp,c10700957.thfilter3,tp,LOCATION_DECK,0,1,1,nil)
	 if g:GetCount()>0 then
		 Duel.SendtoHand(g,nil,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	 end
	end
end