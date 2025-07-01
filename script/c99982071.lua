--神谕昭现 门之主·彼岸回魂
local m=99982071
local cm=_G["c"..m]
function cm.initial_effect(c)
	
		
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(cm.spcon2)
	e2:SetCountLimit(1,99982071+EFFECT_COUNT_CODE_OATH)
	e2:SetOperation(c99982071.hvop)
	c:RegisterEffect(e2)
	
	
end

function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x66d) and c:IsType(TYPE_MONSTER)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) and Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>=Duel.GetLP(tp)
end
function cm.hvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,5000)
	Duel.RegisterFlagEffect(tp,99982071,0,0,0)
end



