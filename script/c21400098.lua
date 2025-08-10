--泼洒纳垢坩锅
function c21400098.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,21400098)  
	e1:SetTarget(c21400098.cttg)
	e1:SetOperation(c21400098.ctop)
	c:RegisterEffect(e1)
end
function c21400098.cttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1077,1)
	if chk==0 then return g:GetCount()>0 end 
end 
function c21400098.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1077,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1077,1)  
		tc=g:GetNext()
	end
end




