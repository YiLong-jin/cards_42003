--笨蛋贝斯手
function c9875645.initial_effect(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--summon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_HAND)   
	e2:SetCountLimit(1,9875645) 
	e2:SetCondition(c9875645.sumcon)
	e2:SetTarget(c9875645.sumtg) 
	e2:SetOperation(c9875645.sumop) 
	c:RegisterEffect(e2) 
end
function c9875645.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp  
end 
function c9875645.rettfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevel(4) and not (c:IsRace(RACE_ROCK) or c:IsRace(RACE_FIEND)) and c:IsSummonable(true,nil)
end
function c9875645.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9875645.rettfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0) 
end 
function c9875645.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9875645.rettfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 