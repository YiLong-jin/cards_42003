--最强的少女 由比鹤乃
function c9878054.initial_effect(c)
	 aux.AddCodeList(c,9877877)

	 aux.EnableChangeCode(c,9877877,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878054,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9878054)
	e2:SetTarget(c9878054.thtg)
	e2:SetOperation(c9878054.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_QUICK_O) 
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetHintTiming(0,TIMING_END_PHASE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,1878054)
	e13:SetCost(c9878054.cost1)
	e13:SetOperation(c9878054.desop)
	c:RegisterEffect(e13)
end
function c9878054.thfilter(c)
	return aux.IsCodeListed(c,9877877) and c:IsAbleToHand()
end
function c9878054.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878054.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9878054.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878054.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9878054.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9878054.desop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9878054,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
		local e12=Effect.CreateEffect(c) 
		e12:SetType(EFFECT_TYPE_SINGLE) 
		e12:SetCode(EFFECT_UPDATE_ATTACK)  
		e12:SetRange(LOCATION_MZONE) 
		e12:SetValue(1000) 
		e12:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e12) 
end
