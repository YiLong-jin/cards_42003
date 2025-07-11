--粉蝶x闪蝶 妖艳之惑
function c10001021.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- 效果1
	--[[ local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10001021,1)) --意义不明的提示
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10001021)
	e2:SetCondition(c10001021.rmcon)
	e2:SetTarget(c10001021.rmtg)
	e2:SetOperation(c10001021.rmop)
	c:RegisterEffect(e2) ]]
	-- 效果1 Refractor
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1, 10001021)
	e1:SetCondition(c10001021.spcon)
	e1:SetTarget(c10001021.sptg)
	e1:SetOperation(c10001021.spop)
	c:RegisterEffect(e1)
	-- 破坏代替 (效果2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1, 10001021) --?
	e3:SetTarget(c10001021.reptg)
	e3:SetValue(c10001021.repval)
	e3:SetOperation(c10001021.repop)
	c:RegisterEffect(e3)
end
function c10001021.rmcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcde0)
end
function c10001021.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_TRAP+TYPE_MONSTER+TYPE_SPELL) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c10001021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(c10001021.rmcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c10001021.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
function c10001021.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcde0) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c10001021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c10001021.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c10001021.repval(e,c)
	return c10001021.repfilter(c,e:GetHandlerPlayer())
end
function c10001021.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end

function c10001021.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
		and (c:IsType(TYPE_XYZ) and c:IsSetCard(0xcde0))
end

function c10001021.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10001021.cfilter,1,nil,tp)
end

function c10001021.spfilter(c, e, tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function c10001021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10001021.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil, e, tp) and Duel.GetMZoneCount(tp) > 0 end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE + LOCATION_REMOVED)
end

function c10001021.ovfilter(c)
	return c:IsFaceup() and c:IsCanOverlay()
end

function c10001021.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end --这张永续中途被离开场上了
	if Duel.GetMZoneCount(tp) <= 0 then return end --突然没格子了
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(c10001021.spfilter), tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil, e, tp) --记得加王家检测
	if #g <= 0 then return end --压根没有可以特招的卡
	local sc = g:GetFirst()
	if Duel.SpecialSummon(sc, 0, tp, tp, false, false, POS_FACEUP) >= 1 then
		--特招成功，可以继续处理了
		local mg = Duel.GetMatchingGroup(aux.NecroValleyFilter(c10001021.ovfilter), tp, LOCATION_MZONE + LOCATION_GRAVE, 0, sc) --可以被拿去叠放的卡，含王家检测	
		if #mg > 0 and Duel.SelectYesNo(tp, aux.Stringid(10001021, 0)) then
			--玩家选择
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_XMATERIAL)
			local sg = mg:Select(tp, 1, 1, nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
			if not tc:IsImmuneToEffect(e) then
				Duel.BreakEffect()
				Duel.Overlay(g:GetFirst(), tc)
			end
		end
	end
end