--破魂枪兵 阿库萨斯
function c88888008.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c88888008.lcheck)
	c:EnableReviveLimit()
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(c88888008.efilter)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,88888008)
	e1:SetCondition(c88888008.thcon)
	e1:SetTarget(c88888008.thtg)
	e1:SetOperation(c88888008.thop)
	c:RegisterEffect(e1)
	--destroy drawn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888008,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88888008.ddcon)
	e2:SetCost(c88888008.ddcost)
	e2:SetTarget(c88888008.ddtg)
	e2:SetOperation(c88888008.ddop)
	c:RegisterEffect(e2)
end
function c88888008.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x8980)
end
function c88888008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c88888008.thfilter(c)
	return c:IsSetCard(0x8980) and c:IsAbleToHand()
end
function c88888008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88888008.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c88888008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88888008.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c88888008.efilter(e,te)
	return te:IsActiveType(TYPE_XYZ)
end
function c88888008.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and e:GetHandler():IsSetCard(0x8980)
end
function c88888008.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c88888008.ddcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(c88888008.ddfilter,nil,tp)
	local ct=g:GetCount()
	if chk==0 then return ct>0 and c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function c88888008.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c88888008.ddfilter,nil,tp)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c88888008.ddop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c88888008.ddfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end