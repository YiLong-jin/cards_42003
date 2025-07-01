--奸奇军团入侵
function c21400069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c21400069.target)
	e1:SetOperation(c21400069.activate)
	c:RegisterEffect(e1)
	--thd 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,21400069) 
	e2:SetCost(c21400069.thdcost)
	e2:SetTarget(c21400069.thdtg)
	e2:SetOperation(c21400069.thdop)
	c:RegisterEffect(e2)
end
function c21400069.spfilter(c,e,tp)
	return c:IsSetCard(0x3210) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c21400069.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c21400069.lkfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c21400069.lkfilter(c,g)
	return c:IsSetCard(0x3210) and c:IsLinkSummonable(g,nil,g:GetCount(),g:GetCount())
end
function c21400069.chkfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x3210) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c21400069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end 
		if ft>3 then ft=3 end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local cg=Duel.GetMatchingGroup(c21400069.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local _,maxlink=cg:GetMaxGroup(Card.GetLink)
		if maxlink>ft then maxlink=ft end
		local g=Duel.GetMatchingGroup(c21400069.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		return g:CheckSubGroup(c21400069.fselect,1,maxlink,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c21400069.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>3 then ft=3 end
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(c21400069.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local cg=Duel.GetMatchingGroup(c21400069.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
	local _,maxlink=cg:GetMaxGroup(Card.GetLink)
	if ft>0 and maxlink then
		if maxlink>ft then maxlink=ft end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c21400069.fselect,false,1,maxlink,tp)
		if not sg then return end
		local tc=sg:GetFirst()
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
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
		local tg=Duel.GetMatchingGroup(c21400069.lkfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,rg:GetFirst(),og,nil,#og,#og)
		end
	end
end 
function c21400069.thdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD) 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1) 
end 
function c21400069.tdhfil(c) 
	return c:IsSetCard(0x3210) and c:IsAbleToHand() 
end 
function c21400069.thdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c21400069.tdhfil,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end 
	local g=Duel.SelectTarget(tp,c21400069.tdhfil,tp,LOCATION_GRAVE,0,2,2,nil)
end 
function c21400069.thdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,tp,REASON_EFFECT)  
	end 
end 

