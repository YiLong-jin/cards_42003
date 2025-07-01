--神谕昭现 门之主
local m=99982070
local cm=_G["c"..m]
function cm.initial_effect(c)
			--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(c99982070.acttg)
	e1:SetCountLimit(1,99982070+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c99982070.chop)
	c:RegisterEffect(e1)
	
--	local e2=Effect.CreateEffect(c)
--	e2:SetDescription(aux.Stringid(m,1))
--	e2:SetType(EFFECT_TYPE_ACTIVATE)
--	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
--	e2:SetCondition(cm.spcon2)
--	e2:SetCountLimit(1,99982070+EFFECT_COUNT_CODE_OATH)
--	e2:SetOperation(c99982070.hvop)
--	c:RegisterEffect(e2)
	
	
	
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>=Duel.GetLP(tp)
end
function cm.hvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,5000)
	Duel.RegisterFlagEffect(tp,99982071,0,0,0)
end












function c99982070.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end
function c99982070.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Damage(tp,1,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,99982071,0,0,0)
end
function c99982070.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1,REASON_EFFECT)
	Duel.RegisterFlagEffect(1-tp,99982070,0,0,0)
end






