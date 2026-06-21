--Idols in Life
function c65848036.initial_effect(c)
	aux.AddFusionProcCodeFun(c,65847994,c65848036.ffilter2,1,true,true)
	c:EnableReviveLimit()	
	aux.AddCodeList(c,65847994)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c65848036.setcon)
	e1:SetTarget(c65848036.settg)
	e1:SetOperation(c65848036.setop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c65848036.chainop)
	c:RegisterEffect(e2)
end
function c65848036.ffilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_PSYCHO)
end
function c65848036.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65848036.filter(c)
	return aux.IsCodeListed(c,65847994) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsFaceupEx()
end
function c65848036.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65848036.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c65848036.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c65848036.filter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end
function c65848036.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(re:GetHandler(),65847994) and ep==tp then
		Duel.SetChainLimit(c65848036.chainlm)
	end
end
function c65848036.chainlm(re,rp,tp)
	return tp==rp or not re:IsActiveType(TYPE_MONSTER)
end