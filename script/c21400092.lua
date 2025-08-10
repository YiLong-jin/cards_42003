--纳垢赐福·坏躯生蝇
function c21400092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c21400092.target)
	e1:SetOperation(c21400092.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21400092)
	--e2:SetCost(c21400092.thcost)
	e2:SetTarget(c21400092.thtg)
	e2:SetOperation(c21400092.thop)
	c:RegisterEffect(e2)
end
function c21400092.filter0(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c21400092.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c21400092.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9210) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end 
function c21400092.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1 
	   and sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
	   and sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=1
end
function c21400092.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)<=1 
	   and sg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)<=1
	   and sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<=1
end
function c21400092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp) 
		local mg2=Duel.GetMatchingGroup(c21400092.filter0,tp,LOCATION_EXTRA,0,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=c21400092.fcheck
		aux.GCheckAdditional=c21400092.gcheck  
		local res=Duel.IsExistingMatchingCard(c21400092.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c21400092.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21400092.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c21400092.filter1,nil,e)  
	local mg2=Duel.GetMatchingGroup(c21400092.filter0,tp,LOCATION_EXTRA,0,nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=c21400092.fcheck
	aux.GCheckAdditional=c21400092.gcheck 
	local sg1=Duel.GetMatchingGroup(c21400092.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c21400092.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then 
			aux.FCheckAdditional=c21400092.fcheck
			aux.GCheckAdditional=c21400092.gcheck 
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
function c21400092.costfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x9210) or c:GetCounter(0x1077)>0) and c:IsAbleToGrave()
end
function c21400092.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400092.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400092.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c21400092.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c21400092.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c21400092.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c21400092.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end




