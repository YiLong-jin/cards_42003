--生死相随炽不悔
function c10000109.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(c10000109.accon) 
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,10000109+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c10000109.accon)
	e2:SetTarget(c10000109.sptg)
	e2:SetOperation(c10000109.spop)
	c:RegisterEffect(e2) 
	--indes 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET) 
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE) 
	e3:SetTargetRange(LOCATION_MZONE,0)  
	e3:SetTarget(function(e,c) 
	return c:IsType(TYPE_SYNCHRO) end)
	e3:SetValue(aux.imval1) 
	e3:SetCondition(c10000109.accon)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_SZONE) 
	e4:SetTargetRange(LOCATION_MZONE,0)  
	e4:SetTarget(function(e,c) 
	return c:IsType(TYPE_SYNCHRO) end)
	e4:SetValue(1)  
	e4:SetCondition(c10000109.accon)
	c:RegisterEffect(e4)
end
function c10000109.accon(e) 
	return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xafe0) end,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)  
end  
function c10000109.spfil(c,e,tp)
	return c:IsSetCard(0xafe0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10000109.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10000109.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c10000109.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if c10000109.accon(e,tp,eg,ep,ev,re,r,rp)==false then return end 
	local tc=Duel.SelectMatchingCard(tp,c10000109.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end








