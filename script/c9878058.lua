--Little Vacation
c9878058.fusion_effect=true
function c9878058.initial_effect(c)
	 aux.AddCodeList(c,9877951,9877877)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9878058+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9878058.cost)
	e1:SetTarget(c9878058.target)
	e1:SetOperation(c9878058.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9878058,ACTIVITY_SPSUMMON,c9878058.counterfilter)
end
function c9878058.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ)
end
function c9878058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(9878058,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9878058.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c9878058.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not (c:IsType(TYPE_FUSION) or c:IsType(TYPE_XYZ) )
end
function c9878058.filter(c)
	return (aux.IsCodeListed(c,9877951) or aux.IsCodeListed(c,9877877)) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup()) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9878058.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c9878058.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsCodeListed(c,9877877) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9878058.xyzfilter(c)
	return aux.IsCodeListed(c,9877951) and c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil)
end
function c9878058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878058.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c9878058.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878058.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0 and Duel.SelectYesNo(tp,aux.Stringid(9878058,0)) then
	 local op=0
	 local g6=Duel.GetMatchingGroup(c9878058.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g6:GetCount()>0 then
	 op=Duel.SelectOption(tp,aux.Stringid(9878058,1),aux.Stringid(9878058,2))+1
	else
	 op=1
   end
	  if op==1 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c9878058.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(c9878058.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c9878058.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
			local e11=Effect.CreateEffect(e:GetHandler())
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e11:SetCode(EFFECT_CANNOT_ATTACK)
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e11)
			tc:CompleteProcedure()
		end
	   else
		   local g6=Duel.GetMatchingGroup(c9878058.xyzfilter,tp,LOCATION_EXTRA,0,nil)
			if g6:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tgx=g6:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tgx:GetFirst(),nil)
			end
	  end
	end
end