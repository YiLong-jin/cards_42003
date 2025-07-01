local s, id, o = GetID()

function s.initial_effect(c)
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE + CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsSetCard(0x7ac) and c:IsFaceup()
end

function s.filter2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end

function s.condition(e, tp, eg, ep, ev, re, r, rp)
	e:SetProperty(nil)
	e:SetLabel(nil)
	return Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.filter3(c)
	return c:IsSetCard(0x8ac) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end

function s.filter4(g, ...)
	return ({...})[g:GetCount()]
end

function s.cost(e, tp, eg, ep, ev, re, r, rp, chk)
	local able_1 = Duel.IsExistingTarget(aux.NecroValleyFilter(Card.IsAbleToRemove), tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil)
	local able_2 = Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	local able_3 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, nil)
	local min = 0
	if able_3 then min = 3 end
	if able_2 then min = 2 end
	if able_1 then min = 1 end
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.filter3, tp, LOCATION_GRAVE, 0, min, nil)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
	local g = Duel.GetMatchingGroup(s.filter3, tp, LOCATION_GRAVE, 0, nil)
	local sg = g:SelectSubGroup(tp, s.filter4, false, 1, 3, able_1, able_2, able_3)
	Duel.Remove(sg, POS_FACEUP, REASON_COST)
	e:SetLabel(sg:FilterCount(Card.IsLocation, nil, LOCATION_REMOVED))
	if sg:FilterCount(Card.IsLocation, nil, LOCATION_REMOVED) >= 1 and able_1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local remcount = e:GetLabel()
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove()
	end
	local able_1 = Duel.IsExistingTarget(aux.NecroValleyFilter(Card.IsAbleToRemove), tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil)
	local able_2 = Duel.IsExistingMatchingCard(s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil)
	local able_3 = Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, nil)
	if chk == 0 then
		return able_1 or able_2 or able_3
	end
	e:SetLabel(0)
	if able_1 and remcount >= 1 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
		local g = Duel.SelectTarget(tp, aux.NecroValleyFilter(Card.IsAbleToRemove), tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 3, nil)
		Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, g:GetCount(), 0, 0)
		e:SetLabel(1)
	end
	if able_2 and remcount >= 2 then
		local g2 = Duel.GetMatchingGroup(s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
		Duel.SetOperationInfo(0, CATEGORY_POSITION, g2, 1, 0, 0)
		e:SetLabel(e:GetLabel() + 2)
	end
	if able_3 and remcount == 3 then
		Duel.SetOperationInfo(0, CATEGORY_REMOVE, nil, 1, tp, LOCATION_ONFIELD)
		e:SetLabel(e:GetLabel() + 4)
	end
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
	local opslabel = e:GetLabel()
	if opslabel & 1 == 1 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tg=g:Filter(Card.IsRelateToEffect,nil,e)
		if tg:GetCount()>0 then
			Duel.Remove(tg, POS_FACEUP, REASON_EFFECT)
		end
	end
	if opslabel & 2 == 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSITION)
		local g2 = Duel.SelectMatchingCard(tp, s.filter2, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
		local tc2 = g2:GetFirst()
		if tc2 then
			if opslabel & 1 > 0 then
				Duel.BreakEffect()
			end
			Duel.ChangePosition(tc2, POS_FACEDOWN_DEFENSE)
		end
	end
	if opslabel & 4 == 4 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
		local g3 = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
		local tc3 = g3:GetFirst()
		if tc3 then
			if opslabel & 3 > 0 then
				Duel.BreakEffect()
			end
			Duel.Remove(tc3, POS_FACEUP, REASON_EFFECT)
		end
	end
	e:SetProperty(nil)
end
function s.tgfilter(c)
	return c:IsSetCard(0x8ac) and c:IsFaceup() and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.tgfilter(c) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end