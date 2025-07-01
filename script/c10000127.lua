--疫医
function c10000127.initial_effect(c)
	c:EnableCounterPermit(0xaef0)   
	--counter 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,10000127) 
	e1:SetTarget(c10000127.cttg) 
	e1:SetOperation(c10000127.ctop) 
	c:RegisterEffect(e1) 
	--sp 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) 
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,20000125)  
	e2:SetCondition(c10000127.spcon)
	e2:SetTarget(c10000127.sptg) 
	e2:SetOperation(c10000127.spop) 
	c:RegisterEffect(e2) 
end 
function c10000127.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanAddCounter(0xaef0,1) end  
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0xaef0)
end 
function c10000127.ctop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and c:AddCounter(0xaef0,1) and tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_DEFENSE) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(200) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
	end 
end 
function c10000127.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0xaef0)==8   
end  
function c10000127.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10000127.spfil(c,e,tp) 
	return c:IsCode(10000120) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)  
end   
function c10000127.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c10000127.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
		local tc=Duel.SelectMatchingCard(tp,c10000127.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end 
end 






