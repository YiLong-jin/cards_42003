--融合测试
function c99900600.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99900600,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99900600+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99900600.target)
	e1:SetOperation(c99900600.activate)
	c:RegisterEffect(e1)
------------------------------------------------------------------------------------------------------------------------------------------------
end
function c99900600.filter(c)
	return c:IsFaceup() and c:IsCode(99940200)
end
function c99900600.filter0(c)
	return (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c99900600.filter1(c,e)
	return (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:IsType(TYPE_MONSTER)
end
function c99900600.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x676) and c:IsLevelBelow(9) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c99900600.fexfilter(c)
	return c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c99900600.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c99900600.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c99900600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(c99900600.filter0,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_REMOVED,0,nil)
		if Duel.IsExistingMatchingCard(c99900600.filter,tp,LOCATION_MZONE,0,1,nil) then
			local mg2=Duel.GetMatchingGroup(c99900600.fexfilter,tp,LOCATION_DECK,0,nil)
			if #mg2>0 then
				mg1:Merge(mg2)
				aux.FCheckAdditional=c99900600.frcheck
				aux.GCheckAdditional=c99900600.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c99900600.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c99900600.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99900600.activate(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("看这里，都看TM这里，我宣布一个事情，我要融合，我TM要融合啊！！！！！！！！！！！！")
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(c99900600.filter1,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_REMOVED,0,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c99900600.filter,tp,LOCATION_MZONE,0,1,nil) then
		local mg2=Duel.GetMatchingGroup(c99900600.fexfilter,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		aux.FCheckAdditional=c99900600.frcheck
		aux.GCheckAdditional=c99900600.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c99900600.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c99900600.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c99900600.frcheck
				aux.GCheckAdditional=c99900600.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
			mat1:Sub(mat2)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_RETURN)
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