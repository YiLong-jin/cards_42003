--芝士七海莉雅
local s, id, o = GetID()

local TARGET_ID = 40800000

function s.initial_effect(c)
    local e = Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_IGNITION)
    e:SetRange(LOCATION_HAND)
    e:SetCountLimit(1, id)
    e:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e:SetCost(s.spcost)
    e:SetTarget(s.sptg)
    e:SetOperation(s.spop)
    c:RegisterEffect(e)
end

s.SetCard_RR_ZS = true -- 注册自定义字段逻辑

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetMZoneCount(tp) > 0 and Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) == 0
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(), 0, tp, tp, false, false, POS_FACEUP)
    end
end

function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    local c = e:GetHandler()
    local et = Effect.CreateEffect(c)
    et:SetType(EFFECT_TYPE_FIELD)
    et:SetTargetRange(0xff, 0xff)
    et:SetCode(EFFECT_ADD_CODE)
    et:SetValue(TARGET_ID)
    et:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CLIENT_HINT)
    et:SetDescription(aux.Stringid(id, 0))
    et:SetLabel(c:GetOriginalCodeRule())
    et:SetTarget(s.actg)
    Duel.RegisterEffect(et, tp)
end

function s.actg(e, c)
    return c:IsOriginalCodeRule(e:GetLabel())
end