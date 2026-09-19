--巴托尼亚-什一税
function c21400187.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400187,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,21400187)
	e1:SetCondition(c21400187.condition)
	e1:SetTarget(c21400187.target)
	e1:SetOperation(c21400187.activate)
	c:RegisterEffect(e1)	
end
function c21400187.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5211) and c:IsLevelAbove(5) 
end
function c21400187.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c21400187.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainDisablable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) and rp==1-tp 
end
function c21400187.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0) 
end
function c21400187.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local rc=re:GetHandler() 
		if rc:IsLevelAbove(5) then 
			Duel.BreakEffect() 
			Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		end 
	end
end 


