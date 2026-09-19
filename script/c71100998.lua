-- 71100998 太古传说【其四】
-- Script by: 翼龙

local s, id = GetID()
this.rtsj_Ancient_Legends=true
function s.initial_effect(c)
	-- Activate: choose 1 of 2 effects
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- filter: defense exactly 2718
function s.filter(c)
	return c:IsDefense(2718) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_DECK + LOCATION_REMOVED, 0, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(s.filter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, nil)
		and Duel.IsPlayerCanDraw(tp, 2)
	if chk == 0 then return b1 or b2 end
	-- dynamically set categories for UI hint
	local op = -1
	if b1 and b2 then
		op = Duel.SelectOption(tp, aux.Stringid(id, 0), aux.Stringid(id, 1))
	elseif b1 then
		op = 0
	elseif b2 then
		op = 1
	else
		op = -1
	end
	e:SetLabel(op)
	local cat = 0
	if op==0 then 
		cat = cat + CATEGORY_TOHAND + CATEGORY_SEARCH 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	end
	if op==1 then
		cat = cat + CATEGORY_DRAW 
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,2,0,LOCATION_DECK)
	end
	e:SetCategory(cat)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local op = e:GetLabel()
	if op == 0 then
		-- ●从卡组·除外状态把1只守备力是2718的怪兽加入手卡
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_DECK + LOCATION_REMOVED, 0, 1, 1, nil)
		if #g > 0 then
			Duel.SendtoHand(g, nil, REASON_EFFECT)
			Duel.ConfirmCards(1 - tp, g)
		end
	elseif op == 1 then
		-- ●自己手卡·场上1只守备力是2718的怪兽给对方确认，抽2张卡
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CONFIRM)
		local g = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_HAND + LOCATION_MZONE, 0, 1, 1, nil)
		if #g > 0 then
			Duel.ConfirmCards(1 - tp, g)
			Duel.Draw(tp, 2, REASON_EFFECT)
		end
	end
end
