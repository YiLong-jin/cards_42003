--海幻を育むデータストリーム
function c88884315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88884315,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,88884315)
	e1:SetTarget(c88884315.target)
	e1:SetOperation(c88884315.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88884315,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,88884315)
	e2:SetCost(c88884315.cost)
	e2:SetTarget(c88884315.target1)
	e2:SetOperation(c88884315.activate1)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88884315,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,88884315)
	e3:SetCondition(c88884315.tdcon)
	e3:SetTarget(c88884315.tdtg)
	e3:SetOperation(c88884315.tdop)
	c:RegisterEffect(e3)
end
function c88884315.tgfilter(c)
	return c:IsSetCard(0x8891) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c88884315.tgfilter1(c)
	return c:IsSetCard(0x8891) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevel(1)
end
function c88884315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884315.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c88884315.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(88884315,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c88884315.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c88884315.costfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_LINK) and c:IsAbleToGraveAsCost()
end
function c88884315.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884315.costfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c88884315.costfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c88884315.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884315.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c88884315.tgfilter1,tp,LOCATION_DECK,0,1,nil) and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88884315.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(88884315,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c88884315.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		if g:GetCount()==0 then
	  		g=Duel.SelectMatchingCard(tp,c88884315.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tp,true)
		end
		local tc=g:GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_GRAVE) and Duel.SelectYesNo(tp,aux.Stringid(88884315,4)) 
				and Duel.IsExistingMatchingCard(c88884315.tgfilter1,tp,LOCATION_DECK,0,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local tg=Duel.SelectMatchingCard(tp,c88884315.tgfilter1,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoHand(tg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tg)
			end
		end
	end
end
function c88884315.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsControler(tp) and c:IsType(TYPE_LINK)
end
function c88884315.cfilter1(c,tp)
	return c:IsType(TYPE_MONSTER)
end
function c88884315.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c88884315.cfilter,1,nil,tp)
end
function c88884315.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c88884315.cfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c88884315.cfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c88884315.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end