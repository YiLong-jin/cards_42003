--纳垢军团入侵
function c21400099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c21400099.target)
	e1:SetOperation(c21400099.activate)
	c:RegisterEffect(e1)
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21400099)
	e2:SetCost(c21400099.thcost)
	e2:SetTarget(c21400099.thtg)
	e2:SetOperation(c21400099.thop)
	c:RegisterEffect(e2)
end
function c21400099.filter(c,e,tp)
	return c:IsSetCard(0x9210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function c21400099.fufil(c,e,tp,m,f,chkf)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c21400099.fgoal(g,e,tp)
	return Duel.IsExistingMatchingCard(c21400099.fufil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,nil,tp)
end
function c21400099.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=Duel.GetMatchingGroup(c21400099.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>1 and mg:CheckSubGroup(c21400099.fgoal,2,2,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end 
function c21400099.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local mg=Duel.GetMatchingGroup(c21400099.filter,tp,LOCATION_HAND,0,nil,e,tp) 
	local mg1=mg:SelectSubGroup(tp,c21400099.fgoal,false,2,2,e,tp)
	if mg1:GetCount()>0 then  
		local tc=mg1:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			tc=mg1:GetNext()
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()  
		local sg1=Duel.GetMatchingGroup(c21400099.fufil,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,tp)
		if sg1:GetCount()>0 then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=sg:Select(tp,1,1,nil):GetFirst() 
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) 
			tc:CompleteProcedure()
		end
	end  
end
function c21400099.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end 
function c21400099.thfilter(c)
	return c:IsSetCard(0x9210) and c:IsAbleToHand()
end
function c21400099.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c21400099.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21400099.thfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21400099.thfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c21400099.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end




