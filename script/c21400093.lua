--纳垢赐福·染疥疮病
function c21400093.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,21400093+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21400093.actg)
	e1:SetOperation(c21400093.acop)
	c:RegisterEffect(e1)
end
function c21400093.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsCanAddCounter(0x1077,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1077,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1077,1)
end 
function c21400093.ctfil(c,tc) 
	return c:AddCounter(0x1077,1) and c:GetSequence()<5 and math.abs(c:GetSequence()-tc:GetSequence())==1 
end 
function c21400093.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x1077,1) then 
		local g=Duel.GetMatchingGroup(c21400093.ctfil,tp,0,LOCATION_MZONE,nil,tc) 
		if g:GetCount()>0 then 
			local xc=g:GetFirst()  
			while xc do  
			xc:AddCounter(0x1077,1)
			xc=g:GetNext() 
			end 
		end  
	end 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)  
	e1:SetCondition(c21400093.ctcon)
	e1:SetOperation(c21400093.ctop)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	Duel.RegisterEffect(e2,tp)
end
function c21400093.cckfil(c,tc) 
	return c:GetSequence()<5 and c:GetCounter(0x1077)>0 and math.abs(c:GetSequence()-tc:GetSequence())==1 
end 
function c21400093.xctfil(c) 
	return c:AddCounter(0x1077,1) and c:GetSequence()<5 and Duel.IsExistingMatchingCard(c21400093.cckfil,c:GetControler(),LOCATION_MZONE,0,1,nil,c)
end 
function c21400093.ctcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=eg:Filter(c21400093.xctfil,nil)
	return g:GetCount()>0 
end 
function c21400093.ctop(e,tp,eg,ep,ev,re,r,rp) 
	local g=eg:Filter(c21400093.xctfil,nil)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_CARD,0,21400093) 
		local xc=g:GetFirst()  
		while xc do  
		xc:AddCounter(0x1077,1)
		xc=g:GetNext() 
		end 
	end  
end 



