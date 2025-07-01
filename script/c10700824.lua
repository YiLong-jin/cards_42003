--夜想曲的准备
function c10700824.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700824+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10700824.target)
	e1:SetOperation(c10700824.activate)
	c:RegisterEffect(e1) 
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700824,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10700824.pctg)
	e2:SetOperation(c10700824.pcop)
	c:RegisterEffect(e2)   
end
function c10700824.chfilter(c)
	return c:IsPublic()
end
function c10700824.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c10700824.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10700824.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x7c9) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10700824.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c10700824.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c10700824.chfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		if ct>0 then
			local mgm=Duel.GetMatchingGroup(c10700824.filter0,tp,0,LOCATION_MZONE,nil)
			mg1:Merge(mgm)
		end
		if ct>1 then
			local mgd=Duel.GetMatchingGroup(c10700824.filter0,tp,LOCATION_DECK,0,nil)
			mg1:Merge(mgd)
		end
		if ct>2 then
			local mge=Duel.GetMatchingGroup(c10700824.filter0,tp,LOCATION_EXTRA,0,nil)
			mg1:Merge(mge)
		end
		local res=Duel.IsExistingMatchingCard(c10700824.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10700824.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10700824.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c10700824.chfilter,tp,LOCATION_HAND,0,nil)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10700824.filter1,nil,e)
	if ct>0 then
		local mgm=Duel.GetMatchingGroup(c10700824.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mgm)
	end
	if ct>1 then
		local mgd=Duel.GetMatchingGroup(c10700824.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mgd)
	end
	if ct>2 then
		local mge=Duel.GetMatchingGroup(c10700824.filter0,tp,LOCATION_EXTRA,0,nil)
		mg1:Merge(mge)
	end
	local sg1=Duel.GetMatchingGroup(c10700824.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10700824.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c10700824.pcfilter(c)
	return c:IsSetCard(0x7c9) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c10700824.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c10700824.pcfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c10700824.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10700824.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end