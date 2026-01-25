--异谣言鹤乃-原点觉醒
c9877893.Uwasa=true
function c9877893.initial_effect(c)
	aux.AddCodeList(c,9877877,9877881)
	 c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c9877893.ffilter,3,true)
	aux.EnableChangeCode(c,9877881,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsLocation(LOCATION_EXTRA) end)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877893,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9877893)
	e3:SetCondition(c9877893.descon)
	e3:SetTarget(c9877893.destg)
	e3:SetOperation(c9877893.desop)
	c:RegisterEffect(e3)


	 local e12=Effect.CreateEffect(c) 
	e12:SetDescription(aux.Stringid(9877893,2))
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE)
	e12:SetType(EFFECT_TYPE_QUICK_O)  
	e12:SetCode(EVENT_FREE_CHAIN) 
	e12:SetHintTiming(0,TIMING_END_PHASE)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e12:SetRange(LOCATION_MZONE) 
	e12:SetCountLimit(1,9877893) 
	e12:SetTarget(c9877893.tgdtg) 
	e12:SetOperation(c9877893.tgdop)
	c:RegisterEffect(e12)  
	
end
function c9877893.ffilter(c,fc,sub,mg,sg)
	return aux.IsCodeListed(c,9877877) 
end 


function c9877893.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end 
function c9877893.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c9877893.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	if #dg==0 then return end
	Duel.HintSelection(dg)
	Duel.Destroy(dg,REASON_EFFECT)
end


function c9877893.tgfil(c) 
	return c:IsFaceup() and c:IsAbleToDeck() and aux.IsCodeListed(c,9877877) 
end 
function c9877893.tgdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9877893.tgfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end 
	local g=Duel.SelectTarget(tp,c9877893.tgfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c9877893.tgdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9877893,1)) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst() 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end 
end 