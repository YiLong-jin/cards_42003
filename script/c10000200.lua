--与心爱的你一同行至世界的尽头
local s, id, o = GetID()

function s.initial_effect(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_FUSION_SUMMON + CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
    e1:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    e2:SetHintTiming(0, TIMINGS_CHECK_MONSTER + TIMING_END_PHASE)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(), LOCATION_ONFIELD, 0) == 0
end

function s.tgfilter(c, tp)
    return c:IsFusionCode(10000198) and c:IsAbleToRemove(tp, POS_FACEDOWN, REASON_FUSION + REASON_MATERIAL) and c:IsCanBeFusionMaterial()
end

function s.filter0(c, e, tp)
    return c:IsAbleToRemove(tp, POS_FACEDOWN, REASON_FUSION + REASON_MATERIAL) and not c:IsImmuneToEffect(e)
end

function s.filter1(c, e, tp, m, f, chkf, mmust)
    if not (c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) and c:IsSetCard(0x5fe0)) then return false end
    return c:CheckFusionMaterial(m, mmust, chkf)
end

function s.filter1_mergev(c, e, tp, m, f, chkf, mmust)
    local mc = m:Clone()
    mc:AddCard(mmust)
    return s.filter1(c, e, tp, mc, f, chkf, mmust)
end


function s.test(mmust, e, tp, mg, chkf)
    if not s.tgfilter(mmust, tp) then return false end
    local cpmg = mg:Clone()
    cpmg:AddCard(mmust)
    local res = Duel.IsExistingMatchingCard(s.filter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, cpmg, nil, chkf, mmust)
    if not res then
        local ce = Duel.GetChainMaterial(tp)
        if ce ~= nil then
            local fgroup = ce:GetTarget()
            local mg2 = fgroup(ce, e, tp)
            local mf = ce:GetValue()
            res = Duel.IsExistingMatchingCard(s.filter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg2, mf, chkf, nil)
        end
    end
    return res
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local chkf = tp
    local mg = Duel.GetFusionMaterial(tp):Filter(s.filter0, nil, e, tp) --素材列表（场上/手牌）
    if chkc then
        return s.test(chkc, e, tp, mg, chkf) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.test, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, mg, chkf)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
    local g = Duel.SelectTarget(tp, s.test, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp, mg, chkf)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, tp, g, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.fdfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end

function s.cannotsp(c, tp)
    local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1, 0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE + PHASE_END)
	Duel.RegisterEffect(e1, tp)
end

function s.splimit(e, c)
	return not c:IsSetCard(0x5fe0)
end

function s.operation(e, tp, eg, ep, ev, re, r, rp)
    local mmust = Duel.GetFirstTarget()
    if not mmust:IsRelateToEffect(e) or mmust:IsImmuneToEffect(e) or not aux.NecroValleyFilter(aux.TRUE)(mmust) then
        s.cannotsp(e:GetHandler(), tp)
        return
    end
    local chkf = tp
    local mg = Duel.GetFusionMaterial(tp):Filter(s.filter0, nil, e, tp) --素材列表（场上/手牌）
    local sg1 = Duel.GetMatchingGroup(s.filter1_mergev, tp, LOCATION_EXTRA, 0, nil, e, tp, mg, nil, chkf, mmust) --不适用连锁素材情况下的融合候选
    local mg2 = nil
    local sg2 = nil
    local ce = Duel.GetChainMaterial(tp)
    if ce ~= nil then
        local fgroup = ce:GetTarget()
        mg2 = fgroup(ce, e, tp) --素材列表（连锁素材）
        local mf = ce:GetValue()
        sg2 = Duel.GetMatchingGroup(s.filter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, mf, chkf, nil) --适用连锁素材情况下的融合候选
    end
    if #sg1 > 0 or (sg2 ~= nil and #sg2 > 0) then
        local sg = sg1:Clone() --所有融合候选
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
        local tg = sg:Select(tp, 1, 1, nil)
        local tc = tg:GetFirst() --经玩家选择，待融合的融合怪兽
        if sg1:IsContains(tc) and (sg2 == nil or not sg2:IsCOntains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then
            --不适用连锁素材情况下的融合
            local mgcp = mg:Clone()
            mgcp:AddCard(mmust)
            local mat1 = Duel.SelectFusionMaterial(tp, tc, mgcp, mmust, chkf) --选择的融合素材
            tc:SetMaterial(mat1)
            if mat1:IsExists(s.fdfilter, 1, nil) then
                local cg = mat1:Filter(s.fdfilter, nil)
                Duel.ConfirmCards(1 - tp, cg)
            end
            if mat1:IsExists(aux.NOT(s.fdfilter), 1, nil) then
                local cg = mat1:Filter(aux.NOT(s.fdfilter), nil)
                Duel.HintSelection(cg)
            end
            Duel.Remove(mat1, POS_FACEDOWN, REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
        else
            --适用连锁素材情况下的融合
            local mat2 = Duel.SelectFusionMaterial(tp, tc, mg2, nil, chkf)
            local fop = ce:GetOperation()
            fop(ce, e, tp, tc, mat2)
        end
        tc:CompleteProcedure()
    end
    s.cannotsp(e:GetHandler(), tp)
end