--驱动女神 碧雪
function c71100585.initial_effect(c)
	--to deck draw 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,71100585)
	e1:SetCondition(c71100585.tddcon1)
	e1:SetTarget(c71100585.tddtg)
	e1:SetOperation(c71100585.tddop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c71100585.tddcon2)
	c:RegisterEffect(e2) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,11100585)
	e2:SetCondition(c71100585.tdcon)
	e2:SetTarget(c71100585.tdtg)
	e2:SetOperation(c71100585.tdop)
	c:RegisterEffect(e2)
end
function c71100585.tddcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)==0 
end
function c71100585.tddcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_FZONE,LOCATION_FZONE)>0 
end
function c71100585.tddfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_QUICKPLAY)  
end 
function c71100585.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsExistingMatchingCard(c71100585.tddfil,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c71100585.tddop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c71100585.tddfil,tp,LOCATION_HAND,0,1,nil) then 
		local g=Duel.SelectMatchingCard(tp,c71100585.tddfil,tp,LOCATION_HAND,0,1,1,nil) 
		g:AddCard(c) 
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then 
			Duel.Draw(tp,2,REASON_EFFECT) 
		end 
	end 
end
function c71100585.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE) 
end
function c71100585.tdfil(c) 
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)  
end 
function c71100585.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingTarget(c71100585.tdfil,tp,LOCATION_GRAVE,0,1,c) end  
	local sg=Duel.SelectTarget(tp,c71100585.tdfil,tp,LOCATION_GRAVE,0,1,1,c)
	sg:AddCard(c) 
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0) 
end
function c71100585.tdop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	end 
end 
