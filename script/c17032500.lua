--升阶增益
function c17032500.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17032500,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c17032500.condition)
	e2:SetTarget(c17032500.target)
	e2:SetOperation(c17032500.operation)
	c:RegisterEffect(e2)
	--change cost
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(17032500,1))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(17032500)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c17032500.distg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(c17032500.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c17032500.xyzfilter(c,rk)
	local rank=c:GetRank()
	return c:IsType(TYPE_XYZ) and rank<rk
end
function c17032500.cfilter(c,tp)
	local rk=c:GetRank()
	local g=c:GetMaterial()
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
		and g:IsExists(c17032500.xyzfilter,1,nil,rk)
end
function c17032500.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17032500.cfilter,1,nil,tp)
end
function c17032500.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c17032500.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c17032500.distg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c17032500.eftg(e,c)
	local rk=c:GetRank()
	local g=c:GetMaterial()
	local tp=e:GetHandlerPlayer()
	return c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
		and g:IsExists(c17032500.xyzfilter,1,nil,rk)
end