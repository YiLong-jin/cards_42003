--恋星
function c65840006.initial_effect(c)
	aux.AddCodeList(c,65840021)
	aux.AddSynchroProcedure(c,nil,aux.Tuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65840006,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65840006)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c65840006.settg)
	e1:SetOperation(c65840006.setop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c65840006.lvcon)
	e2:SetTarget(c65840006.lvtg)
	e2:SetOperation(c65840006.lvop)
	c:RegisterEffect(e2)
end
function c65840006.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c65840006.filter(c)
	return aux.IsCodeListed(c,65840021) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c65840006.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65840006.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c65840006.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65840006.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end
function c65840006.lvfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsLevelAbove(1)
end
function c65840006.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65840006.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65840006.lvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFlagEffect(tp,65840006)==0 end
	Duel.RegisterFlagEffect(tp,65840006,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c65840006.lvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local lv=g:GetFirst():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65840006,2))
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))
end
function c65840006.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
