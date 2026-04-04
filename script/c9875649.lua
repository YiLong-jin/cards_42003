--未来的笨蛋贝斯手
function c9875649.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9875649.drcon)
	e2:SetTarget(c9875649.sumtg) 
	e2:SetOperation(c9875649.sumop) 
	c:RegisterEffect(e2) 
end
function c9875649.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_SPIRIT)
end
function c9875649.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9875649.cfilter,1,nil,tp)
end
function c9875649.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSummonable(true,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0) 
end 
function c9875649.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.Summon(tp,c,true,nil)  
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 