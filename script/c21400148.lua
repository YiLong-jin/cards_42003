--巴托尼亚-探险骑士
function c21400148.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21400148) 
	e1:SetTarget(c21400148.hsptg)
	e1:SetOperation(c21400148.hspop)
	c:RegisterEffect(e1)
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21400149)
	e2:SetCondition(c21400148.xxcon)
	e2:SetTarget(c21400148.xxtg)
	e2:SetOperation(c21400148.xxop)
	c:RegisterEffect(e2)
	--to hand  
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21400150) 
	e3:SetCondition(c21400148.thcon)
	e3:SetTarget(c21400148.thtg)
	e3:SetOperation(c21400148.thop)
	c:RegisterEffect(e3)
end 
function c21400148.pbfil(c,e,tp) 
	return not c:IsPublic() and c:IsSetCard(0x5211) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c21400148.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end 
function c21400148.spfil(c,e,tp,tc) 
	return c:IsSetCard(0x5211) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()~=tc:GetLevel()   
end 
function c21400148.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c21400148.pbfil,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end 
	local tc=Duel.SelectMatchingCard(tp,c21400148.pbfil,tp,LOCATION_HAND,0,1,1,e:GetHandler(),e,tp):GetFirst() 
	e:SetLabelObject(tc)
	Duel.ConfirmCards(1-tp,tc) 
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK) 
end
function c21400148.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsLocation(LOCATION_HAND) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c21400148.spfil,tp,LOCATION_DECK,0,1,nil,e,tp,tc) then 
		Duel.BreakEffect() 
		local sg=Duel.SelectMatchingCard(tp,c21400148.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c21400148.xxcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r&REASON_FUSION+REASON_MATERIAL==REASON_FUSION+REASON_MATERIAL and not c:IsReason(REASON_RETURN)
end 
function c21400148.plfil(c) 
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5211) and not c:IsForbidden()   
end 
function c21400148.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.IsExistingMatchingCard(c21400148.plfil,tp,LOCATION_DECK,0,1,nil) 
	local b2=e:GetHandler():IsAbleToHand() 
	if chk==0 then return b1 or b2 end 
	e:SetLabel(0)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(21400148,1)},{b2,aux.Stringid(21400148,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	end
	if op==2 then 
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c21400148.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local op=e:GetLabel() 
	if op==1 and Duel.IsExistingMatchingCard(c21400148.plfil,tp,LOCATION_DECK,0,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,c21400148.plfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end 
	if op==2 and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then 
		Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 
function c21400148.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_CONTINUOUS) and e:GetHandler():IsType(TYPE_TRAP) and Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) 
end 
function c21400148.thfilter(c)
	return c:IsSetCard(0x5211) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c21400148.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400148.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400148.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400148.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
