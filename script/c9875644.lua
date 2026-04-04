--贪吃鼓手
function c9875644.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 

	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c9875644.rectg)
	e2:SetOperation(c9875644.recop)
	c:RegisterEffect(e2)
end
function c9875644.atkfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) 
end 
function c9875644.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	if chk==0 then return true end
	local g=Duel.GetMatchingGroupCount(c9875644.atkfil,tp,LOCATION_MZONE,0,nil)*200
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g)
end
function c9875644.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Recover(p,d,REASON_EFFECT)
end