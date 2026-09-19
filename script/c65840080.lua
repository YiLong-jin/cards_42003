--小阿卡那 宝剑
function c65840080.initial_effect(c)
	aux.AddCodeList(c,65840021)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65840080,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65840080+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DRAW_PHASE,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c65840080.target)
	e1:SetOperation(c65840080.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65840080,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c65840080.actcon)
	c:RegisterEffect(e2)	
end
function c65840080.acfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c65840080.actcon(e)
	return Duel.IsExistingMatchingCard(c65840080.acfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c65840080.thfilter(c)
	return not c:IsCode(65840080) and aux.IsCodeListed(c,65840021) and c:IsAbleToHand()
end
function c65840080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65840080.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65840080.spfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsSynchroSummonable(nil)
end
function c65840080.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65840080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.AdjustAll()
		if Duel.IsExistingMatchingCard(c65840080.spfilter,tp,LOCATION_EXTRA,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(65840080,3)) then
			Duel.BreakEffect()
			local exg=Duel.GetMatchingGroup(c65840080.spfilter,tp,LOCATION_EXTRA,0,nil)
			if exg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=exg:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			end
		end
	end
end