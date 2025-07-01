--秘源异术 劫炎烧却
function c71100312.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)   
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetTarget(c71100312.actg)
	e1:SetOperation(c71100312.acop) 
	c:RegisterEffect(e1)
end 
function c71100312.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c71100312.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c71100312.dacon)
	e1:SetOperation(c71100312.daop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 
function c71100312.ckfil(c) 
	return c:IsSetCard(0x7de) and c:IsFaceup()   
end 
function c71100312.dacon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c71100312.ckfil,tp,LOCATION_ONFIELD,0,2,nil) and rp==1-tp and re:IsActiveType(TYPE_MONSTER) and (re:GetActivateLocation()==LOCATION_HAND or re:GetActivateLocation()==LOCATION_GRAVE)  
end 
function c71100312.daop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,71100312)
	local tc=eg:GetFirst() 
	local atk=tc:GetAttack() 
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end 












