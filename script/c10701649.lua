--断罪神的囚人
function c10701649.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701649,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10701649+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10701649.spcon)
	c:RegisterEffect(e1) 
	--atk/def up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701649,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,10701650)
	e3:SetCondition(c10701649.condition)
	e3:SetOperation(c10701649.operation)
	c:RegisterEffect(e3) 
end
function c10701649.filter(c)
	return (c:IsSetCard(0x7c0) or c:IsCode(24857466)) and c:IsFaceup()
end
function c10701649.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701649.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c10701649.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10701649.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(10701649,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetCondition(c10701649.actcon)
	e1:SetTarget(c10701649.acttg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10701649.cfilter(c)
	return (c:IsSetCard(0x7c0) or c:IsCode(24857466)) and c:IsLevel(8) and c:IsFaceup()
end
function c10701649.actcon(e)
	return Duel.IsExistingMatchingCard(c10701649.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c10701649.acttg(e,c)
	return c:GetType()==TYPE_TRAP+TYPE_COUNTER 
end