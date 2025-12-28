--那一带的光 2025/12/02 22:30:10 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(this.fstg)
	e1:SetOperation(this.fsop)
	c:RegisterEffect(e1)
	--change name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.TRUE)
	e2:SetValue(0xa7a3)
	c:RegisterEffect(e2)
end
this.fusion_effect=true
function this.thfilter(c)
	return c:IsSetCard(0x97a3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function this.filter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function this.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res1=Duel.IsExistingMatchingCard(this.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	local res2=Duel.IsExistingMatchingCard(this.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res2 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res2=Duel.IsExistingMatchingCard(this.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end
	end
	if chk==0 then return res1 or res2 end
	local op=0
	if res1 and not res2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
		op=1
	end
	if res2 and not res1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		op=2
	end
	if res1 and res2 then
		op=aux.SelectFromOptions(tp,
			{res1,aux.Stringid(id,0),1},
			{res2,aux.Stringid(id,1),2})
	end
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function this.fsop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
		local sg1=Duel.GetMatchingGroup(this.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2,sg2=nil,nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(this.filter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if #sg1>0 or (sg2~=nil and #sg2>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			::cancel::
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or ce and not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				if #mat==0 then goto cancel end
				tc:SetMaterial(mat)
				Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			elseif ce~=nil then
				local mat=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				if #mat==0 then goto cancel end
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat)
			end
			tc:CompleteProcedure()
		end
	end
end
