--墟界天使紊乱
function c30553214.initial_effect(c)
	 --sfanka
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	   
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,30553214+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c30553214.tg)
	e1:SetOperation(c30553214.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c30553214.tdtg)
	e2:SetOperation(c30553214.tdop)
	c:RegisterEffect(e2)
end
function c30553214.tdfil(c)
	return c:IsSetCard(0x302) and c:IsAbleToDeck() and c:IsFaceup()
end
function c30553214.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c30553214.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g1=Duel.SelectTarget(tp,c30553214.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	g1:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
end
function c30553214.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc1=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
		local tc2=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		Duel.SendtoDeck(tc1,nil,0,REASON_EFFECT)
		Duel.SendtoDeck(tc2,nil,0,REASON_EFFECT)
	end
end
function c30553214.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetDecktopGroup(tp,3):GetCount()==3 end
end
function c30553214.thfil(c)
	return c:IsSetCard(0x302) and c:IsAbleToHand()
end
function c30553214.tdfilter(c)
	return c:IsSetCard(0x302)
end
function c30553214.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	local gc=g:GetFirst()
	local num=0
	while gc do
		if gc:IsSetCard(0x302) then num=num+1 end
		gc=g:GetNext()
	end
	if num>0 and Duel.SelectYesNo(tp,aux.Stringid(30553214,0)) then
		local tg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,num,e:GetHandler())
		Duel.HintSelection(tg)
		local tc=tg:GetFirst()
		while tc do
			 Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
		end
	end
	Duel.BreakEffect()
	Duel.SortDecktop(tp,tp,3)
end