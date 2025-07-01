--指令：突袭
local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.poy)
	c:RegisterEffect(e1)
	
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.condition)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.recon)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
end
function s.poy(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg:GetCount()<=0
end
function s.filter(c)
	return c:IsSetCard(0x8ac) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function s.filter2(c)
	return c:IsSetCard(0x8ac) and c:IsAbleToHand()
end

function s.filter3(c, e, tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7ac) and c:IsCanBeSpecialSummoned(e, nil, tp, false, false) and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local g = Duel.GetMatchingGroup(s.filter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED, 0, nil)
	if chk == 0 then
		return g:CheckSubGroup(aux.dncheck, 7, 7)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
	local sg = g:SelectSubGroup(tp, aux.dncheck, false, 7, 7)
	Duel.ConfirmCards(tp, sg)
	Duel.ConfirmCards(1 - tp, sg)
	if sg:FilterCount(Card.IsLocation, nil, LOCATION_HAND) then
		Duel.ShuffleHand(tp)
	end
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_SEARCH+CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
	if Duel.IsExistingMatchingCard(s.filter3, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) then
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
	end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local sg = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_DECK, 0, 1, 1, nil)
	local tc = sg:GetFirst()
	if tc then
		Duel.SendtoHand(tc, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, tc)
		if Duel.IsExistingMatchingCard(s.filter3, tp, LOCATION_EXTRA, 0, 1, nil, e, tp) and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local sg2 = Duel.SelectMatchingCard(tp,s.filter3, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
			local tc2 = sg2:GetFirst()
			if tc2 then
				Duel.BreakEffect()
				if Duel.SpecialSummonStep(tc2, 0, tp, tp, false, false, POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetRange(LOCATION_MZONE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc2:RegisterEffect(e1)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetRange(LOCATION_MZONE)
					e2:SetCountLimit(1)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetOperation(s.tdop)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc2:RegisterEffect(e2)
					Duel.SpecialSummonComplete()
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_FIELD)
					e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e3:SetCode(EFFECT_SKIP_DP)
					e3:SetTargetRange(1,0)
					if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
						e3:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
					else
						e3:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
					end
					Duel.RegisterEffect(e3,tp)
				end
			end
		end
	end
end

function s.condition(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(), LOCATION_ONFIELD, 0) == 0
end

function s.tdop(e, tp, eg, ep, ev, re, r, rp)
	Duel.SendtoDeck(e:GetHandler(), nil, 2, REASON_EFFECT)
end
	function s.recon(e)
	return e:GetHandler():IsFaceup()
end
