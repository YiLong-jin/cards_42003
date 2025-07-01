--元素英雄融合
function c35100299.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,35100299)
	e1:SetTarget(c35100299.target)
	e1:SetOperation(c35100299.activate)
	c:RegisterEffect(e1)
	local  e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35100299,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,35100300)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c35100299.con)
	e3:SetTarget(c35100299.thtg)
	e3:SetOperation(c35100299.thop)
	c:RegisterEffect(e3,true)
end
function c35100299.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c35100299.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c35100299.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x8) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c35100299.fcheck(tp,sg,fc)
	local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x8) and (#dg<=0 or (#dg==1 and dg:GetFirst():IsFusionSetCard(0x8)))
end
function c35100299.gcheck(sg)
	local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x8) and (#dg<=0 or (#dg==1 and dg:GetFirst():IsFusionSetCard(0x8)))
end
function c35100299.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c35100299.filter0,tp,LOCATION_DECK,0,nil)
		if mg2:GetCount()>0 then 
			mg1:Merge(mg2)
			aux.FCheckAdditional=c35100299.fcheck
			aux.GCheckAdditional=c35100299.gcheck
		end
		local res=Duel.IsExistingMatchingCard(c35100299.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c35100299.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c35100299.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local exmat=false
	local mg1=Duel.GetFusionMaterial(tp):Filter(c35100299.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c35100299.filter0,tp,LOCATION_DECK,0,nil)
	if mg2:GetCount()>0 then 
		mg1:Merge(mg2)
		exmat=true
	end
	if exmat then
		aux.FCheckAdditional=c35100299.fcheck
		aux.GCheckAdditional=c35100299.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c35100299.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c35100299.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=c35100299.frcheck
				aux.GCheckAdditional=c35100299.gcheck
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
		tc:RegisterFlagEffect(35100299,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESET_TOFIELD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e2)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c35100299.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function c35100299.splimit(e,c)
	return not c:IsSetCard(0x8)
end
function c35100299.thfilter(c)
	return c:IsSetCard(0x8) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c35100299.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c35100299.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c35100299.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c35100299.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c35100299.fil(c)
	return c:GetFlagEffect(0)~=0
end
function c35100299.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c35100299.fil,1,nil)
end