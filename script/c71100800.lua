--不切实际的第一类接触
local s, id = GetID()

function s.initial_effect(c)
	-- kennsaku
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)   
	--imm
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE, 0)
	e2:SetTarget(s.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)	
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetTarget(s.tgtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)   
	-- ririsu
	local e5 = Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id, 1))
	e5:SetCategory(CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1, id + 1)
	e5:SetCondition(s.rlcon)
	e5:SetTarget(s.rltg)
	e5:SetOperation(s.rlop)
	c:RegisterEffect(e5)
	-- 在脚本加载时注册全局监听器
	if not s.registered_global then
		s.registered_global=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RELEASE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function s.thfilter(c)
	return c:IsLevel(8) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_REPTILE) and c:IsAbleToHand()
end


function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local  g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if #g > 0 and Duel.SelectYesNo(tp,aux.Stringid(71100800,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sg)
	end
end

function s.tgtg(e, c)
	return c:IsRace(RACE_REPTILE) and c:GetSequence()>=5
end

function s.rlcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetFlagEffect(0, id) > 0
end

-- 效果③：解放目标
function s.rltg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsReleasableByEffect() end
	if chk == 0 then return Duel.IsExistingTarget(Card.IsReleasableByEffect, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectTarget(tp, Card.IsReleasableByEffect, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_RELEASE, g, 1, 0, 0)
end

function s.rlop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Release(tc, REASON_EFFECT)
	end
end

-- 监听卡被效果解放的事件
function s.regop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetFlagEffect(0, id)==0 and r&REASON_EFFECT~=0 then
		Duel.RegisterFlagEffect(0, id, RESET_PHASE+PHASE_END, 0, 1)
	end
end
