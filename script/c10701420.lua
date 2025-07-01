--金化终焉之黄金国永生药
function c10701420.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701420,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701420)
	e1:SetTarget(c10701420.target)
	e1:SetOperation(c10701420.activate)
	c:RegisterEffect(e1) 
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20612097,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10701420)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c10701420.settg)
	e2:SetOperation(c10701420.setop)
	c:RegisterEffect(e2)   
end
function c10701420.cfilter(c)
	return c:IsSetCard(0x1142) and c:IsFaceup()
end
function c10701420.filter0(c,e,tp,check)
	return c:IsSetCard(0x1142) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and (check or c:IsRace(RACE_ZOMBIE))
end
function c10701420.filter1(c,e,tp,check)
	return (check or c:IsRace(RACE_ZOMBIE)) and not c:IsImmuneToEffect(e)
end
function c10701420.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10701420.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c10701420.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c10701420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local chk1=Duel.IsExistingMatchingCard(c10701420.cfilter,tp,LOCATION_MZONE,0,1,nil)
		local mg1=Duel.GetFusionMaterial(tp)
		mg1:Merge(Duel.GetMatchingGroup(c10701420.filter1,tp,0,LOCATION_MZONE,nil,e))
		if not Duel.IsExistingMatchingCard(c10701420.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local mg2=Duel.GetMatchingGroup(c10701420.filter0,tp,LOCATION_DECK,0,nil,e,tp,chk1)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=c10701420.fcheck
				aux.GCheckAdditional=c10701420.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c10701420.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10701420.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701420.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local chk1=Duel.IsExistingMatchingCard(c10701420.cfilter,tp,LOCATION_MZONE,0,1,nil)
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10701420.filter1,nil,e,tp,chk1)
	mg1:Merge(Duel.GetMatchingGroup(c10701420.filter1,tp,0,LOCATION_MZONE,nil,e))
	local exmat=false
	if not Duel.IsExistingMatchingCard(c10701420.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local mg2=Duel.GetMatchingGroup(c10701420.filter0,tp,LOCATION_DECK,0,nil,e,tp,chk1)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c10701420.fcheck
		aux.GCheckAdditional=c10701420.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c10701420.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10701420.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c10701420.fcheck
				aux.GCheckAdditional=c10701420.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
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
function c10701420.stfilter(c)
	return c:IsSetCard(0x143) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10701420.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10701420.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c10701420.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10701420.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end