--黒的宿敌 琳达梅尔
local s, id, o = GetID()

function s.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFunRep(c, 10000198, aux.FilterBoolFunction(Card.IsFusionSetCard, 0x5fe0), 1, 99, true, false)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e3:SetValue(s.val)
    c:RegisterEffect(e3)

    local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)

    local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end

function s.val(e, c)
    return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, LOCATION_MZONE) * 900
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c:GetMaterialCount() - 1)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_DISABLE)
	c:RegisterEffect(e1)
end