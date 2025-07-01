--救世主的武装 虚化武器阵列
local m=9991130
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.operation1)
	c:RegisterEffect(e1)

	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.eqlimit)
	c:RegisterEffect(e2)
	--e wai gong ji
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetCondition(cm.indcon)
	e4:SetValue(4)
	c:RegisterEffect(e4)
	--zhan po kang xing
--	local e3=Effect.CreateEffect(c)
--	e3:SetType(EFFECT_TYPE_EQUIP)
--	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
--	e3:SetCondition(cm.indcon)
--	e3:SetValue(1)
--	c:RegisterEffect(e3)
	--damage val
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e6:SetCondition(cm.indcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)

	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,2))
	e8:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1,m+1)
	e8:SetTarget(cm.tgtg)
	e8:SetOperation(cm.tgop)
	c:RegisterEffect(e8)


	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(cm.bacon)
	e7:SetOperation(cm.baop)
	c:RegisterEffect(e7)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e9:SetRange(LOCATION_SZONE)
	e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e9:SetTarget(cm.eftg)
	e9:SetLabelObject(e7)
	c:RegisterEffect(e9)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function cm.tgfilter(c)
	return c:IsSetCard(0x669) and (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL))  and (c:IsAbleToGrave() or c:IsAbleToRemove())
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if cm.check(Duel.GetAttacker()) or cm.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,9991130,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,9991131,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.check(c)
	return c and c:IsCode(9991110)
end
function cm.bacon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,9991130)>=5 or Duel.GetFlagEffect(1-tp,9991131)>=5) and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.baop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,math.floor(e:GetHandler():GetAttack()*5),REASON_EFFECT)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetOperation(cm.tgop2)
	Duel.RegisterEffect(e3,tp)
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,0)
end
function cm.indcon(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:IsCode(9991110)
end
function cm.eqlimit(e,c)
	return c:IsCode(9999980) or c:IsCode(9991110)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(9999980) or c:IsCode(9991110)
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