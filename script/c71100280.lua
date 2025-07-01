--史书 伊斯特娲儿
function c71100280.initial_effect(c)
	--tohand
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100280,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,71100280)
	e1:SetCost(c71100280.spcost)
	e1:SetTarget(c71100280.sptg)
	e1:SetOperation(c71100280.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100280,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,71101280)
	e2:SetCondition(c71100280.spcon)
	e2:SetTarget(c71100280.sptg2)
	e2:SetOperation(c71100280.spop2)
	c:RegisterEffect(e2)
end
function c71100280.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x17df) and c:IsAbleToHand()
end
function c71100280.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c71100280.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
 local g=Duel.GetMatchingGroup(c71100280.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c71100280.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c71100280.filter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if hg then
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
function c71100280.spfilter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function c71100280.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp then return false end
	local ct1=Duel.GetMatchingGroupCount(c71100280.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil)
	local chk1=ct1>0
	return chk1
end
function c71100280.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c71100280.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
