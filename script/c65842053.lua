--流圣之交融公主
function c65842053.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65842053,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65842053)
	e1:SetCondition(c65842053.condition)
	e1:SetTarget(c65842053.target)
	e1:SetOperation(c65842053.operation)
	c:RegisterEffect(e1)	
	if not c65842053.global_check then
		c65842053.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c65842053.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65842053.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65842053)==0
end
function c65842053.regop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN1 or ph==PHASE_MAIN2 then
		Duel.RegisterFlagEffect(rp,65842053,RESET_PHASE+PHASE_MAIN1+PHASE_MAIN2,0,1)
	end
end
function c65842053.thfilter(c)
	return c:IsCode(65842054,65842055) and c:IsAbleToHand() 
end
function c65842053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c65842053.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65842053.operation(e,tp,eg,ep,ev,re,r,rp)
	local cl=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65842053.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		cl=Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if cl>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end