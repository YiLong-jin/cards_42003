--亡灵海岸-诺克特拉斯伯爵
function c21400119.initial_effect(c)
	--change type
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21400119) 
	e1:SetCost(c21400119.cost)
	e1:SetTarget(c21400119.tg)
	e1:SetOperation(c21400119.op)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,11400119) 
	e2:SetCost(c21400119.setcost)
	e2:SetTarget(c21400119.settg)
	e2:SetOperation(c21400119.setop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,31400119)
	e2:SetCost(c21400119.cost)
	e2:SetCondition(c21400119.spcon)
	e2:SetTarget(c21400119.sptg)
	e2:SetOperation(c21400119.spop)
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(21400119,ACTIVITY_SPSUMMON,c21400119.counterfilter)
end
function c21400119.counterfilter(c)
	return not (c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)))
end
function c21400119.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21400119,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21400119.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c21400119.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xb210) and not c:IsType(TYPE_TUNER)
end
function c21400119.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c21400119.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21400119.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21400119.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c21400119.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21400119.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c21400119.cost(e,tp,eg,ep,ev,re,r,rp,0) and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	c21400119.cost(e,tp,eg,ep,ev,re,r,rp,1)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c21400119.setfilter(c)
	return c:IsSetCard(0xb210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c21400119.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400119.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c21400119.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c21400119.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c21400119.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end 
function c21400119.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c21400119.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)
	return c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)) end)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end 




