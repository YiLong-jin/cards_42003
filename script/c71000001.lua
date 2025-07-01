--高速世界 2
local m=71000001
local cm=_G["c"..m]
local EFFECT_IMMUNE_SPWORLD = 71000000 --免疫规则送墓|被放置类效果替换|变成其他卡的叠放的卡
function cm.initial_effect(c)
	c:EnableCounterPermit(0x104d)
	c:SetCounterLimit(0x104d,12)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Act self
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_DECK+LOCATION_HAND)
	e2:SetCountLimit(1,71000001+EFFECT_COUNT_CODE_DUEL)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
	--Trag Draw
	local e17=Effect.CreateEffect(c)
	e17:SetCategory(CATEGORY_DRAW)
	e17:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_HAND)
	e17:SetCountLimit(1,71000040+EFFECT_COUNT_CODE_DUEL)
	e17:SetTarget(cm.tdrtg)
	e17:SetOperation(cm.tdrop)
	c:RegisterEffect(e17)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetOperation(cm.ctop)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_FZONE+LOCATION_DECK+LOCATION_HAND)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e7)
	local e8=e4:Clone()
	e8:SetCode(EFFECT_CANNOT_TO_GRAVE_AS_COST)
	c:RegisterEffect(e8)
	local e9=e4:Clone()
	e9:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(e9)
	local e10=e4:Clone()
	e10:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e10)
	local e20=e4:Clone()
	e20:SetRange(LOCATION_FZONE)
	e20:SetCode(EFFECT_IMMUNE_SPWORLD)
	c:RegisterEffect(e20)
	--xyzlimit
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_SINGLE)
	e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e18:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	--cannot Activate
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCode(EFFECT_CANNOT_ACTIVATE)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e11:SetTargetRange(1,0)
	e11:SetValue(cm.actlimit)
	c:RegisterEffect(e11)
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_SSET)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e12:SetRange(LOCATION_FZONE)
	e12:SetTargetRange(1,0)
	e12:SetTarget(cm.setlimit)
	c:RegisterEffect(e12)
	--cannot ex
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_FZONE)
	e13:SetCode(EFFECT_MUST_USE_MZONE)
	e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e13:SetValue(cm.zonelimit)
	e13:SetTargetRange(1,0)
	c:RegisterEffect(e13)
	--damage
	local e14=Effect.CreateEffect(c)
	e14:SetCategory(CATEGORY_DAMAGE)
	e14:SetDescription(aux.Stringid(m,1))
	e14:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e14:SetType(EFFECT_TYPE_IGNITION)
	e14:SetRange(LOCATION_FZONE)
	e14:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e14:SetCost(cm.ctcost(4))
	e14:SetTarget(cm.damtg)
	e14:SetOperation(cm.damop)
	c:RegisterEffect(e14)
	--draw
	local e15=Effect.CreateEffect(c)
	e15:SetCategory(CATEGORY_DRAW)
	e15:SetDescription(aux.Stringid(m,2))
	e15:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e15:SetType(EFFECT_TYPE_IGNITION)
	e15:SetRange(LOCATION_FZONE)
	e15:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e15:SetCost(cm.ctcost(7))
	e15:SetTarget(cm.drtg)
	e15:SetOperation(cm.drop)
	c:RegisterEffect(e15)
	--destroy
	local e16=Effect.CreateEffect(c)
	e16:SetCategory(CATEGORY_DESTROY)
	e16:SetDescription(aux.Stringid(m,3))
	e16:SetType(EFFECT_TYPE_IGNITION)
	e16:SetRange(LOCATION_FZONE)
	e16:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e16:SetCost(cm.ctcost(10))
	e16:SetTarget(cm.destg)
	e16:SetOperation(cm.desop)
	c:RegisterEffect(e16)
	--can't leave
	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_SINGLE)
	e19:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e19:SetRange(LOCATION_FZONE)
	e19:SetCode(EFFECT_SEND_REPLACE)
	e19:SetTarget(aux.TRUE)
	e19:SetValue(aux.TRUE)
	c:RegisterEffect(e19)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=Duel.MoveToField
		Duel.MoveToField=function(rc,p1,p2,loc,...)
			local fc=Duel.GetFieldCard(p2,LOCATION_FZONE,0)
			if loc==LOCATION_FZONE and fc and fc:IsHasEffect(EFFECT_IMMUNE_SPWORLD) then
				return false
			else
				return cm[0](rc,p1,p2,loc,...)
			end
		end
		cm[1]=Duel.SendtoGrave
		Duel.SendtoGrave=function(tc,...)
			local g=Group.__add(tc,Group.CreateGroup())
			local dg=g:Filter(Card.IsHasEffect,nil,EFFECT_IMMUNE_SPWORLD)
			g=Group.__sub(g,dg)
			if #g<1 then return 0 end
			return cm[1](g,...)
		end
		cm[2]=Duel.Overlay
		Duel.Overlay=function(tc,ocard)
			local g=Group.__add(ocard,Group.CreateGroup())
			local dg=g:Filter(Card.IsHasEffect,nil,EFFECT_IMMUNE_SPWORLD)
			g=Group.__sub(g,dg)
			if #g<1 then return end
			return cm[2](tc,g)
		end
	end
end
function cm.chainlimit(e,ep,tp)
	return e:GetHandler():IsCode(m)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetActivateEffect():IsActivatable(tp,true,true) end
	Duel.SetChainLimit(cm.chainlimit)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	Duel.ConfirmCards(sp,tc)
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local loc=tc:GetLocation()
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		if loc==LOCATION_HAND then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
	Duel.ShuffleHand(tp)
end
function cm.tdrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and not e:GetHandler():IsPublic() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(cm.chainlimit)
end
function cm.tdrop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x104d,1)
end
function cm.actlimit(e,re,tp)
	local c=re:GetHandler()
	if c:IsSetCard(0x7a0) then
		return c:IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsLocation(LOCATION_FZONE)
	else
		return c:IsType(TYPE_SPELL) and not c:IsLocation(LOCATION_PZONE)
	end
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_LINK)
end
function cm.zonelimit(e)
	return 0x1f001f | (0x600060 & ~0x60)
end
function cm.ctcost(ct)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,ct,REASON_COST) end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x104d,ct,REASON_COST)
	end
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end