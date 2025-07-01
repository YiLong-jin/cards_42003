--与机骸签订的契约
function c10701180.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701180+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10701180.cost)
	e1:SetTarget(c10701180.target)
	e1:SetOperation(c10701180.activate)
	c:RegisterEffect(e1)  
	Duel.AddCustomActivityCounter(10701180,ACTIVITY_SPSUMMON,c10701180.counterfilter) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7610394,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,10701181)
	e2:SetTarget(c10701180.eqtg)
	e2:SetOperation(c10701180.eqop)
	c:RegisterEffect(e2) 
end
function c10701180.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function c10701180.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(10701180,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10701180.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c10701180.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c10701180.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c10701180.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c10701180.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x17cd) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c10701180.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27cd)
end
function c10701180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		local ct2=Duel.GetMatchingGroupCount(c10701180.chkfilter,tp,LOCATION_MZONE,0,nil)
		local chk2=ct2>0 and ct1-ct2==0
		if (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 or chk2) then
			local mg2=Duel.GetMatchingGroup(c10701180.filter0,tp,LOCATION_DECK,0,nil)
			mg1:Merge(mg2)
		end
		local res=Duel.IsExistingMatchingCard(c10701180.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c10701180.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701180.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(10701180,2))
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c10701180.filter1,nil,e)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetMatchingGroupCount(c10701180.chkfilter,tp,LOCATION_MZONE,0,nil)
	local chk2=ct2>0 and ct1-ct2==0
	if (Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 or chk2) then
		local mg2=Duel.GetMatchingGroup(c10701180.filter0,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
	end
	local sg1=Duel.GetMatchingGroup(c10701180.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c10701180.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
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
function c10701180.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x17cd)
		and Duel.IsExistingMatchingCard(c10701180.eqfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetOriginalAttribute(),tp)
end
function c10701180.eqfilter(c,att,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOriginalAttribute()==att 
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c10701180.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10701180.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10701180.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701180.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE)
end
function c10701180.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c10701180.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc:GetOriginalAttribute(),tp)
		local sc=g:GetFirst()
		if sc and Duel.Equip(tp,sc,tc) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			e1:SetValue(c10701180.eqlimit)
			sc:RegisterEffect(e1)
		end
	end
end
function c10701180.eqlimit(e,c)
	return c==e:GetLabelObject()
end