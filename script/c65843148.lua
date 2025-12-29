--托举星辰
function c65843148.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65843148,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCondition(c65843148.condition)
	e1:SetCost(c65843148.cost)
	e1:SetTarget(c65843148.target)
	e1:SetOperation(c65843148.activate)
	c:RegisterEffect(e1)	
	Duel.AddCustomActivityCounter(65843148,ACTIVITY_SPSUMMON,c65843148.counterfilter)
end
function c65843148.counterfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA) or c:IsSetCard(0x43ef)
end
function c65843148.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65843148,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65843148.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c65843148.splimit(e,c)
	return not c:IsSetCard(0x43ef) and not c:IsLocation(LOCATION_EXTRA)
end
function c65843148.thfilter(c,oc)
	return c:IsSetCard(0x43ef) and c:IsAbleToHand() and c:IsFaceup()
end
function c65843148.spfilter(c,e,tp)
	return  c:IsSetCard(0x43ef) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c65843148.penfilter(c)
	return c:IsSetCard(0x43ef) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c65843148.zones(e,tp,eg,ep,ev,re,r,rp)
	local zone=0xff
	local p0=Duel.CheckLocation(tp,LOCATION_PZONE,0)
	local p1=Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local b=e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE)
	if not b or p0 and p1 then return zone end
	if p0 then zone=zone-0x1 end
	if p1 then zone=zone-0x10 end
	return zone
end
function c65843148.condition(e,tp,eg,ep,ev,re,r,rp)
	local lc=1
	if e:GetHandler():IsLocation(LOCATION_SZONE) then lc=0 end
	local b1=Duel.GetFlagEffect(tp,65843148+1000000)==0 and Duel.IsExistingMatchingCard(c65843148.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.GetFlagEffect(tp,65843148+1000010)==0 and Duel.IsExistingMatchingCard(c65843148.thfilter,tp,LOCATION_EXTRA,0,2,nil)
	local b3=Duel.GetFlagEffect(tp,65843148+1000020)==0 and Duel.IsExistingMatchingCard(c65843148.penfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>lc
	if b1 or b2 then	
		e:SetValue(0xff)
	else
		e:SetValue(c65843148.zones)
	end
	return b1 or b2 or b3
end
function c65843148.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lc=1
	if e:GetHandler():IsLocation(LOCATION_SZONE) then lc=0 end
	local b1=Duel.GetFlagEffect(tp,65843148+1000000)==0 and Duel.IsExistingMatchingCard(c65843148.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.GetFlagEffect(tp,65843148+1000010)==0 and Duel.IsExistingMatchingCard(c65843148.thfilter,tp,LOCATION_EXTRA,0,2,nil)
	local b3=Duel.GetFlagEffect(tp,65843148+1000020)==0 and Duel.IsExistingMatchingCard(c65843148.penfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.GetLocationCount(tp,LOCATION_SZONE)>lc
	if chk==0 then return  b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(65843148,1),1},
		{b2,aux.Stringid(65843148,2),2},
		{b3,aux.Stringid(65843148,3),3}
	)
	e:SetLabel(op)
	local ref=0
	if op==1 then ref=1000000 elseif op==2 then ref=1000010 else ref=1000020 end
	Duel.RegisterFlagEffect(tp,65843148+ref,RESET_PHASE+PHASE_END,0,1)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
	end
end
function c65843148.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==3 then
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,c65843148.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c65843148.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65843148.thfilter,tp,LOCATION_EXTRA,0,2,2,nil)
		if #g then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end