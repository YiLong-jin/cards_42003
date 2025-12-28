--万魔之王-希斯克利夫
local s, id, o = GetID()

function s.initial_effect(c)
    c:EnableReviveLimit()
    -- aux.AddXyzProcedure(c, s.matfilter, 7, 3)
    aux.AddXyzProcedureLevelFree(c, s.matfilter, nil, 3, 3)
    local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetTarget(s.desreptg)
	c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(s.spcon)
    e3:SetTarget(s.sptarget)
    e3:SetOperation(s.spop)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84941194,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(2, id)
	e4:SetCondition(s.spcon2)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end

function s.splimit(e, se, sp, st)
    return se:GetHandler():IsSetCard(0xafe4) or (st & SUMMON_TYPE_XYZ == SUMMON_TYPE_XYZ)
end

function s.desreptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then
        return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, nil)
    end
	if Duel.SelectEffectYesNo(tp, c, 96) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
		local g = Duel.SelectMatchingCard(tp, Card.IsAbleToRemove, tp, LOCATION_GRAVE, 0, 1, 1, nil)
		Duel.Remove(g, POS_FACEUP, REASON_EFFECT + REASON_REPLACE)
		return true
    end
    return false
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local rc = eg:GetFirst()
    return rc:IsRelateToBattle() and (rc:IsControler(tp) or (rc:GetOwner() == tp)) and rc:IsFaceup()
end

function s.sptarget(e, tp, eg, ep, ev, re, r, rp, chk)
    local tc = eg:GetFirst():GetBattleTarget()
    if chk == 0 then return (not tc:IsLocation(LOCATION_REMOVED) or tc:IsFaceup()) and (not tc:IsLocation(LOCATION_GRAVE) or aux.NecroValleyFilter()(tc)) and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false) and Duel.GetMZoneCount(tp) > 0 end
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, tc, 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    if Duel.GetMZoneCount(tp) <= 0 then return end
    Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
end

function s.cfilter(c, tp)
	return c:IsPreviousControler(1 - tp)
		and c:GetReasonPlayer() == tp and c:IsReason(REASON_EFFECT)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end

function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.cfilter, 1, nil, tp)
end

function s.spfilter2(c, e, tp)
    return c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and (not c:IsLocation(LOCATION_GRAVE) or aux.NecroValleyFilter()(c)) and c:IsFaceup()
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetMZoneCount(tp) > 0 and eg:IsExists(s.spfilter2, 1, nil, e, tp)
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, eg, 1, 0, 0)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    local max_num = Duel.GetMZoneCount(tp)
    if Duel.IsPlayerAffectedByEffect(tp, 59822133) then max_num = 1 end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = eg:FilterSelect(tp, s.spfilter2, 1, max_num, nil, e, tp)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end