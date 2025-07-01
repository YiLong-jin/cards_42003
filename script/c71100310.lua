--秘源招来的灾祸
function c71100310.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,71100310+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c71100310.actg) 
	e1:SetOperation(c71100310.acop)  
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c71100310.handcon)
	c:RegisterEffect(e2)
end
function c71100310.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c71100310.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_TO_GRAVE) 
	e1:SetCondition(c71100310.thcon) 
	e1:SetOperation(c71100310.thop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_TO_HAND) 
	e1:SetCondition(c71100310.stcon) 
	e1:SetOperation(c71100310.stop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end 
function c71100310.ckfil(c,tp) 
	return c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_DECK)  
end 
function c71100310.thfil(c) 
	return c:IsSetCard(0x7de) and c:IsAbleToHand()
end 
function c71100310.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c71100310.ckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c71100310.thfil,tp,LOCATION_DECK,0,1,nil)
end 
function c71100310.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.SelectYesNo(tp,aux.Stringid(71100310,0)) then 
	Duel.Hint(HINT_CARD,0,71100310)
	local sg=Duel.SelectMatchingCard(tp,c71100310.thfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoHand(sg,tp,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	e:Reset()
	end 
end 
function c71100310.stfil(c) 
	return c:IsSetCard(0x7de) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end 
function c71100310.stcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c71100310.ckfil,1,nil,tp) and Duel.IsExistingMatchingCard(c71100310.stfil,tp,LOCATION_DECK,0,1,nil)
end 
function c71100310.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.SelectYesNo(tp,aux.Stringid(71100310,1)) then 
	Duel.Hint(HINT_CARD,0,71100310)
	local tc=Duel.SelectMatchingCard(tp,c71100310.stfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	e:Reset()
	end 
end 
function c71100310.handcon(e) 
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0 and g:GetSum(Card.GetLevel)>=10 
end








