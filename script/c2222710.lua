--暗金教肯瑞托法师
function c2222710.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c2222710.actop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2222710,1))
	--e2:SetCategory(CATEGORY_)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,2222710)
	e2:SetCondition(c2222710.thcon)
	e2:SetTarget(c2222710.thtg)
	e2:SetOperation(c2222710.thop)
	c:RegisterEffect(e2)
end
function c2222710.actop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsSetCard(0x257) then
		Duel.SetChainLimit(c2222710.chainlm)
	end
end
function c2222710.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c2222710.chainlm(e,rp,tp)
	return tp==rp
end
function c2222710.thfilter(c,tp)
	return c:IsSetCard(0x257) and (c:IsSSetable() or c:GetActivateEffect())
end
function c2222710.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222710.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c2222710.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c2222710.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		
	end
end