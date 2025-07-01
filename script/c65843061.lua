--邪恶★双子的纳脏盒
local m=65843061
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CUSTOM+m)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.thfilter3)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	aux.RegisterMergedDelayedEvent(c,m,EVENT_TO_GRAVE,g)
	aux.RegisterMergedDelayedEvent(c,m,EVENT_REMOVE,g)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.discon)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)	  
end
function cm.thfilter3(e,c)
	return c:GetAttack()/1100==math.floor(c:GetAttack()/1100) and c:GetAttack()>0
end
function cm.cfilter2(c,e,tp)
	return (c:IsAbleToDeck() or c:IsAbleToExtra())
		and c:IsCanBeEffectTarget(e) and not c:IsType(TYPE_TOKEN)
		and c:GetOwner()==1-tp and c:IsReason(REASON_EFFECT+REASON_REDIRECT)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(cm.cfilter2,1,nil,e,tp) end
	local sg=eg:Filter(cm.cfilter2,nil,e,tp)
	Duel.SetTargetCard(sg)
	local ng=Group.CreateGroup()
	local ch=Duel.GetCurrentChain()
	local dg=Group.CreateGroup()
	if ch>1 then
		for i=1,ev do
			local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			if tgp~=tp and  Duel.IsChainDisablable(i) then
				local tc=te:GetHandler()
				ng:AddCard(tc)
			end
		end
	end
	if ng:GetCount()>0 then dg=Group.__band(sg,ng) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,#dg,dg:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(m,RESET_PHASE+TIMING_CHAIN_END,0,1,nil)
			tc=dg:GetNext()
		end
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:GetFlagEffect(m)~=0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
		--Duel.BreakEffect()
		--[[local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(m,RESET_PHASE+TIMING_CHAIN_END,0,1,nil)
			tc=dg:GetNext()
		end
		local ch=Duel.GetCurrentChain()
		if 1>0 then ch=3 end
		if ch>1 then--]]