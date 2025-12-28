--One Last Kiss/杜拉罕啊
local s, id, o = GetID()

function s.initial_effect(c)
    aux.AddCodeList(c, 10000152, 10000157)
    local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
    e1:SetCountLimit(1, id)
	c:RegisterEffect(e1)
    local e2 = Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(s.abscon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.abstg)
    e2:SetOperation(s.absope)
    c:RegisterEffect(e2)
end

function s.filter(c)
    return c:IsType(TYPE_XYZ) and c:IsSetCard(0xafe4) and c:IsFaceup()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function s.efilter(e,re)
	return e:GetHandler() ~= re:GetOwner()
end

function s.detfilter(c)
    return c:IsCode(10000157) and c:IsPreviousLocation(LOCATION_ONFIELD)
end

function s.abscon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.detfilter, 1, nil) and rp == 1 - tp
end

function s.spfilter(c, e, tp)
    return c:IsCode(10000152) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.abstg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.absope(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil)
    if #g > 0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end