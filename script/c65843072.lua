--邪恶★双子 和璃拉
function c65843072.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,3,c65843072.lcheck)
	c:EnableReviveLimit()   
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(84815190,1))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,65843072)
	e0:SetTarget(c65843072.sdrtg)
	e0:SetOperation(c65843072.sdrop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c65843072.condition)
	e1:SetTarget(c65843072.target)
	e1:SetOperation(c65843072.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(c65843072.atkcon)
	e2:SetValue(-1100)
	--c:RegisterEffect(e2)
end
function c65843072.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x153)
end
function c65843072.drfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c65843072.spfilter(c,e,tp)
	return c:IsSetCard(0x152) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65843072.sdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c65843072.drfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	local b=Duel.IsExistingMatchingCard(c65843072.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return a or b end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(84815190,3))
	local op=aux.SelectFromOptions(tp,
			{a,aux.Stringid(65843072,0)},
			{b,aux.Stringid(65843072,1)})
	e:SetLabel(op)
	if op==1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65843072,0))
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
		Duel.SetTargetPlayer(tp)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,nil)
	else
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(65843072,1))
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c65843072.sdrop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local ct=1
		if Duel.IsPlayerCanDraw(tp,2) then ct=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c65843072.drfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,ct,nil)
		local d=Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif op==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65843072.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c65843072.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:IsSetCard(0x1151,0x2151)
end
function c65843072.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (rp==1-tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp)) or c:IsReason(REASON_BATTLE)
end
function c65843072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65843072.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c65843072.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65843072.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65843072.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x152)
end
function c65843072.atkcon(e)
	return not Duel.IsExistingMatchingCard(c65843072.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end