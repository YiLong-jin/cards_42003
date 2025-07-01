--秘源诱发的混乱
local cm,m,offset=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.target)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(POS_FACEUP_ATTACK)
	Duel.RegisterEffect(e2,tp)
end
function cm.target(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.changef(c)
	return c:GetControler()~=c:GetOwner()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.changef,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.changef,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if not tc:IsImmuneToEffect(e) and tc:GetFlagEffect(m)==0 then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
			tg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	tg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetEqualFunction(Card.GetFlagEffect,1,m))
	e1:SetLabelObject(tg)
	Duel.RegisterEffect(e1,tp)
	--force adjust
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	--reset
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetLabelObject(e2)
	e3:SetLabel(Duel.GetChainInfo(0,CHAININFO_CHAIN_ID))
	e3:SetOperation(cm.reset)
	Duel.RegisterEffect(e3,tp)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)==e:GetLabel() then
		local e2=e:GetLabelObject()
		local e1=e2:GetLabelObject()
		local tg=e1:GetLabelObject()
		for tc in aux.Next(tg) do
			tc:ResetFlagEffect(m)
			if tc:IsControler(tp) and tc:IsFaceup() then 
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_UPDATE_ATTACK)
				e4:SetValue(1000)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e4)
			end
		end
		tg:DeleteGroup()
		e1:Reset()
		e2:Reset()
		e:Reset()
	end
end
