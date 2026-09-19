--巴托尼亚-祭司骑士
function c21400151.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400151)
	e1:SetCondition(c21400151.spcon)
	e1:SetTarget(c21400151.sptg)
	e1:SetOperation(c21400151.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21400152) 
	e2:SetTarget(c21400151.fstg)
	e2:SetOperation(c21400151.fsop)
	c:RegisterEffect(e2)
	--SpecialSummon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,21400153)
	e3:SetCondition(c21400151.fumcon)
	e3:SetTarget(c21400151.fumtg)
	e3:SetOperation(c21400151.fumop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(21400151,ACTIVITY_CHAIN,c21400151.chainfilter)
end
function c21400151.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c21400151.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(21400151,tp,ACTIVITY_CHAIN)>0 
end
function c21400151.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400151.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c21400151.fcheck(tp,sg,fc) 
	return true 
end
function c21400151.gcheck(sg)
	return true 
end
function c21400151.mttg(e,c) 
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSetCard(0x5211) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c21400151.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:IsControler(e:GetHandlerPlayer())
end
function c21400151.filter(c,e,tp,m,f,chkf)
	return c:IsSetCard(0x5211) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21400151.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c21400151.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local me=Effect.CreateEffect(e:GetHandler())
		me:SetType(EFFECT_TYPE_FIELD)
		me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
		me:SetTargetRange(LOCATION_SZONE,0)
		me:SetTarget(c21400151.mttg)
		me:SetValue(c21400151.fuslimit)
		Duel.RegisterEffect(me,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c21400151.filter2,nil,e)
		aux.FCheckAdditional=c21400151.fcheck
		aux.GCheckAdditional=c21400151.gcheck
		local res=Duel.IsExistingMatchingCard(c21400151.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21400151.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		me:Reset()
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21400151.fsop(e,tp,eg,ep,ev,re,r,rp)
	local me=Effect.CreateEffect(e:GetHandler())
	me:SetType(EFFECT_TYPE_FIELD)
	me:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	me:SetTargetRange(LOCATION_SZONE,0)
	me:SetTarget(c21400151.mttg)
	me:SetValue(c21400151.fuslimit)
	Duel.RegisterEffect(me,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c21400151.filter2,nil,e)
	aux.FCheckAdditional=c21400151.fcheck
	aux.GCheckAdditional=c21400151.gcheck
	local sg1=Duel.GetMatchingGroup(c21400151.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21400151.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
end

function c21400151.fumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_FUSION+REASON_MATERIAL==REASON_FUSION+REASON_MATERIAL and not c:IsReason(REASON_RETURN)
end 
function c21400151.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(21400172) 
end 
function c21400151.fumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c21400151.thfil,tp,LOCATION_REMOVED,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end
function c21400151.fumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sg=Group.CreateGroup()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then sg:AddCard(c) end 
	local tc=Duel.SelectMatchingCard(tp,c21400151.thfil,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then sg:AddCard(tc) end 
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end 
end 


