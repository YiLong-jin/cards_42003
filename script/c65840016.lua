--高塔的随心
function c65840016.initial_effect(c)
	aux.AddCodeList(c,65840021)
	aux.EnableChangeCode(c,65840021)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65840016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c65840016.spcon)
	e1:SetTarget(c65840016.sptg)
	e1:SetOperation(c65840016.spop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65840016,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65840016)
	e2:SetCondition(c65840016.condition)
	e2:SetTarget(c65840016.thtg)
	e2:SetOperation(c65840016.thop)
	c:RegisterEffect(e2)
	if not c65840016.global_check then
		c65840016.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c65840016.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c65840016.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c65840016.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c65840016.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c65840016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,65840080)==0 end
	Duel.RegisterFlagEffect(tp,65840080,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,0,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c65840016.spfilter2(c)
	return c:IsType(TYPE_TUNER) and c:IsSynchroSummonable(nil)
end
function c65840016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.AdjustAll()
		if Duel.IsExistingMatchingCard(c65840016.spfilter2,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(65840000,2)) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c65840016.spfilter2,tp,LOCATION_EXTRA,0,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SynchroSummon(tp,sg:GetFirst(),nil)
			end
		end
	end
end
function c65840016.checkfilter(c,tp)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsControler(tp)
end
function c65840016.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(c65840016.checkfilter,1,nil,p) then Duel.RegisterFlagEffect(p,65840016,RESET_PHASE+PHASE_END,0,1) end
	end
end
function c65840016.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65840016)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function c65840016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c65840016.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SendtoHand(c,nil,REASON_EFFECT) end
end
