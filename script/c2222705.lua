--奥秘·火焰结界
function c2222705.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2222705,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,2222705)
	e1:SetCondition(c2222705.spcon)
	e1:SetTarget(c2222705.target)
	e1:SetOperation(c2222705.spop)
	c:RegisterEffect(e1)
end
function c2222705.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==1-tp
end
function c2222705.filter(c)
	return c:IsAttackPos()
end
function c2222705.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c2222705.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c2222705.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c2222705.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,2222708,0,0,99)
	local g=Duel.GetMatchingGroup(c2222705.filter,tp,0,LOCATION_MZONE,nil)
	local gs=g:GetCount()
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	Duel.Damage(1-tp,gs*500,REASON_EFFECT)
end
