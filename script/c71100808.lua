--超速三角形·代欧奇希斯
local s, id = GetID()

function s.initial_effect(c)
	aux.AddCodeList(c,71100802)
	-- link
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c, nil, 2, 2, s.matfilter)
	
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
	
	--hatudou
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND, 0)
	e2:SetTarget(s.actfilter)
	c:RegisterEffect(e2)
end


function s.matfilter(g, lc)
	return g:IsExists(Card.IsLinkCode, 1, nil, 71100802)
end


function s.thcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler()::IsSummonLocation(LOCATION_EXTRA)
end


function s.thfilter(c)
	return c:IsCode(71100814, 71100800) and c:IsAbleToHand()
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


function s.actfilter(e, c)
	return c:IsCode(71100810, 71100814) 
end