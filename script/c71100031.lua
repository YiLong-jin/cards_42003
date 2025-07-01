--号哭于V城的祭坛
local m=71100031
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--effect change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.ectg)
	e2:SetOperation(cm.ecop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	return c:IsCode(71100032)
end
function cm.overmfilter(c)
	local tc=c:GetOverlayTarget()
	return c:GetLevel()>0 and tc:IsType(TYPE_XYZ) and tc:IsSetCard(0x7d0) and c:IsAbleToGrave()
end
function cm.mfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x7d0) or c:IsSetCard(0x7d1))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	if Duel.GetOverlayCount(tp,1,0) then
		local xg=Duel.GetOverlayGroup(tp,1,0)
		local sg=xg:Filter(cm.overmfilter,nil)
		mg:Merge(sg)
	end
	mg=mg:Filter(cm.mfilter,nil)
	local g=Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,cm.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.costfilter(c)
	return c:IsSetCard(0x7d0) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if chk==0 then return c1g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c1g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.ectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.ecop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.RegisterFlagEffect(tp,71100031,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
end









