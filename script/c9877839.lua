--叛逆特警-雪狐
function c9877839.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9877839,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877839)
	e1:SetCondition(c9877839.spcon)
	e1:SetTarget(c9877839.sptg)
	e1:SetOperation(c9877839.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877839,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9877839)
	e2:SetCost(c9877839.thcost)
	e2:SetTarget(c9877839.thtg)
	e2:SetOperation(c9877839.thop)
	c:RegisterEffect(e2)
end
function c9877839.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x17ec) 
end
function c9877839.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9877839.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9877839.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877839.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c9877839.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() and Duel.IsExistingMatchingCard(function(c) return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function c9877839.thfilter(c)
	return c:IsSetCard(0x17ec) and c:IsAbleToHand()
end
function c9877839.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877839.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9877839.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9877839.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

