--一发☆¥30000
local m=71100200
local cm=_G["c"..m]
local code=0x7d2 --空枪指示物
function cm.initial_effect(c)
	c:EnableCounterPermit(code)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_DICE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.aclimit)
	c:RegisterEffect(e2)
end
cm.toss_dice=true
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	c:AddCounter(code,d)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local co=c:GetCounter(code)
	local p=Duel.GetTurnPlayer()
	local d=Duel.TossDice(p,1)
	if d<co then
		c:RemoveCounter(p,code,1,REASON_EFFECT)
		if Duel.Draw(p,1,REASON_EFFECT)==0 then return end
		local tc=Duel.GetOperatedGroup():GetFirst()
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	elseif Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Damage(p,d*400,REASON_EFFECT)
	end
end
function cm.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	local tc=re:GetHandler()
	return loc==LOCATION_HAND and tc:IsPublic() and tc:GetFlagEffect(m)>0
end













