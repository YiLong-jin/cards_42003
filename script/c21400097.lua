--纳垢赐福·颅室畸形
function c21400097.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetCountLimit(1,21400097+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c21400097.chcon) 
	e1:SetTarget(c21400097.chtg)
	e1:SetOperation(c21400097.chop)
	c:RegisterEffect(e1)	
end
function c21400097.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp and bit.band(re:GetActivateLocation(),LOCATION_MZONE)~=0 
end 
function c21400097.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1077,1) end
end
function c21400097.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c21400097.repop)
end
function c21400097.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1077,1):GetFirst() 
	if tc then 
		tc:AddCounter(0x1077,1)
	end 
end




