--一个“路过”的救世主
function c9879469.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9879469)
	e1:SetCost(c9879469.spcost)
	e1:SetTarget(c9879469.sptg)
	e1:SetOperation(c9879469.spop)
	c:RegisterEffect(e1)
	--esp 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,1879469) 
	e2:SetCondition(c9879469.espcon)
	e2:SetTarget(c9879469.esptg)
	e2:SetOperation(c9879469.espop)
	c:RegisterEffect(e2)
end
function c9879469.costfilter(c,tp)
	return c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c9879469.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879469.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9879469.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9879469.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879469.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end
function c9879469.espcon(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp and re:GetActivateLocation()&LOCATION_ONFIELD~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetHandler():IsFaceup() 
end 
function c9879469.ermfil(c)   
	return c:IsSetCard(0x1661) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() 
end 
function c9879469.espfil(c,e,tp) 
	return c:IsSetCard(0x1661) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0   
end 
function c9879469.esptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879469.ermfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(c9879469.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9879469.espop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(c9879469.ermfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) then 
		local sg=Duel.SelectMatchingCard(tp,c9879469.ermfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9879469.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then 
			local sc=Duel.SelectMatchingCard(tp,c9879469.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
			Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
			e1:SetCode(EVENT_CHAINING) 
			e1:SetOperation(c9879469.xrmop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			sc:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
		end 
	end 
end 
function c9879469.xrmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,9879469) 
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT) 
end 


