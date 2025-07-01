--逆辉龙刃－乌兹钢
function c10700840.initial_effect(c)
	aux.EnableDualAttribute(c)   
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700840,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10700840.sumcon)
	e1:SetCost(c10700840.pccost)
	e1:SetTarget(c10700840.sumtg)
	e1:SetOperation(c10700840.sumop)
	c:RegisterEffect(e1)  
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700840,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c10700840.rmtg)
	e2:SetOperation(c10700840.rmop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(aux.IsDualState)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.IsDualState)
	e4:SetCondition(c10700840.rmcon)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(aux.IsDualState)
	e5:SetCondition(c10700840.rmcon)
	c:RegisterEffect(e5)   
end
function c10700840.dfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c10700840.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700840.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10700840.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c10700840.sumfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsLevel(4) and c:IsSummonable(true,nil)
end
function c10700840.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700840.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c10700840.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c10700840.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end 
function c10700840.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsLevel(4) and c:IsControler(tp)
end
function c10700840.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsDisabled() and e:GetHandler():IsDualState() and not eg:IsContains(e:GetHandler()) and eg:IsExists(c10700840.cfilter,1,nil,tp)
end
function c10700840.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c10700840.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end