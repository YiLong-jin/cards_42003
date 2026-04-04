--未来的善良主唱
function c9875650.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--pos and set
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetTarget(c9875650.pstg) 
	e2:SetOperation(c9875650.psop) 
	c:RegisterEffect(e2) 
end
function c9875650.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) 
end
function c9875650.pstg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanChangePosition() end 
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end 
function c9875650.psop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9875650.filter1,tp,LOCATION_MZONE,0,nil)
	local g1=Duel.GetMatchingGroupCount(c9875650.filter1,tp,LOCATION_MZONE,0,nil)*200
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE)~=0 then
	local tc=g:GetFirst()
	while tc do
	local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetDescription(aux.Stringid(9875650,1))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetValue(g1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end 
end