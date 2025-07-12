--逐火之蛾的终焉死斑
function c9990930.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1,9990930)
	e1:SetTarget(c9990930.tgtg)
	e1:SetCost(c9990930.descost)
	e1:SetOperation(c9990930.tgop)
	c:RegisterEffect(e1)

	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
			e4:SetCountLimit(1,9990930)
	e4:SetTarget(c9990930.thtg)
	e4:SetOperation(c9990930.thop)
	c:RegisterEffect(e4)
end
function c9990930.thfilter(c)
	return c:IsCode(9991130) and c:IsAbleToHand()
end
function c9990930.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990930.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9990930.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9990930.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c9990930.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c9990930.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9990930.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x669)
end
function c9990930.chainfilter(re,tp,cid)
	return re:GetHandler():IsSetCard(0x669)
end
function c9990930.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return #g>0 and Duel.IsExistingMatchingCard(c9990930.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9990930.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local t=Duel.SelectMatchingCard(tp,c9990930.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if t:GetCount()>0 then
		Duel.SpecialSummon(t,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c9990930.filter(c,e,tp)
	return c:IsCode(9990970) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end