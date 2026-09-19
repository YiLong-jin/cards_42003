--冷匣 地平线
local s,id,o=GetID()
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
-------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
-------------------------------------------------------------------------------------------------
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.spcons)   
	e2:SetTarget(s.sptgs)
	e2:SetOperation(s.spops)
	c:RegisterEffect(e2)
-------------------------------------------------------------------------------------------------
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(s.indcon)
	e3:SetOperation(s.indop)
	c:RegisterEffect(e3)
-------------------------------------------------------------------------------------------------
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ep==tp and bit.band(ec:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and ec:IsSetCard(0x671)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
-------------------------------------------------------------------------------------------------
function s.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and not c:IsCode(9990520)
end
function s.spcons(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)  
end
function s.sptgs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spops(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or   not c:IsRelateToEffect(e)  then return end
   Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end
-------------------------------------------------------------------------------------------------
function s.indcon(e, tp, eg, ep, ev, re, r, rp)
	local rc = e:GetHandler():GetReasonCard()
	return r == REASON_SYNCHRO and rc and rc:IsSetCard(0x671)
end

function s.indop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local rc = c:GetReasonCard()
	if not rc then return end

	-- 赋予效果（每个怪兽各自独立计数）
	local e1 = Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id, 1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)					-- ★ 每个怪兽各自1回合1次
	e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD)
	rc:RegisterEffect(e1, true)

	-- 若同调怪兽不是效果怪兽，添加效果类型
	if not rc:IsType(TYPE_EFFECT) then
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD)
		rc:RegisterEffect(e2, true)
	end

	-- 客户端提示（鼠标悬停显示已获得额外效果）
	rc:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 2))
end

-- 筛选：未来战魔法陷阱
function s.filter(c)
	return c:IsSetCard(0x671) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter), tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_GRAVE + LOCATION_REMOVED)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.filter), tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, g)
	end
end