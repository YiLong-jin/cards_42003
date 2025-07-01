--阴云放电
function c10701693.initial_effect(c)
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701693,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetTarget(c10701693.target)
	e1:SetOperation(c10701693.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701693,2))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c10701693.actcon)
	c:RegisterEffect(e2)  
	--ep set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701673,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,10701693)
	e5:SetCondition(c10701693.setcon)
	e5:SetTarget(c10701693.settg)
	e5:SetOperation(c10701693.setop)
	c:RegisterEffect(e5)
	if c10701693.glo then return end
	c10701693.glo=1
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_MOVE)
	ge1:SetOperation(c10701693.gop1)
	Duel.RegisterEffect(ge1,0)  
end
--ge
function c10701693.gop1(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		if not c:IsReason(REASON_RULE) and c:IsPreviousLocation(LOCATION_OVERLAY) then
		   Duel.RegisterFlagEffect(tp,10701693,RESET_PHASE+PHASE_END,0,1)
		   Duel.RegisterFlagEffect(1-tp,10701693,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c10701693.filter(c)
	return c:IsFaceup() and (c:IsCanTurnSet() or c:IsSSetable()) and not c:IsLocation(LOCATION_PZONE)
end
function c10701693.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c10701693.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701693.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c10701693.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c10701693.rmfilter(c)
	return c:IsFacedown()
end
function c10701693.checkfilter(c)
	return c:IsSetCard(0x7c1) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c10701693.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local check=Duel.IsExistingMatchingCard(c10701693.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:IsType(TYPE_MONSTER) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		elseif tc:IsType(TYPE_PENDULUM) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else 
		Duel.ChangePosition(tc,POS_FACEDOWN)
		end
		if check then
		 Duel.BreakEffect()
		 local g=Duel.GetMatchingGroup(c10701693.rmfilter,tp,0,LOCATION_ONFIELD,nil)
		 Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c10701693.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1,10701693)>=5
end
function c10701693.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c10701693.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	  Duel.SSet(tp,c)
	end
end
function c10701693.actfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7c1)
end
function c10701693.actcon(e)
	return Duel.IsExistingMatchingCard(c10701693.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end