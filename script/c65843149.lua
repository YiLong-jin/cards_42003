--休息一下
function c65843149.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65843149+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65843149.target)
	e1:SetOperation(c65843149.activate)
	c:RegisterEffect(e1)	
end
--Fusion
function c65843149.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c:GetOriginalType()&TYPE_EFFECT==0
end
function c65843149.filter11(c,e)
	return not c:IsImmuneToEffect(e) and c:GetOriginalType()&TYPE_EFFECT==0
end
function c65843149.fusionfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x43ef) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c65843149.Fusionactivate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c65843149.filter11,nil,e)
	mg1:Merge(Duel.GetMatchingGroup(c65843149.filter1,tp,LOCATION_PZONE,0,nil,e))
	local sg1=Duel.GetMatchingGroup(c65843149.fusionfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c65843149.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
--Synchro
function c65843149.syncheck(g,tp,syncard)
	return syncard:IsSynchroSummonable(nil,g) and aux.SynMixHandCheck(g,tp,syncard)
		and aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) 
end
function c65843149.filter2(c,e)
	return c:IsCanBeSynchroMaterial() and not c:IsImmuneToEffect(e) and c:GetOriginalType()&TYPE_EFFECT==0
end
function c65843149.scfilter(c,tp,mg)
	return mg:CheckSubGroup(c65843149.syncheck,2,#mg,tp,c)
end
function c65843149.Synchroactivate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	mg:Merge(Duel.GetMatchingGroup(c65843149.filter2,tp,LOCATION_PZONE,0,nil,e))
	local g=Duel.GetMatchingGroup(c65843149.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
--Xyz
function c65843149.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c65843149.filter3(c,e)
	return not c:IsImmuneToEffect(e) and c:GetOriginalType()&TYPE_EFFECT==0
end
function c65843149.Xyzactivate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	mg:Merge(Duel.GetMatchingGroup(c65843149.filter3,tp,LOCATION_PZONE,0,nil,e))
	local g=Duel.GetMatchingGroup(c65843149.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,tc,mg,1,99)
	end
end
--LIink
function c65843149.linkfilter(c,mg)
	return c:IsLinkSummonable(mg)
end
function c65843149.filter4(c,e)
	return not c:IsImmuneToEffect(e) and c:GetOriginalType()&TYPE_EFFECT==0
end
function c65843149.Linkactivate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	mg:Merge(Duel.GetMatchingGroup(c65843149.filter4,tp,LOCATION_PZONE,0,nil,e))
	local g=Duel.GetMatchingGroup(c65843149.linkfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.LinkSummon(tp,tc,mg)
	end
end
function c65843149.target(e,tp,eg,ep,ev,re,r,rp,chk)
	--Fusion
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	mg1:Merge(Duel.GetMatchingGroup(c65843149.filter1,tp,LOCATION_PZONE,0,nil,e))
	local res=Duel.IsExistingMatchingCard(c65843149.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg11=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(c65843149.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg11,mf,chkf)
		end
	end
	--Synchro
	local mg2=Duel.GetSynchroMaterial(tp)
	if mg2:IsExists(Card.GetHandSynchro,1,nil) then
		local mg22=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg22:GetCount()>0 then mg2:Merge(mg22) end
	end
	mg2:Merge(Duel.GetMatchingGroup(c65843149.filter2,tp,LOCATION_PZONE,0,nil,e))
	--Xyz
	local mg3=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	mg3:Merge(Duel.GetMatchingGroup(c65843149.filter3,tp,LOCATION_PZONE,0,nil,e))
	--Link
	local mg4=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	mg4:Merge(Duel.GetMatchingGroup(c65843149.filter4,tp,LOCATION_PZONE,0,nil,e))
	local b1=res
	local b2=false--Duel.IsExistingMatchingCard(c65843149.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg2)
	local b3=false--Duel.IsExistingMatchingCard(c65843149.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg3)
	local b4=false--Duel.IsExistingMatchingCard(c65843149.linkfilter,tp,LOCATION_EXTRA,0,1,nil,mg4)
	if chk==0 then return  b1 or b2 or b3 or b4 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(65843149,1),1},
		{b2,aux.Stringid(65843149,2),2},
		{b3,aux.Stringid(65843149,3),3},
		{b4,aux.Stringid(65843149,4),4}
	)
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65843149.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then 
		c65843149.Fusionactivate(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		c65843149.Synchroactivate(e,tp,eg,ep,ev,re,r,rp)
	elseif op==3 then
		c65843149.Xyzactivate(e,tp,eg,ep,ev,re,r,rp)
	else
		c65843149.Linkactivate(e,tp,eg,ep,ev,re,r,rp)
	end
end