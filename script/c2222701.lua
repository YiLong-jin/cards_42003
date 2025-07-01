--奥秘·变形药水
function c2222701.initial_effect(c)

   local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,2222701)
	e1:SetCondition(c2222701.condition1)
	--e1:SetCost(c84749824.cost1)
	e1:SetTarget(c2222701.target1)
	e1:SetOperation(c2222701.activate1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e2)
end

function c2222701.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end

function c2222701.filter(c,tp)
	return aux.NegateMonsterFilter(c) and c:IsSummonPlayer(tp)
end

function c2222701.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return true end
	local g=eg:Filter(c2222701.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c2222701.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,2222708,0,0,99)
--那 之 前
	Duel.NegateSummon(eg)
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
--那 之 后
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,60764582,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK,1-tp) then return end
	local token=Duel.CreateToken(tp,60764582)
	Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
end





---------------------------------------------------------------------------------------

