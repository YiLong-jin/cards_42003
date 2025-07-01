--赛马娘的愉快购物时间
function c20003184.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20003184,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c20003184.thcon)
	e1:SetTarget(c20003184.thtg)
	e1:SetOperation(c20003184.thop)
	c:RegisterEffect(e1)
end
function c20003184.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c20003184.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(c20003184.cfilter,1,nil,1-tp)
end
function c20003184.thfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToHand()
end
function c20003184.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.IsExistingMatchingCard(c20003184.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_GRAVE,0,1,e:GetHandler(),RACE_BEASTWARRIOR)
	local op=2
	if (b1 or (b2 and Duel.IsPlayerCanDraw(tp,2))) and Duel.SelectYesNo(tp,aux.Stringid(20003184,1)) then
		if b1 and (b2 and Duel.IsPlayerCanDraw(tp,2)) then
			op=Duel.SelectOption(tp,aux.Stringid(20003184,2),aux.Stringid(20003184,3))
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(20003184,2))
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		else
			op=Duel.SelectOption(tp,aux.Stringid(20003184,3))+1
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		end
	end
	e:SetLabel(op)
end
function c20003184.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c20003184.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(20003184,5))
		local ag=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,0,1,1,nil,RACE_BEASTWARRIOR)
		if ag:GetCount()>0 then
		   Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		   Duel.ConfirmCards(tp,ag)
		   Duel.ShuffleHand(tp)
		   Duel.ShuffleHand(1-tp)
		   Duel.BreakEffect()
		   Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end