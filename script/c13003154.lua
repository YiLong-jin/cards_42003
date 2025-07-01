--赛马娘理事长 秋川弥生
function c13003154.initial_effect(c)
	 --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_BEASTWARRIOR),2,2)
	c:EnableReviveLimit()
	--special summon
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13003154,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,13003154)
	e1:SetTarget(c13003154.sptg)
	e1:SetOperation(c13003154.spop)
	c:RegisterEffect(e1)
	 --cannot attack
--  local e2=Effect.CreateEffect(c)
--  e2:SetType(EFFECT_TYPE_FIELD)
--  e2:SetCode(EFFECT_CANNOT_TRIGGER)
--  e2:SetRange(LOCATION_MZONE)
--  e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
--  e2:SetTarget(c13003154.actlimit)
--   c:RegisterEffect(e2)
end
function c13003154.actlimit(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end



function c13003154.spfilter(c,e,tp,zone)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x417)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c13003154.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c13003154.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c13003154.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13003154.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13003154.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13003154.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13003154.splimit(e,c)
	return not (c:IsRace(RACE_BEASTWARRIOR) or c:IsType(TYPE_SYNCHRO)) and c:IsLocation(LOCATION_EXTRA)
end
