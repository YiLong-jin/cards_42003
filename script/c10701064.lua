--炽天武装 圣灵安琪儿
function c10701064.initial_effect(c)
	c:SetSPSummonOnce(10701064)
	aux.AddCodeList(c,56433456)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701064,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10701064.thcon)
	e1:SetTarget(c10701064.thtg)
	e1:SetOperation(c10701064.thop)
	c:RegisterEffect(e1) 
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701064,4))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10701064.sccon)
	e3:SetTarget(c10701064.sctg)
	e3:SetOperation(c10701064.scop)
	c:RegisterEffect(e3)   
end
function c10701064.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c10701064.thfilter(c)
	return (c:IsCode(56433456) or aux.IsCodeListed(c,56433456)) and c:IsAbleToHand()
end
function c10701064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701064.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local lv=e:GetHandler():GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10701064,2))
	e:SetLabel(Duel.AnnounceLevel(tp,1,8,lv))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701064.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701064.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if c:IsFaceup() and c:IsRelateToEffect(e)
		  and Duel.SelectYesNo(tp,aux.Stringid(10701064,3)) then
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_CHANGE_LEVEL)
		 e1:SetValue(e:GetLabel())
		 e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		 c:RegisterEffect(e1)
		end
	end
end
function c10701064.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c10701064.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
		local schk=false 
		local exg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_SYNCHRO)
		for tc in aux.Next(exg) do 
			schk=schk or tc:IsSynchroSummonable(e:GetHandler(),g1)
			if schk then break end 
		end
		return schk
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10701064.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,g1)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,g1)
	end
end