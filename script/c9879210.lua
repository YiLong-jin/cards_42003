--核心列车 动能冲击
c9879210.hxlc=true
function c9879210.initial_effect(c)
		
	 local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,9879210) 
	e3:SetCondition(c9879210.hspcon)  
	e3:SetTarget(c9879210.sptg) 
	e3:SetOperation(c9879210.spop) 
	c:RegisterEffect(e3) 


	local e11=Effect.CreateEffect(c) 
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e11:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e11:SetProperty(EFFECT_FLAG_DELAY) 
	e11:SetCountLimit(1,1879210) 
	e11:SetTarget(c9879210.sptg1) 
	e11:SetOperation(c9879210.spop1) 
	c:RegisterEffect(e11)
end
function c9879210.hspcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0  
end 
function c9879210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879210.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	 local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879210.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c9879210.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) and (c:IsRankAbove(10) or c:IsLevel(10)))
end

function c9879210.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(10)
end 
function c9879210.sptg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c9879210.spfil,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND) 
end 
function c9879210.spop1(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879210.spfil,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
	local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c9879210.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end