--死灵舞者 爱丽丝肯斯坦
function c71100573.initial_effect(c)
	c:SetSPSummonOnce(71100573)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),1,99,true)
	--fusion 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCondition(c71100573.fuscon)
	e1:SetTarget(c71100573.fustg)
	e1:SetOperation(c71100573.fusop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsType(TYPE_FUSION) end,tp,LOCATION_MZONE,0,e:GetHandler())
	return g:GetSum(Card.GetLevel)*300 end)
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e3) 
end 
function c71100573.fuscon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c71100573.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c71100573.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c71100573.fexfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7d8) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c71100573.frcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c71100573.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c71100573.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp) 
		local mg2=Duel.GetMatchingGroup(c71100573.fexfilter,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			aux.FCheckAdditional=c71100573.frcheck
			aux.GCheckAdditional=c71100573.gcheck
		end 
		local res=Duel.IsExistingMatchingCard(c71100573.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c71100573.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71100573.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c71100573.filter1,nil,e)
	local exmat=false 
	local mg2=Duel.GetMatchingGroup(c71100573.fexfilter,tp,LOCATION_DECK,0,nil)
	if mg2:GetCount()>0 then
		mg1:Merge(mg2)
		exmat=true
	end 
	if exmat then
		aux.FCheckAdditional=c71100573.frcheck
		aux.GCheckAdditional=c71100573.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c71100573.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c71100573.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c71100573.frcheck
				aux.GCheckAdditional=c71100573.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
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
