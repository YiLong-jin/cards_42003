--第一话 ~不战斗就无法生存~ 2025/08/12 13:49:50 scripted by 翼龙
local this, id, ofs = GetID()
function this.initial_effect(c)
	-- (1) 从卡组检索2只「渴望」怪兽
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetTarget(this.thtg)
	e1:SetOperation(this.thop)
	c:RegisterEffect(e1)

	-- (2) 对方检索时，自己从墓地除外并检索1张「渴望」卡
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + ofs)  -- 效果②的卡名限制
	e2:SetCondition(this.thcon2)	-- 严格检测「对方从卡组加卡」
	e2:SetCost(this.thcost2)		-- 从墓地除外自身
	e2:SetTarget(this.thtg2)		-- 目标：检索1张「渴望」卡
	e2:SetOperation(this.thop2)	 -- 执行检索
	c:RegisterEffect(e2)
end

-- 效果①：检索2只「渴望」怪兽
function this.thfilter(c)
	return c:IsSetCard(0x67a3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function this.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(this.thfilter, tp, LOCATION_DECK, 0, 2, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 2, tp, LOCATION_DECK)
end

function this.thop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(this.thfilter, tp, LOCATION_DECK, 0, nil)
	if #g >= 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = g:Select(tp, 2, 2, nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sg)
		-- 限制召唤
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1, 0)
		e1:SetTarget(function(e, c)
			return not c:IsSetCard(0x67a3)
		end)
		e1:SetReset(RESET_PHASE + PHASE_END)
		Duel.RegisterEffect(e1, tp)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		Duel.RegisterEffect(e2, tp)
	end
end

-- 效果②：对方检索时，自己从墓地除外并检索1张「渴望」卡
function this.thcon2(e, tp, eg, ep, ev, re, r, rp)
	return rp==1-tp and eg:IsExists(function(c)return c:IsLocation(LOCATION_HAND) and c:IsReason(REASON_EFFECT) and c:GetPreviousLocation()==LOCATION_DECK end,1,nil)
end

function this.thcost2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

function this.thfilter2(c)
	return c:IsSetCard(0x67a3) and c:IsAbleToHand()
end

function this.thtg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(this.thfilter2, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function this.thop2(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, this.thfilter2, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end