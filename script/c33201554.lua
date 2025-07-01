--ESP的记忆碎片
local s,id,o=GetID()
Duel.LoadScript("c33201550.lua")
function s.initial_effect(c)
	VHisc_ESP.SpProc(c,id)
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(0x4+0x200)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+10000)
	e1:SetLabel(id)
	e1:SetCost(VHisc_ESP.rmcost)
	e1:SetTarget(VHisc_ESP.rmtg)
	e1:SetOperation(VHisc_ESP.rmop)
	ec:RegisterEffect(e1)
end

--e2
function s.filter(c,e,tp)
	return c:IsSetCard(0x3327) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.op(c,e,tp,ct)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,c,e,tp)
		if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end