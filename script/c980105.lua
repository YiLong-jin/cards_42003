--魔兽女帝 涅蕾雅
function c980105.initial_effect(c)  
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,980105)
	e1:SetCondition(c980105.spcon)
	e1:SetTarget(c980105.sptg)
	e1:SetOperation(c980105.spop)
	c:RegisterEffect(e1)   
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval) 
	e2:SetCondition(c980105.ctcon)
	c:RegisterEffect(e2)  
end 
function c980105.ckfil(c) 
	return c:IsFaceup() and c:IsCode(980106)  
end 
function c980105.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.IsExistingMatchingCard(c980105.ckfil,tp,LOCATION_MZONE,0,1,nil)
end
function c980105.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,980106,nil,TYPES_TOKEN_MONSTER,1500,2600,6,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0) 
end 
function c980105.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsPlayerCanSpecialSummonMonster(tp,980106,nil,TYPES_TOKEN_MONSTER,1500,2600,6,RACE_FIEND,ATTRIBUTE_DARK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local token=Duel.CreateToken(tp,980106) 
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET) 
	e1:SetValue(c980105.atlimit)
	token:RegisterEffect(e1) 
	--atk down
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE) 
	e1:SetTarget(c980105.atktg)
	e1:SetOperation(c980105.atkop)
	token:RegisterEffect(e1)
	end 
end 
function c980105.atlimit(e,c)
	return c~=e:GetHandler()
end
function c980105.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(980105)==0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	c:RegisterFlagEffect(980105,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1) 
end 
function c980105.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()<=0 then return end 
	local tc=g:GetFirst()  
	while tc do 
	if tc:IsType(TYPE_LINK) then 
	local pratk=tc:GetAttack() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	if pratk~=0 and tc:GetAttack()==0 then 
	Duel.Destroy(tc,REASON_EFFECT) 
	end 
	else  
	local prdef=tc:GetDefense() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_DEFENSE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	if prdef~=0 and tc:GetDefense()==0 then 
	Duel.Destroy(tc,REASON_EFFECT) 
	end 
	end  
	tc=g:GetNext() 
	end 
end 
function c980105.ctcon(e)  
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c980105.ckfil,tp,LOCATION_MZONE,0,1,nil) 
end 




