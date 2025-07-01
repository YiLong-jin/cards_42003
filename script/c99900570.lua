--决战连结 彩羽&八千代
local m=99900570
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode4(c,99900090,99900060,99900020,99900030,true,true)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cm.recon)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3) 
end
function cm.ffilter(c,fc,sub,mg,sg)
	return c:IsLocation(LOCATION_MZONE) and c:IsFusionSetCard(0x676) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function cm.recon(e, c)
	return e:GetHandler():GetSummonType() == SUMMON_TYPE_FUSION
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	--half atk
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_BASE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(cm.condition)
	e4:SetTarget(cm.atktg)
	e4:SetValue(cm.atkval)
	Duel.RegisterEffect(e4,tp)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_BASE_DEFENSE)
	e5:SetValue(cm.defval)
	Duel.RegisterEffect(e5,tp)
end
function cm.atkval(e,c)
	return math.ceil(c:GetBaseAttack()/2)
end
function cm.defval(e,c)
	return math.ceil(c:GetBaseDefense()/2)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(99900400)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.atktg(e,c)
	return c~=e:GetHandler()
end