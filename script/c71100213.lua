--黑衣缠绕之兽
local m=71100213
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.ft,aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR),true)
	--Effect 1
	local e3=aux.AddRitualProcGreater2(c,aux.FilterBoolFunction(Card.IsRace,RACE_DINOSAUR),LOCATION_DECK+LOCATION_GRAVE,nil,nil)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.rscon)
	c:RegisterEffect(e3)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.tohtg)
	c:RegisterEffect(e1)
end
--fusion summon
function cm.ft(c)
	return aux.IsCodeListed(c,71100206)
end
--Effect 1
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
--Effect 2
function cm.cfilter(c)
	return (bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0
		and bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(c:GetPreviousRaceOnField(),RACE_DINOSAUR)~=0
		and bit.band(c:GetPreviousTypeOnField(),TYPE_RITUAL)~=0)
		or (not c:IsPreviousLocation(LOCATION_ONFIELD) 
		and bit.band(c:GetType(),TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER
		and c:IsRace(RACE_DINOSAUR))
end
function cm.sp(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
end
function cm.ex(c,e,tp)
	return c:IsCode(m+1) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function cm.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=eg:IsExists(cm.cfilter,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsExistingMatchingCard(cm.sp,tp,0,LOCATION_GRAVE,1,nil,e,tp)
	local b2=eg:IsExists(cm.cfilter,1,nil) and c:IsAbleToExtra() 
		and Duel.IsExistingMatchingCard(cm.ex,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and c:GetFlagEffect(m)==0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		e:SetOperation(cm.tohop)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
		e:SetOperation(cm.tohop3)
		Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,c,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		c:RegisterFlagEffect(m,RESET_CHAIN,0,1) 
	end
end
function cm.tohop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.sp),tp,0,LOCATION_GRAVE,nil,e,tp)
	if #g==0 or Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)==0 then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
function cm.tohop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.ex,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #g==0 then return end
	if c:IsRelateToEffect(e) and c:IsExtraDeckMonster() 
		and Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)~=0 
		and c:IsLocation(LOCATION_EXTRA) then
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end
