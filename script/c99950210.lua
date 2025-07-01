--裹挟律者的迷失·凡尘难渡
local m=99950210
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)

	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--copy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.ccon)
	e5:SetCost(cm.ccost)
	e5:SetTarget(cm.ctg)
	e5:SetOperation(cm.cop)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetTarget(cm.eftg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)

	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(cm.eqlimit)
	c:RegisterEffect(e3)

end
function cm.eqlimit(e,c)
	return c:IsSetCard(0x66c) and c:IsType(TYPE_XYZ)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	return (tc==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil) or tc==Duel.GetAttackTarget()
end
function cm.rmfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()<=atk 
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetEquipTarget()
	local tg=tc:GetBattleTarget()
	if chk==0 then return tg:IsAbleToRemove() and not tg:IsType(TYPE_TOKEN) end
	local atk=tg:GetAttack()
	local dg=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil,atk)
	dg:AddCard(tc)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,dg,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,dg,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,0,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local tg=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(500)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(500)
	tc:RegisterEffect(e2)
	Duel.SendtoGrave(c,REASON_EFFECT)
	if not tg:IsRelateToEffect(e) then return end
	if tg then
		Duel.BreakEffect()
		local atk=tg:GetAttack()
		local dg=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_MZONE,nil,atk)
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
		local sc=dg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(sc:GetAttack()/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(sc:GetDefense()/2)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
		sc=dg:GetNext()
		end
	end
end










function cm.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function cm.ProtectedRun(f,...)
	if not f then return true end
	local params={...}
	local ret={}
	local res_test=pcall(function()
		ret={f(table.unpack(params))}
	end)
	if not res_test then return false end
	return table.unpack(ret)
end
function cm.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local te=re:Clone()
	local tg=te:GetTarget()
	local code=te:GetCode()
	local tres,teg,tep,tev,tre,tr,trp
	if code>0 and code~=EVENT_FREE_CHAIN and code~=EVENT_CHAINING and Duel.CheckEvent(code) then
		tres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		local res=false
		if not tg then return true end
		if tres then return cm.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,0)
		else return cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,0) end
	end
	e:SetLabel(te:GetLabel())
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then
		if tres then
			cm.ProtectedRun(tg,e,tp,teg,tep,tev,tre,tr,trp,1)
		else
			cm.ProtectedRun(tg,e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ex:SetCode(EVENT_CHAIN_END)
	ex:SetLabelObject(e)
	ex:SetOperation(function(e)
		e:GetLabelObject():SetLabel(0)
		ex:Reset()
	end)
	Duel.RegisterEffect(ex,tp)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.cop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if te:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:GetHandler():ReleaseEffectRelation(e)
	end
	cm.ProtectedRun(op,e,tp,eg,ep,ev,re,r,rp)
end
--
function cm.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
























function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x66c) and c:IsType(TYPE_XYZ)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end