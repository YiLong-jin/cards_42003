--恐虐暴行·毁
function c21400041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,21400041+EFFECT_COUNT_CODE_OATH) 
	e1:SetCondition(c21400041.condition)
	e1:SetTarget(c21400041.target)
	e1:SetOperation(c21400041.activate)
	c:RegisterEffect(e1)
end
function c21400041.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6210) and c:IsRank(8)
end
function c21400041.condition(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c21400041.cfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function c21400041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c21400041.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end 
function c21400041.zsop(e,tp,eg,ep,ev,re,r,rp) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c)
	return not c:IsSetCard(0x6210) end) 
	if Duel.GetTurnPlayer()==tp then 
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)  
	else 
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	end 
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE) 
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsSetCard(0x6210) end) 
	if Duel.GetTurnPlayer()==tp then 
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)  
	else 
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN) 
	end 
	Duel.RegisterEffect(e1,tp)
end








