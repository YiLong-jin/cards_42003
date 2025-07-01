--奥秘·寒冰屏障
function c2222713.initial_effect(c)

------------------------------------------------------------------免疫效果伤害 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_F)
	e1:SetDescription(aux.Stringid(2222713,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL)
	--e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,2222713)
	--e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c2222713.condition)
	--e1:SetTarget(c2222713.target)
	e1:SetOperation(c2222713.operation)
	c:RegisterEffect(e1)
------------------------------------------------------------------免疫战斗伤害 2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL)
	--e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1,2222713)
	e2:SetCondition(c2222713.con)
	--e2:SetTarget(c2222713.target)
	e2:SetOperation(c2222713.op)
	c:RegisterEffect(e2)
end
------------------------------------------------------------------四速
function c2222713.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_QUICK_O) then
		Duel.SetChainLimit(c2222713.chainlm)
	end
end
function c2222713.chainlm(e,ep,tp)
	return tp==ep
end
------------------------------------------------------------------免疫效果伤害 1
function c2222713.condition(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetLabel(cid)
	Duel.RegisterEffect(e1,tp)
	return aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and cid>=Duel.GetLP(tp) and ep~=tp 
end
function c2222713.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,2222708,0,0,99)

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c2222713.damval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end

function c2222713.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==e:GetLabel()
end


function c2222713.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end

------------------------------------------------------------------免疫战斗伤害 2

function c2222713.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetBattleDamage(tp)>=Duel.GetLP(tp)
end

function c2222713.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function c2222713.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,2222708,0,0,99)
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)

	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(c2222713.damval)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)

	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)

end
