--真实的信徒
function c17030870.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17030870,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17030870)
	e2:SetCost(c17030870.thcost)
	e2:SetTarget(c17030870.thtg)
	e2:SetOperation(c17030870.thop)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(aux.chainreg)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c17030870.acop)
	c:RegisterEffect(e4)
end
function c17030870.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x1,1)
	end
end
function c17030870.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=3
	if chk==0 then return c:IsCanRemoveCounter(tp,0x1,3,REASON_COST) end
	if c:IsCanRemoveCounter(tp,0x1,9,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(17030870,1)) then 
		ct=9
		c:RegisterFlagEffect(17030870,RESET_CHAIN,0,1)
	end
	e:GetHandler():RemoveCounter(tp,0x1,ct,REASON_COST)
end
function c17030870.thfilter(c,check)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and (c:IsSetCard(0x57f3) or check)
end
function c17030870.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local check=c:GetFlagEffect(17030870)>0
		return Duel.IsExistingMatchingCard(c17030870.thfilter,tp,LOCATION_DECK,0,1,nil,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17030870.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=c:GetFlagEffect(17030870)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17030870.thfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end