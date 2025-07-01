--恐虐暴行·废
function c21400036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,21400036+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c21400036.condition)
	e1:SetTarget(c21400036.target)
	e1:SetOperation(c21400036.activate)
	c:RegisterEffect(e1)	
end
function c21400036.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6210) and c:IsRank(8)
end
function c21400036.condition(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c21400036.cfilter,tp,LOCATION_MZONE,0,1,nil) 
	local b2=Duel.GetTurnPlayer()==1-tp 
	if not (b1 or b2) then return false end 
	if not Duel.IsChainDisablable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp 
end
function c21400036.desfil(c,re) 
	return re:GetHandler():IsAttackBelow(c:GetAttack()) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6210)   
end 
function c21400036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400036.desfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c21400036.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsExistingMatchingCard(c21400036.desfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,re) then 
		local dg=Duel.SelectMatchingCard(tp,c21400036.desfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,re)
		if Duel.Destroy(dg,REASON_EFFECT)~=0 and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT) 
		end 
	end
end



