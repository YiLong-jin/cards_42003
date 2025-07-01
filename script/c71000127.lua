--启门人 塔纳托斯
local m = 71000127
local cm = _G["c"..m]
function cm.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.damcon)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fid=c:GetFieldID()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,EFFECT_FLAG_CLIENT_HINT,1,fid,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
	c:RegisterEffect(e1)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPublic() and c:GetFlagEffect(m)~=0
end
function cm.damf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local d_s=Duel.GetMatchingGroupCount(cm.damf,tp,LOCATION_ONFIELD,0,nil)
	local d_o=Duel.GetMatchingGroupCount(cm.damf,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,d_s*600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,d_o*600)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local d_s=Duel.GetMatchingGroupCount(cm.damf,tp,LOCATION_ONFIELD,0,nil)
	local d_o=Duel.GetMatchingGroupCount(cm.damf,tp,0,LOCATION_ONFIELD,nil)
	Duel.Damage(tp,d_s*600,REASON_EFFECT)
	Duel.Damage(1-tp,d_o*600,REASON_EFFECT)
end