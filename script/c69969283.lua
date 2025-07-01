--交响曲·培尔·金特
function c69969283.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),7,2)
	c:EnableReviveLimit()
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969283,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,69969283)
	e1:SetCondition(c69969283.spcon)
	e1:SetTarget(c69969283.target)
	e1:SetOperation(c69969283.operation)
	c:RegisterEffect(e1)
local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969283,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c69969283.spcon2)
	e3:SetTarget(c69969283.sptg)
	e3:SetOperation(c69969283.spop)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969283,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,69969283)
	e4:SetCondition(c69969283.condition)
	e4:SetTarget(c69969283.spetg)
	e4:SetOperation(c69969283.speop)
	c:RegisterEffect(e4)
end
function c69969283.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and c:GetOverlayCount()>0
end
function c69969283.filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsCanOverlay()
end
function c69969283.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c69969283.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c69969283.filter,tp,0,LOCATION_MZONE,1,nil) and eg:GetFirst()~=e:GetHandler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.SelectTarget(tp,c69969283.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c69969283.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		Duel.BreakEffect()
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end
--2
function c69969283.spnfilter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c69969283.spcon2(e,tp,eg,ep,ev,re,r,rp)
local g1=e:GetHandler():GetOverlayGroup():Filter(c69969283.spnfilter1,nil,e,tp)
	return #g1>=1
end
function c69969283.spfilter(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)) or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:IsType(TYPE_MONSTER))
end
function c69969283.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOwner()==tp and c:IsType(TYPE_MONSTER)
end
function c69969283.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:GetOwner()==1-tp and c:IsType(TYPE_MONSTER)
end
function c69969283.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	local g1=e:GetHandler():GetOverlayGroup():Filter(c69969283.spfilter1,nil,e,tp)
	local g2=e:GetHandler():GetOverlayGroup():Filter(c69969283.spfilter2,nil,e,tp)
	if chk==0 then return (ft1>=1 and #g1>=1) or (ft2>=1 and #g2>=1) end
	local g=e:GetHandler():GetOverlayGroup():Filter(c69969283.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c69969283.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	local rg=e:GetHandler():GetOverlayGroup()
	if (ft1<=0 and ft2<=0) or rg:GetCount()<=0 then return end
	local sg=nil
	local sg1=rg:Filter(c69969283.spfilter1,nil,e,tp)
	local sg2=rg:Filter(c69969283.spfilter2,nil,e,tp)
	local gc1=sg1:GetCount()
	local gc2=sg2:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if ft1<=0 and gc2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg2:Select(tp,1,1,nil)
		elseif ft2<=0 and gc1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg1:Select(tp,1,1,nil)
		elseif (gc1>0 and ft1>0) or (gc2>0 and ft2>0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=rg:FilterSelect(tp,c69969283.spfilter,1,1,nil,e,tp)
		end
		if sg~=nil then
			Duel.SpecialSummon(sg,0,tp,sg:GetFirst():GetOwner(),false,false,POS_FACEUP)
		end
		rg:Clear()
		return
	end
	if gc1>0 and ft1>0 then
		if sg1:GetCount()>ft1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg1=sg1:Select(tp,ft1,ft1,nil)
		end
		local sc=sg1:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			sc=sg1:GetNext()
		end
	end
	if gc2>0 and ft2>0 then
		if sg2:GetCount()>ft2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg2=sg2:Select(tp,ft2,ft2,nil)
		end
		local sc=sg2:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP)
			sc=sg2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
	rg:Clear()
end
--3
function c69969283.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<=1000
end
function c69969283.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969283.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end