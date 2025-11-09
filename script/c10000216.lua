--地底箱庭 红之惨剧
local s, id, o = GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_FUSION_SUMMON + CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
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

function s.spfilter1(c, e, tp, m, f, chkf) --融合怪兽（素材组=m）融合条件
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_FUSION, tp, false, false) and c:CheckFusionMaterial(m,nil,chkf)
end

function s.spfilter2(c, e, tp, m, f, chkf) --黑之裁判融合怪兽过滤条件
    return c:IsSetCard(0x5fe0) and s.spfilter1(c, e, tp, m, f, chkf) --复用普通融合条件
end

function s.mfilter0(c) --墓地怪兽除外代替融合素材条件
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end

function s.mfilter1(c, e)
    return not c:IsImmuneToEffect(e)
end

function s.mfilter2(c, e)
    return s.mfilter0(c) and not c:IsImmuneToEffect(e)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local chkf = tp
		local mg1 = Duel.GetFusionMaterial(tp) --常规融合素材
		local res = Duel.IsExistingMatchingCard(s.spfilter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg1, nil, chkf) --只用常规融合素材可以融合的融合怪兽
		if res then return true end
		local mg2 = Duel.GetMatchingGroup(s.mfilter0, tp, LOCATION_GRAVE, 0, nil) --墓地怪兽除外代替融合素材
		mg2:Merge(mg1) --加入常规素材
		res = Duel.IsExistingMatchingCard(s.spfilter2, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg2, nil, chkf) --含墓地怪兽作为融合素材可以融合的黑之裁判融合怪兽
		if not res then
			local ce = Duel.GetChainMaterial(tp)
			if ce ~= nil then
				local fgroup = ce:GetTarget()
				local mg3 = fgroup(ce,e,tp) --连锁素材
				local mf = ce:GetValue()
				res = Duel.IsExistingMatchingCard(s.spfilter1, tp, LOCATION_EXTRA, 0, 1, nil, e, tp, mg3, mf, chkf) --只用连锁素材进行融合的融合怪兽
			end
		end
		return res
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local chkf = tp
	local mg1 = Duel.GetFusionMaterial(tp):Filter(s.mfilter1, nil, e) --普通融合素材，但不得对此效果免疫
	local sg1 = Duel.GetMatchingGroup(s.spfilter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg1, nil, chkf) --适用普通融合素材即可融合召唤的怪兽
	local mg2 = Duel.GetMatchingGroup(s.mfilter2, tp, LOCATION_GRAVE, 0, nil, e) --墓地替代素材
	mg2:Merge(mg1) --包含普通素材
	local sg2 = Duel.GetMatchingGroup(s.spfilter2, tp, LOCATION_EXTRA, 0, nil, e, tp, mg2, nil, chkf) --适用包含墓地替代素材可以特殊召唤的黑之裁判融合怪兽
	sg1:Merge(sg2) --加入普通融合怪兽
	local mg3 = nil
	local sg3 = nil
	local ce = Duel.GetChainMaterial(tp)
	if ce ~= nil then
		local fgroup = ce:GetTarget()
		mg3 = fgroup(ce,e,tp)
		local mf = ce:GetValue()
		sg3 = Duel.GetMatchingGroup(s.spfilter1, tp, LOCATION_EXTRA, 0, nil, e, tp, mg3, mf, chkf) --适用连锁素材可以融合召唤的融合怪兽
	end
	if sg1:GetCount() > 0 or (sg3 ~= nil and sg3:GetCount() > 0) then --如果有可以融合召唤的怪兽
		local sg = sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local tg = sg:Select(tp, 1, 1, nil) --玩家选择的融合怪兽（待召唤）
		local tc = tg:GetFirst()
		if sg1:IsContains(tc) and (sg3 == nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp, ce:GetDescription())) then --不适用连锁素材效果
			if tc:IsSetCard(0x5fe0) then
                --是黑之裁判怪兽，可以适用替代素材
				local mat1 = Duel.SelectFusionMaterial(tp, tc, mg2, nil, chkf) --玩家选择的融合素材
				tc:SetMaterial(mat1)
				local mat2 = mat1:Filter(Card.IsLocation, nil, LOCATION_GRAVE) --所有替代的素材
				mat1:Sub(mat2) --将替代素材从素材组中除去
				Duel.SendtoGrave(mat1, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION) --普通素材送去墓地
				Duel.Remove(mat2, POS_FACEUP, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION) --替代素材除外
			else
                --是其他怪兽，不得适用替代素材
				local mat2 = Duel.SelectFusionMaterial(tp, tc, mg1, nil, chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2, REASON_EFFECT + REASON_MATERIAL + REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
		else
            --适用连锁素材的效果进行融合召唤
			local mat = Duel.SelectFusionMaterial(tp, tc, mg3, nil, chkf)
			local fop = ce:GetOperation()
			fop(ce, e, tp, tc, mat)
		end
		tc:CompleteProcedure()
	end
	s.cannotsp(e:GetHandler(), tp)
end