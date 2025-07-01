--驱动女神 布兰
function c71100277.initial_effect(c)
		--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71100277,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,71100277)
	e1:SetCost(c71100277.spcost)
	e1:SetCondition(c71100277.spcon)
	e1:SetTarget(c71100277.sptg)
	e1:SetOperation(c71100277.spop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100277,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,71101277)
	e2:SetOperation(c71100277.op)
	c:RegisterEffect(e2)
end
function c71100277.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>1 and c:IsControler(tp) and c:IsSetCard(0x17df) 
end
function c71100277.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x17df)
end
function c71100277.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c71100277.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c71100277.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c71100277.spfilter(c,e,tp)
	return c:IsSetCard(0x17df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71100277.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c71100277.spfilter,tp,LOCATION_HAND,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c71100277.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c71100277.spfilter,tp,LOCATION_HAND,0,1,1,c,e,tp)
		if g:GetCount()>0 then
			g:AddCard(c)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c71100277.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c71100277.negcon)
	e1:SetOperation(c71100277.negop)
	Duel.RegisterEffect(e1,tp)
end
function c71100277.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c71100277.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,71100277)
	Duel.NegateEffect(ev)
end