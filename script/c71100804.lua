--尖刺三角形·代欧奇希斯
local s, id = GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,71100802)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,s.matfilter)
	-- kennsaku
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- tyokusetu
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	
	-- leave
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_TOHAND + CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.lvcon)
	e3:SetTarget(s.lvtg)
	e3:SetOperation(s.lvop)
	c:RegisterEffect(e3)
end


function s.matfilter(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,71100802)
end

function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end


function s.thfilter(c)
	return c:IsCode(71100810,71100800) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end

function s.lvcon(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) 
		and (r & REASON_EFFECT) ~= 0 and c:GetReasonPlayer() == 1 - tp
end


function s.lvtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter2, tp, LOCATION_REMOVED, 0, 1, nil)
			and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_REMOVED)
	Duel.SetOperationInfo(0, CATEGORY_RELEASE, nil, 1, 0, LOCATION_ONFIELD)
end


function s.thfilter2(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToHand()
end

function s.lvop(e, tp, eg, ep, ev, re, r, rp)

	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g1 = Duel.SelectMatchingCard(tp, s.thfilter2, tp, LOCATION_REMOVED, 0, 1, 1, nil)
	if #g1 > 0 then
		Duel.SendtoHand(g1, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g1)
	end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g2 = Duel.SelectMatchingCard(tp, Card.IsReleasableByEffect, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	if #g2 > 0 then
		Duel.Release(g2, REASON_EFFECT)
	end
end