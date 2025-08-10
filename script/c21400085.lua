--纳垢礼乐奏师
function c21400085.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--to ex 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400085) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) end)
	e1:SetTarget(c21400085.tetg)
	e1:SetOperation(c21400085.teop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,11400085) 
	e2:SetCondition(c21400085.ctcon)
	e2:SetTarget(c21400085.cttg)
	e2:SetOperation(c21400085.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
				if chk==0 then return Duel.GetCustomActivityCount(21400084,tp,ACTIVITY_SPSUMMON)==0 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(function(e,tc) return not tc:IsSetCard(0x9210) end)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end)
	Duel.AddCustomActivityCounter(21400084,ACTIVITY_SPSUMMON,function(tc) return tc:IsSetCard(0x9210) end)
	e1:SetCountLimit(1,31400085)
	e1:SetCondition(c21400085.spcon)
	e1:SetTarget(c21400085.sptg)
	e1:SetOperation(c21400085.spop)
	c:RegisterEffect(e1)
end
function c21400085.tefilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c21400085.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400085.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c21400085.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c21400085.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
function c21400085.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and r==REASON_FUSION
end
function c21400085.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1077,1) end 
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1077,1) end 
	local g=Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,0x1077,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g:GetCount(),1,0,0x1077)
end
function c21400085.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1077,1)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		sc:AddCounter(0x1077,1) 
	end
end
function c21400085.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9210) 
end
function c21400085.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21400085.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c21400085.setfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c21400085.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c21400085.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400085.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c21400085.setfilter,tp,LOCATION_DECK,0,1,nil) then 
		Duel.BreakEffect()
		local tc=Duel.SelectMatchingCard(tp,c21400085.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
		Duel.SSet(tp,tc)
	end
end


