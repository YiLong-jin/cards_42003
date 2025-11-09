--三角冲击
local s, id = GetID()

function s.initial_effect(c)
	-- 速攻魔法
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 特殊召唤目标筛选
function s.spfilter(c, e, tp)
	return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsCode(71100802) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
end
function s.spfilter2(c, e, tp)
	return c:IsType(TYPE_LINK) and aux.IsCodeListed(c,71100802) and
		   c:IsCanBeSpecialSummoned(e, 0, tp, false, false) and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
end
function s.spmg(e,tp)
	local g=Group.CreateGroup()
	if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then 
		local g1=Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_DECK + LOCATION_REMOVED, 0, nil, e, tp)
		g:Merge(g1)
	end 
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then 
		local g2=Duel.GetMatchingGroup(s.spfilter2, tp, LOCATION_EXTRA, 0, nil, e, tp)
		g:Merge(g2)
	end 
	return g
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		local g=s.spmg(e,tp)
		return #g>0
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, tp, LOCATION_DECK + LOCATION_REMOVED + LOCATION_EXTRA)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	local c=e:GetHandler()
	local g=s.spmg(e,tp)
	if #g>0 then 
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
	end
end