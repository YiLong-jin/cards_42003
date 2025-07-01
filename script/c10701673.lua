--阴云轰鸣
function c10701673.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701673,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,10701673)
	e4:SetTarget(c10701673.thtg)
	e4:SetOperation(c10701673.thop)
	c:RegisterEffect(e4)
	--ep set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701673,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,10701674)
	e5:SetCondition(c10701673.setcon)
	e5:SetOperation(c10701673.setop)
	c:RegisterEffect(e5)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_LIGHT)
	e2:SetCondition(c10701673.actcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e3:SetCondition(c10701673.gravecon)
	c:RegisterEffect(e3) 
	if c10701673.glo then return end
	c10701673.glo=1
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_MOVE)
	ge1:SetOperation(c10701673.gop1)
	Duel.RegisterEffect(ge1,0)
end
--e2
function c10701673.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1,10701673)>0
end
--e3
function c10701673.gravecon(e)
	if Duel.GetFlagEffect(1,10701673)==0 then return false end
	return not Duel.IsPlayerAffectedByEffect(0,EFFECT_NECRO_VALLEY) and not Duel.IsPlayerAffectedByEffect(1,EFFECT_NECRO_VALLEY)
end
--ge
function c10701673.gop1(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		if c:IsReason(REASON_COST) and c:IsPreviousLocation(LOCATION_OVERLAY)
			and re:IsActivated()
			and re:GetHandler():IsRace(RACE_THUNDER) then
			Duel.RegisterFlagEffect(tp,10701673,RESET_PHASE+PHASE_END,0,1)
			Duel.RegisterFlagEffect(1-tp,10701673,RESET_PHASE+PHASE_END,0,1)
		end
		if not c:IsReason(REASON_RULE) and c:IsPreviousLocation(LOCATION_OVERLAY) then
		   Duel.RegisterFlagEffect(tp,10701673+100,RESET_PHASE+PHASE_END,0,1)
		   Duel.RegisterFlagEffect(1-tp,10701673+100,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c10701673.thfilter(c)
	return c:IsSetCard(0x7c1) and c:IsAbleToHand()
end
function c10701673.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701673.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c10701673.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701673.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ShuffleHand(tp)
		Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
	end
end
function c10701673.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1,10701673+100)>=5
end
function c10701673.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then
	  local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	  if fc then
		  Duel.SendtoGrave(fc,REASON_RULE)
		  Duel.BreakEffect()
	  end
	  Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end