--黑骑士小队-清月
function c9877623.initial_effect(c)
	 local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9877623)
	e1:SetCondition(c9877623.spcon)
	e1:SetTarget(c9877623.sptg)
	e1:SetOperation(c9877623.spop)
	c:RegisterEffect(e1) 

	
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_PAY_LPCOST) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1877623)
	e2:SetTarget(c9877623.ddtg)  
	e2:SetOperation(c9877623.ddop) 
	c:RegisterEffect(e2) 

end
function c9877623.f(c)
	return c:IsFaceup() and c:IsSetCard(0x17ec)
end
function c9877623.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9877623.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9877623.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877623.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c9877623.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c9877623.tspfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x17ec)
end
function c9877623.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9877623.tspfil,tp,LOCATION_HAND,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end  
function c9877623.ddop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877623.tspfil,tp,LOCATION_HAND,0,nil,e,tp) 
	local g1=Duel.GetMatchingGroup(c9877623.tgfil1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
		local sg=g:Select(tp,1,1,nil) 
		local x=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		if x>0 and g1:GetCount()>0 and Duel.CheckLPCost(tp,3000)  and Duel.SelectYesNo(tp,aux.Stringid(9877623,0)) then 
			Duel.PayLPCost(tp,3000)
			local xg=g1:Select(tp,1,1,nil) 
			Duel.SendtoHand(xg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,xg)
		end  
	end  
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9877623.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9877623.splimit(e,c)
	return not c:IsSetCard(0x17ec) 
end