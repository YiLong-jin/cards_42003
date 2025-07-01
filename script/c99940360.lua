--荫蔽的情怀
function c99940360.initial_effect(c)
	c:EnableReviveLimit()

	aux.AddLinkProcedure(c,nil,2,4,c99940360.lcheck)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
	e1:SetValue(aux.tgoval)
	--c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99940360,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,99940360)
	e2:SetCondition(c99940360.spcon)
	e2:SetCost(c99940360.cost)
	e2:SetTarget(c99940360.target)
	e2:SetOperation(c99940360.activate)
	c:RegisterEffect(e2)
end
function c99940360.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM) or g:IsExists(Card.IsAttack,1,nil,1550)
end
function c99940360.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c99940360.scfilters(c)
	return c:IsLinkMarker(LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP+LINK_MARKER_TOP_RIGHT+LINK_MARKER_RIGHT+LINK_MARKER_BOTTOM_RIGHT+LINK_MARKER_BOTTOM+LINK_MARKER_BOTTOM_LEFT+LINK_MARKER_LEFT) and c:IsFaceup()
end
function c99940360.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c99940360.scfilters,tp,LOCATION_ONFIELD,0,nil,nil)
	if chk==0 then return #g>0 end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if not tc then return false end
	local lm=0
	if tc:IsLinkMarker(LINK_MARKER_TOP_LEFT) then lm=lm+0x040 end
	if tc:IsLinkMarker(LINK_MARKER_TOP) then lm=lm+0x080 end
	if tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then lm=lm+0x100 end
	if tc:IsLinkMarker(LINK_MARKER_RIGHT) then lm=lm+0x020 end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then lm=lm+0x004 end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM) then lm=lm+0x002 end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then lm=lm+0x001 end
	if tc:IsLinkMarker(LINK_MARKER_LEFT) then lm=lm+0x008 end
	if lm==0 then return false end
	local off=1
	local ops={}
	local opval={}
	if tc:IsLinkMarker(LINK_MARKER_TOP_LEFT) then
		ops[off]=aux.Stringid(99940310,1)
		opval[off-1]=1
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_TOP) then
		ops[off]=aux.Stringid(99940310,2)
		opval[off-1]=2
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then
		ops[off]=aux.Stringid(99940310,3)
		opval[off-1]=3
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_RIGHT) then
		ops[off]=aux.Stringid(99940310,4)
		opval[off-1]=4
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then
		ops[off]=aux.Stringid(99940310,5)
		opval[off-1]=5
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM) then
		ops[off]=aux.Stringid(99940310,6)
		opval[off-1]=6
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then
		ops[off]=aux.Stringid(99940310,7)
		opval[off-1]=7
		off=off+1
	end
	if tc:IsLinkMarker(LINK_MARKER_LEFT) then
		ops[off]=aux.Stringid(99940310,8)
		opval[off-1]=8
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		lm=lm-0x040
	elseif sel==2 then
		lm=lm-0x080
	elseif sel==3 then
		lm=lm-0x100
	elseif sel==4 then
		lm=lm-0x020
	elseif sel==5 then
		lm=lm-0x004
	elseif sel==6 then
		lm=lm-0x002
	elseif sel==7 then
		lm=lm-0x001
	elseif sel==8 then
		lm=lm-0x008
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_LINK_MARKER_KOISHI)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(lm)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_SZONE)
	tc:RegisterEffect(e2)
end
function c99940360.spfilter(c,e,tp)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c99940360.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99940360.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c99940360.tgfilter(c,lv,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_AQUA) and not c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99940360.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99940360.spfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local lv=tc:GetLevel()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tg=Duel.GetMatchingGroup(c99940360.tgfilter,tp,LOCATION_GRAVE,0,nil,lv,e,tp)
	if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(99940360,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=tg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
