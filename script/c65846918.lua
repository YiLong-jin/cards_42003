function c65846918.initial_effect(c)
	aux.AddCodeList(c,65846916)
	--synchro summon
	aux.AddSynchroProcedure(c,c65846918.tfilter,aux.NonTuner(Card.IsRace,RACE_ZOMBIE),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846918,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65846918)
	--e1:SetCondition(c65846918.thcon)
	e1:SetTarget(c65846918.thtg)
	e1:SetOperation(c65846918.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65846918.tgcon)
	e2:SetTarget(c65846918.tgtg)
	e2:SetOperation(c65846918.tgop)
	c:RegisterEffect(e2)
end
---------------------------------------[[回收]]
function c65846918.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(65846916)
end
function c65846918.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65846918.cfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c65846918.tfilter(c)
	return c:IsRace(0x10) and c:IsType(TYPE_SYNCHRO)
end
function c65846918.thfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,65846916) and c:IsAbleToHand()
end
function c65846918.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c65846918.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846918.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c65846918.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c65846918.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
---------------------------------------[[阻抗]]
function c65846918.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end
function c65846918.tgfilter(c)
	return aux.IsCodeListed(c,65846916) and c:IsAbleToGrave()
end
function c65846918.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846918.tgfilter,rp,0,LOCATION_HAND+LOCATION_DECK,1,e:GetHandler()) and Duel.GetFlagEffect(tp,65846918)==0 end
	Duel.RegisterFlagEffect(tp,65846918,RESET_PHASE+PHASE_END,0,1)
end
function c65846918.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65846918.repop)
end
function c65846918.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,c65846918.tgfilter,tp,0,LOCATION_HAND+LOCATION_DECK,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
