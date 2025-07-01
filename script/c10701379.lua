--威风妖怪飓风
function c10701379.initial_effect(c)
	--Activate MoveToPzone
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCountLimit(1,10701379+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701379.target)
	e1:SetOperation(c10701379.activate)
	e1:SetValue(c10701379.zones)
	c:RegisterEffect(e1)  
	--speical summon 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701379,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetCountLimit(1,10701380)
	e3:SetCondition(c10701379.spcon)
	e3:SetTarget(c10701379.sptg)
	e3:SetOperation(c10701379.spop)
	c:RegisterEffect(e3)
end
function c10701379.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	if not b or p0 and p1 then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c10701379.penfilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
		and not c:IsForbidden()
end
function c10701379.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c10701379.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,2,nil) end
end
function c10701379.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c10701379.penfilter,tp,LOCATION_DECK,0,1,2,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		tc=g:GetNext()
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10701379.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c10701379.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND)) and sumtype&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM 
end
function c10701379.spcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE) and c:IsPreviousControler(tp)
end
function c10701379.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701379.spcfilter,1,nil,tp)
end
function c10701379.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsFaceup())
end
function c10701379.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701379.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c10701379.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701379.spfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end