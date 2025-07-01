--色孽军团入侵
function c21400051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c21400051.target)
	e1:SetOperation(c21400051.activate)
	c:RegisterEffect(e1) 
	--To hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21400051)
	e2:SetCost(c21400051.thcost)
	e2:SetTarget(c21400051.thtg)
	e2:SetOperation(c21400051.thop)
	c:RegisterEffect(e2)
end
function c21400051.filter(c,e,tp)
	return c:IsSetCard(0x5210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21400051.xyzfilter(c,mg)
	return c:IsSetCard(0x5210) and c:IsSynchroSummonable(nil,mg,2,2)
end
function c21400051.mfilter1(c,mg,exg)
	return mg:IsExists(c21400051.mfilter2,1,c,c,exg)
end
function c21400051.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsSynchroSummonable,1,nil,nil,Group.FromCards(c,mc))
end
function c21400051.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=Duel.GetMatchingGroup(c21400051.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c21400051.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and exg:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end 
function c21400051.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local mg=Duel.GetMatchingGroup(c21400051.filter,tp,LOCATION_HAND,0,nil,e,tp)
	local exg=Duel.GetMatchingGroup(c21400051.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c21400051.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c21400051.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2) 
	if sg1:GetCount()<2 then return end
	local tc=sg1:GetFirst()
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
		tc=sg1:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	if sg1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local xyzg=Duel.GetMatchingGroup(c21400051.xyzfilter,tp,LOCATION_EXTRA,0,nil,sg1)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,xyz,nil,sg1)
	end
end
function c21400051.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end 
function c21400051.thfilter(c)
	return c:IsSetCard(0x5210) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21400051.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21400051.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21400051.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c21400051.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c21400051.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g) 
	end
end


