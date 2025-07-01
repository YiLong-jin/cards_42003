--逆辉龙刃－陨铁
function c10700838.initial_effect(c)
	aux.EnableDualAttribute(c)   
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700838,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10700838.sumcon)
	e1:SetCost(c10700838.pccost)
	e1:SetTarget(c10700838.sumtg)
	e1:SetOperation(c10700838.sumop)
	c:RegisterEffect(e1)  
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c10700838.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()  
	e3:SetCondition(aux.IsDualState)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(aux.IsDualState)
	e4:SetTarget(c10700838.atktg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c10700838.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c10700838.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700838.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10700838.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451461,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c10700838.sumfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(4) and c:IsSummonable(true,nil)
end
function c10700838.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700838.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10700838.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700838.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end 
function c10700838.atktg(e,c)
	return c:IsRace(RACE_DRAGON)
end