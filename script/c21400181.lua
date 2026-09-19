--巴托尼亚-骑士降临
function c21400181.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,21400181)  
	e1:SetTarget(c21400181.actg)
	e1:SetOperation(c21400181.acop)
	c:RegisterEffect(e1)	
end
function c21400181.acfilter(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x5211) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c21400181.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE) 
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end 
	if chk==0 then return Duel.IsExistingMatchingCard(c21400181.acfilter,tp,LOCATION_DECK,0,2,nil) and ft>=2 end
end
function c21400181.setfil(c) 
	return c:IsSSetable() and c:IsCode(21400172)  
end 
function c21400181.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE) 
	if Duel.IsExistingMatchingCard(c21400181.acfilter,tp,LOCATION_DECK,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c21400181.acfilter,tp,LOCATION_DECK,0,2,2,nil)
		local tc=g:GetFirst()
		while tc do 
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e2) 
		tc=g:GetNext() 
		end 
		if Duel.IsExistingMatchingCard(c21400181.setfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(21400181,0)) then 
			Duel.BreakEffect() 
			local sc=Duel.SelectMatchingCard(tp,c21400181.setfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
			Duel.SSet(tp,sc) 
		end 
	end
end

