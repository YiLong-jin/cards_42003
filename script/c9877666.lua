--苍穹一击
function c9877666.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877666,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9877666+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9877666.condition)
	e1:SetTarget(c9877666.target)
	e1:SetOperation(c9877666.activate)
	c:RegisterEffect(e1)


	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877666,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c9877666.cost1)
	e3:SetTarget(c9877666.destg)
	e3:SetOperation(c9877666.desop)
	c:RegisterEffect(e3)
end
function c9877666.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-3000
end
function c9877666.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,re:GetHandler():GetBaseAttack()+1000)
	end
end
function c9877666.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.Destroy(eg,REASON_EFFECT)~=0 then
			Duel.BreakEffect() 
			Duel.Recover(tp,re:GetHandler():GetBaseAttack()+1000,REASON_EFFECT)
		end
	end
end



function c9877666.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c9877666.thfil(c,tp) 
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0x17ec)
end 
function c9877666.tgfil1(c) 
	return c:IsAbleToHand() and c:IsSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end 
function c9877666.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingTarget(c9877666.thfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9877666.thfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9877666.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		  local g2=Duel.GetMatchingGroup(c9877666.tgfil1,tp,LOCATION_DECK,0,nil)
			if g2:GetCount()>0 and Duel.CheckLPCost(tp,2500) and Duel.SelectYesNo(tp,aux.Stringid(9877666,0)) then
				Duel.PayLPCost(tp,2500)
				local sg=g2:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			 end
		end
	end
end