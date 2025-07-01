--狩魂×收割
function c69969409.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,69969409)
	e1:SetTarget(c69969409.target)
	e1:SetOperation(c69969409.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969409,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,69969409)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c69969409.spcon)
	e2:SetTarget(c69969409.sptg)
	e2:SetOperation(c69969409.spop)
	c:RegisterEffect(e2)
end
--1
function c69969409.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x69d)
		and Duel.IsExistingMatchingCard(c69969409.desfilter,tp,0,LOCATION_MZONE,1,nil,math.max(0,c:GetAttack()))
end
function c69969409.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsCanOverlay()
end
function c69969409.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c69969409.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969409.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c69969409.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(c69969409.desfilter,tp,0,LOCATION_MZONE,nil,math.max(0,g1:GetFirst():GetAttack()))
end
function c69969409.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local g=Duel.GetMatchingGroup(c69969409.desfilter,tp,0,LOCATION_MZONE,nil,atk)
		if #g>0 and tc:IsLocation(LOCATION_MZONE) then
		for mc in aux.Next(g) do
				local og=mc:GetOverlayGroup()
					if #og~=0 and not mc:IsImmuneToEffect(e) then
						Duel.SendtoGrave(og,REASON_RULE)
						Duel.Overlay(tc,mc)
						end
					if not mc:IsImmuneToEffect(e) then
						Duel.Overlay(tc,mc)
			end
		end
	end
end
end



--2
function c69969409.spnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x69d) and c:IsType(TYPE_MONSTER)
end
function c69969409.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetMatchingGroupCount(c69969409.spnfilter,tp,LOCATION_MZONE,0,nil)
	local chk1=ct1==0
	local chk2=ct2>0 and ct1-ct2==0
	return chk1 or chk2
end
function c69969409.spfilter(c,e,tp)
	return c:IsSetCard(0x69d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsType(TYPE_MONSTER) and c:IsLevel(4)
end
function c69969409.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c69969409.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c69969409.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c69969409.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c69969409.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end