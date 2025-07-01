--汝之钉，吾之锤
function c10000149.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(c10000149.acop)
	c:RegisterEffect(e1)   
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(10000149,1)) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,10000149) 
	e1:SetCost(c10000149.spcost)
	e1:SetTarget(c10000149.sptg)
	e1:SetOperation(c10000149.spop)
	c:RegisterEffect(e1)	
	--immuse 
	local e2=Effect.CreateEffect(c)   
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_IMMUNE_EFFECT) 
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) 
	return c:IsSetCard(0xafe3) end)
	e2:SetValue(function(e,te) 
	return te:GetOwner():IsRace(RACE_MACHINE) end)
	c:RegisterEffect(e2)	  
	--race
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(10000149,2)) 
	e3:SetType(EFFECT_TYPE_IGNITION)   
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)  
	e3:SetTarget(c10000149.rctg)
	e3:SetOperation(c10000149.rcop)
	c:RegisterEffect(e3) 
end
function c10000149.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c10000149.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c10000149.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end
function c10000149.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsRace(RACE_WARRIOR) and c:IsAbleToDeckAsCost() end,tp,LOCATION_HAND+LOCATION_REMOVED,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,function(c) return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsRace(RACE_WARRIOR) and c:IsAbleToDeckAsCost() end,tp,LOCATION_HAND+LOCATION_REMOVED,0,2,2,nil) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end
function c10000149.spfilter(c,e,tp)
	return c:IsSetCard(0xafe3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10000149.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10000149.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c10000149.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10000149.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c10000149.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and not c:IsRace(RACE_MACHINE) end,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,function(c) return c:IsFaceup() and not c:IsRace(RACE_MACHINE) end,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10000149.rcop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CHANGE_RACE) 
		e1:SetValue(RACE_MACHINE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1) 
	end 
end 

