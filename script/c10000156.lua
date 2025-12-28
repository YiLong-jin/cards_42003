--首席管家·约瑟芬
local s, id, o = GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
    -- aux.AddXyzProcedure(c, s.matfilter, 7, 3)
    aux.AddXyzProcedureLevelFree(c, s.matfilter, nil, 3, 3)
    local e1 = Effect.CreateEffect(c)
	-- e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
    e1:SetCost(s.cost1)
    e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetCountLimit(1, id + 10000000)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end

function s.cost1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end

	e:GetHandler():RemoveOverlayCard(tp, 1, 1, REASON_COST)
end

function s.target1(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local types = {1057, 1056, 1063, 1073, 1076, 1074}
    Duel.SetTargetParam(Duel.SelectOption(tp, table.unpack(types)) + 1)
end

function s.operation1(e, tp, eg, ep, ev, re, r, rp)
    local opt = Duel.GetChainInfo(0, CHAININFO_TARGET_PARAM)
    local types = {TYPE_RITUAL, TYPE_FUSION, TYPE_SYNCHRO, TYPE_XYZ, TYPE_LINK, TYPE_PENDULUM}
    local typen = types[opt]
    local e1 = Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(typen)
	e1:SetTargetRange(1, 1)
	e1:SetTarget(s.sumlimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
	local e2 = Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
	e2:SetTarget(s.distg)
	e2:SetLabel(typen)
	e2:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e2, tp)
    local e3 = Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1, 0)
    e3:SetValue(s.aclimit)
    e3:SetReset(RESET_PHASE + PHASE_END)
    Duel.RegisterEffect(e3, tp)
end

function s.aclimit(e, re, tp)
    return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_DARK)
end 

function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&e:GetLabel()>0
end
function s.distg(e,c)
	return c:IsType(e:GetLabel())
end

function s.atkfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xafe4)
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local atkup = 0
    local defup = 0
    local monsters = Duel.GetMatchingGroup(s.atkfilter, tp, LOCATION_GRAVE, 0, nil)
    local current = monsters:GetFirst()
    while current do
        if current:GetTextAttack() >= 0 then
            atkup = atkup + current:GetTextAttack()
        end
        if current:GetTextDefense() >= 0 then
            defup = defup + current:GetTextDefense()
        end
        current = monsters:GetNext()
    end
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atkup)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e1:SetCode(EFFECT_UPDATE_DEFENSE)
    e1:SetValue(defup)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
    c:RegisterEffect(e2)
end