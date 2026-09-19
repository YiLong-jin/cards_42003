--流圣之交融公主
function c65848059.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c65848059.splimit)
	--c:RegisterEffect(e0)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65848059,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65848059.condition)
	e1:SetTarget(c65848059.target)
	e1:SetOperation(c65848059.operation)
	c:RegisterEffect(e1)	
	if not c65848059.global_check then
		c65848059.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c65848059.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65848059.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c65848059.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65848059)==0
end
function c65848059.regop(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if ph==PHASE_MAIN1 or ph==PHASE_MAIN2 then
		Duel.RegisterFlagEffect(rp,65848059,RESET_PHASE+PHASE_MAIN1+PHASE_MAIN2,0,1)
	end
end
function c65848059.thfilter(c)
	return (aux.IsCodeOrListed(c,65848060) or aux.IsCodeOrListed(c,65848061)) and c:IsAbleToHand() 
end
function c65848059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c65848059.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c65848059.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65848059.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local cl=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65848059.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		cl=Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	if cl>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c65848059.splimit(e,c)
	return not c:IsType(TYPE_FUSION)
end