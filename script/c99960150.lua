--不可思议之事
local s,id,o=GetID()
Duel.LoadScript("c99960010.lua")
function s.initial_effect(c)
	aux.EnableChangeCode(c,99960090,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99960150,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99960150)
	e1:SetCost(shenqi_Savior.cost3)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
		
		
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,99960151)
	e2:SetOperation(s.addop)
	c:RegisterEffect(e2)
end

s.Savior_shenqi=true



function s.addop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,1-tp,99960150)
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
	Duel.RegisterFlagEffect(tp,99960020,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(24,0,aux.Stringid(99960010,6))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
