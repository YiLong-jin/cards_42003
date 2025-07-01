--乐园福音十二信徒
function c10000129.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10000129+EFFECT_COUNT_CODE_OATH) 
	c:RegisterEffect(e1)	
	--atk counter 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1,20000129) 
	e1:SetTarget(c10000129.atctg) 
	e1:SetOperation(c10000129.atcop) 
	c:RegisterEffect(e1)  
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(function(e,c) 
	return c:GetCounter(0xaef0)*300 end) 
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetRange(LOCATION_SZONE) 
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(function(e,c) 
	return c:GetCounter(0xaef0)*300 end) 
	c:RegisterEffect(e1)
	--indes
end
function c10000129.atctg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil) 
end 
function c10000129.atcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(300) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsCode(10000127) and c:IsCanAddCounter(0xaef0,1) end,tp,LOCATION_MZONE,0,nil) 
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10000129,0)) then 
			local tc=g:GetFirst() 
			while tc do 
			tc:AddCounter(0xaef0,1) 
			tc=g:GetNext() 
			end 
		end 
	end 
end 



