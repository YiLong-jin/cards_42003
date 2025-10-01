--交响曲·春江花月夜
function c69969275.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c69969275.mfilter1,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR+RACE_SPELLCASTER),true)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969275,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,69969275)
	e1:SetCondition(c69969275.spcon1)
	e1:SetTarget(c69969275.fsptg)
	e1:SetOperation(c69969275.fspop)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969275,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c69969275.spcon2)
	e3:SetTarget(c69969275.sptg2)
	e3:SetOperation(c69969275.spop2)
	c:RegisterEffect(e3)
	end
	function c69969275.mfilter1(c)
	return c:IsFusionSetCard(0x69b) and c:IsFusionType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
	function c69969275.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c69969275.mttg(e,c)
	local tc=c:GetEquipTarget()
	return tc and tc:IsFaceup() and tc:IsSetCard(0x69b) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c69969275.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c69969275.filter(c,e,tp,m,f,chkf)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c69969275.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c69969275.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local me=Effect.CreateEffect(e:GetHandler())
		me:SetType(EFFECT_TYPE_FIELD)
		me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		me:SetTargetRange(LOCATION_SZONE,0)
		me:SetTarget(c69969275.mttg)
		me:SetValue(c69969275.fuslimit)
		Duel.RegisterEffect(me,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c69969275.filter2,nil,e)
		local res=Duel.IsExistingMatchingCard(c69969275.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c69969275.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		me:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c69969275.fspop(e,tp,eg,ep,ev,re,r,rp)
	local me=Effect.CreateEffect(e:GetHandler())
	me:SetType(EFFECT_TYPE_FIELD)
	me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	me:SetTargetRange(LOCATION_SZONE,0)
	me:SetTarget(c69969275.mttg)
	me:SetValue(c69969275.fuslimit)
	Duel.RegisterEffect(me,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c69969275.filter2,nil,e)
	local sg1=Duel.GetMatchingGroup(c69969275.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c69969275.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		::cancel::
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			if #mat1==0 then goto cancel end
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		elseif ce~=nil then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			if #mat2==0 then goto cancel end
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	me:Reset()
end
--2
function c69969275.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c69969275.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c69969275.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	local tc=c:GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(rg)
			Duel.BreakEffect()
			res=Duel.SendtoHand(rg,nil,REASON_EFFECT)
	end
end
aux.LabrynthDestroyOp(e,tp,res)
end