--汇聚吧，星之光……
local cm,m=GetID()

function cm.initial_effect(c)
	aux.AddCodeList(c,9878079)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.opafilter)
	c:RegisterEffect(e1)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.atktg)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.actg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.effcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetRange(0x08)
	e0:SetCondition(cm.descon)
	e0:SetTarget(cm.destg)
	e0:SetOperation(cm.desop)
	c:RegisterEffect(e0)
	--adjust
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(0x08)
	e5:SetOperation(cm.adjustop)
	c:RegisterEffect(e5)
end

function cm.opafilter(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,Duel.GetTurnCount()+3)
	end
end

function cm.atktg(e,c)
	return aux.IsCodeListed(c,9878079)
end

function cm.actg(e,c)
	return c:IsFaceup() and aux.IsCodeListed(c,9878079)
end

function cm.conefilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9878079)
end

function cm.effcon(e)
	return Duel.IsExistingMatchingCard(cm.conefilter,e:GetHandlerPlayer(),0x04,0,1,nil)
end

function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end

function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(m)==Duel.GetTurnCount()
end

function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c,n=e:GetHandler(),Duel.GetFieldGroupCount(tp,0,0x0e)
	if chk==0 then return c:IsAbleToGrave() and n>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,n,1-tp,0x0e)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,n*1000)
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SendtoGrave(c,REASON_EFFECT) and c:IsLocation(0x10) then
		local g=Duel.GetFieldGroup(tp,0,0x0e)
		if #g>0 and Duel.Destroy(g,REASON_EFFECT) then
			local og=Duel.GetOperatedGroup()
			if #og>0 then
				Duel.Damage(1-tp,#og*1000,REASON_EFFECT)
			end
		end
	end
end

function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.conefilter,tp,0x04,0,1,nil) then
		Duel.SendtoGrave(e:GetHandler(),REASON_RULE)
	end
end