--CAN－St：D
function c65846708.initial_effect(c)
	aux.AddCodeList(c,65846670)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65846708.thtg)
	e1:SetOperation(c65846708.thop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,65846708+5157451)
	e2:SetTarget(c65846708.sptg2)
	e2:SetOperation(c65846708.spop2)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,65846708)
	e3:SetCondition(c65846708.pcon)
	e3:SetTarget(c65846708.ptg)
	e3:SetOperation(c65846708.pop)
	c:RegisterEffect(e3)
end
function c65846708.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(65846708)>0
end
function c65846708.pfilter(c,tp)
	return (c:IsLevelAbove(9) and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_FUSION) or c:IsCode(65846670)) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()==1-tp 
end
function c65846708.pcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65846708.pfilter,1,nil,tp) and e:GetHandler():IsFaceup() and not eg:IsContains(e:GetHandler())
end
function c65846708.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c65846708.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c65846708.thtrfah(c)
	return (c:IsCode(24094653) or c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_NORMAL)) and c:IsAbleToHand()
end
function c65846708.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c65846708.thtrfah,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,700)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c65846708.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846708.thtrfah),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if not g:GetFirst():IsLocation(LOCATION_HAND) then return end
		Duel.BreakEffect()
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Recover(p,d,REASON_EFFECT,true)>0 and c:IsRelateToEffect(e) then
			Duel.Destroy(c,REASON_EFFECT)
		end
		Duel.RDComplete()
	end
end
function c65846708.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65846708.spfilter(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function c65846708.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65846708.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846708.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	--Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c65846708.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65846708.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetFirstTarget()
	if lc:IsRelateToEffect(e) then
		Duel.SendtoHand(lc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,lc)
	end
end
		
