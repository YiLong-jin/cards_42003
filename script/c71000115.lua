--脱缰难缚的枉然傲慢
local m=71000115
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(cm.actarget)
	e2:SetCost(cm.costchk)
	e2:SetOperation(cm.costop)
	c:RegisterEffect(e2)
	--summon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	--set cost
	local e5=e3:Clone()
	e5:SetCode(EFFECT_MSET_COST)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_SSET_COST)
	c:RegisterEffect(e6)
	--accumulate
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(0x10000000+m-2)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,1)
	c:RegisterEffect(e7)
	--target change
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e9:SetRange(LOCATION_SZONE)
	e9:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e9:SetCountLimit(1)
	e9:SetCondition(cm.tccon)
	e9:SetTarget(cm.tctg)
	e9:SetOperation(cm.tcop)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCondition(cm.con)
	e10:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(cm.fltg)
	e10:SetOperation(cm.flop)
	c:RegisterEffect(e10)
end
function cm.actarget(e,te,tp)
	return te:GetHandler():IsLocation(LOCATION_HAND)
end
function cm.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,m-2)
	return Duel.CheckLPCost(tp,ct*600)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	if tp~=e:GetHandler():GetFlagEffect(m) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(tp,600,REASON_COST)
end
function cm.tccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m-1)==4
end
function cm.tctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.tcop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.flop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m-1,RESET_EVENT+RESETS_STANDARD,0,1)
end













