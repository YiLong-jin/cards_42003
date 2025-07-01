--RWBY武装 Gambol Shroud
local m=99910070
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99910050,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCondition(cm.rscon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(99910030,2))
	e4:SetCountLimit(1,99910100)
	e4:SetCondition(cm.negcon2)
	c:RegisterEffect(e4)


	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99910050,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.tfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x679)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.tfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
--
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	end
	if tc:IsCode(99910030) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(m,2))
		e2:SetCategory(CATEGORY_DISABLE)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1,99910070)
		e2:SetCost(cm.tdcost)
		e2:SetTarget(cm.tdtg)
		e2:SetOperation(cm.tdop)
		e2:SetCondition(cm.negcon10)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2,true)
		tc:RegisterFlagEffect(0,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		Duel.Readjust()
			local e4=e2:Clone()
			e4:SetType(EFFECT_TYPE_QUICK_O)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetHintTiming(0,TIMING_END_PHASE)
			e4:SetCondition(cm.negcon3)
			tc:RegisterEffect(e4,true)
			local e3=e2:Clone()
			e3:SetCost(cm.tdcost1)
			e3:SetCondition(cm.negcon4)
			tc:RegisterEffect(e3,true)
			local e5=e2:Clone()
			e5:SetTarget(cm.tdtg1)
			e5:SetCondition(cm.negcon5)
			tc:RegisterEffect(e5,true)
			local e6=e2:Clone()
			e6:SetType(EFFECT_TYPE_QUICK_O)
			e6:SetCode(EVENT_FREE_CHAIN)
			e6:SetHintTiming(0,TIMING_END_PHASE)
			e6:SetCost(cm.tdcost1)
			e6:SetCondition(cm.negcon6)
			tc:RegisterEffect(e6,true)
			local e7=e2:Clone()
			e7:SetType(EFFECT_TYPE_QUICK_O)
			e7:SetCode(EVENT_FREE_CHAIN)
			e7:SetHintTiming(0,TIMING_END_PHASE)
			e7:SetTarget(cm.tdtg1)
			e7:SetCondition(cm.negcon7)
			tc:RegisterEffect(e7,true)
			local e8=e2:Clone()
			e8:SetCost(cm.tdcost1)
			e8:SetTarget(cm.tdtg1)
			e8:SetCondition(cm.negcon8)
			tc:RegisterEffect(e8,true)
			local e9=e2:Clone()
			e9:SetType(EFFECT_TYPE_QUICK_O)
			e9:SetCode(EVENT_FREE_CHAIN)
			e9:SetHintTiming(0,TIMING_END_PHASE)
			e9:SetTarget(cm.tdtg1)
			e9:SetCost(cm.tdcost1)
			e9:SetCondition(cm.negcon9)
			tc:RegisterEffect(e9,true)


	end
end
function cm.negcon10(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)==0 and Duel.GetFlagEffect(tp,99910020)==0 and Duel.GetFlagEffect(tp,99910040)==0
end
function cm.negcon9(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)~=0 and Duel.GetFlagEffect(tp,99910020)~=0 and Duel.GetFlagEffect(tp,99910040)~=0
end
function cm.negcon8(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)==0 and Duel.GetFlagEffect(tp,99910020)~=0 and Duel.GetFlagEffect(tp,99910040)~=0
end
function cm.negcon7(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)~=0 and Duel.GetFlagEffect(tp,99910020)==0 and Duel.GetFlagEffect(tp,99910040)~=0
end
function cm.negcon6(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)~=0 and Duel.GetFlagEffect(tp,99910020)~=0 and Duel.GetFlagEffect(tp,99910040)==0
end
function cm.negcon5(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)==0 and Duel.GetFlagEffect(tp,99910020)==0 and Duel.GetFlagEffect(tp,99910040)~=0
end
function cm.negcon4(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)==0 and Duel.GetFlagEffect(tp,99910020)~=0 and Duel.GetFlagEffect(tp,99910040)==0
end
function cm.negcon3(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910010)~=0 and Duel.GetFlagEffect(tp,99910020)==0 and Duel.GetFlagEffect(tp,99910040)==0
end
function cm.tdcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end


function cm.negcon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99910030)~=0
end
function cm.rscon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFlagEffect(tp,99910030)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x679,TYPES_EFFECT_TRAP_MONSTER,0,0,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,m,0x679,TYPES_EFFECT_TRAP_MONSTER,0,0,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_SPELL)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end