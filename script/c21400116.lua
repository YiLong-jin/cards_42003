--亡灵海岸-塞壬女妖
function c21400116.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400116)
	e1:SetCondition(c21400116.spcon)
	e1:SetCost(c21400116.cost)
	e1:SetTarget(c21400116.sptg)
	e1:SetOperation(c21400116.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400116)
	e2:SetCost(c21400116.cost)
	e2:SetTarget(c21400116.shptg)
	e2:SetOperation(c21400116.shpop)
	c:RegisterEffect(e2) 
	Duel.AddCustomActivityCounter(21400116,ACTIVITY_SPSUMMON,c21400116.counterfilter)
end
function c21400116.counterfilter(c)
	return not (c:IsSummonLocation(LOCATION_EXTRA) and not (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_WATER)))
end
function c21400116.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(21400116,tp,ACTIVITY_SPSUMMON)==0 end
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
function c21400116.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c21400116.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb210)
end
function c21400116.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21400116.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21400116.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c21400116.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
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
function c21400116.shpfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelBelow(4) and c:IsSetCard(0xb210)  
end 
function c21400116.shptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400116.shpfil,tp,LOCATION_DECK,0,1,nil,e,tp) and c:IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c21400116.shpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c21400116.shpfil,tp,LOCATION_DECK,0,1,nil,e,tp) then 
		local sg=Duel.SelectMatchingCard(tp,c21400116.shpfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then  
			Duel.SendtoHand(c,nil,REASON_EFFECT) 
		end 
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

