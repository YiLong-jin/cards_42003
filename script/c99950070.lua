--律者的悸动
local m=99950070
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.atkcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)

end
function cm.atkfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x366c)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,loc,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.atkfilter,tp,loc,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x66c) and c:IsRank(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,1,nil,tp,LOCATION_MZONE+LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
		local sg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tc:GetRace(),tc:GetAttribute())
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sc=sg:Select(tp,1,1,nil)
			Duel.SendtoGrave(sc,REASON_EFFECT)
		end
	Duel.Hint(24,0,aux.Stringid(m,0))
	end
end
function cm.tgfilter(c,race,attr)
	return c:IsAttribute(attr) and c:IsAbleToGrave()
end