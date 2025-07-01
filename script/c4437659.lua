--妖精圆桌骑士的落幕
function c4437659.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4437659,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetCountLimit(1,4437659+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c4437659.chcon)
	e1:SetCost(c4437659.chcost)
	e1:SetTarget(c4437659.chtg)
	e1:SetOperation(c4437659.chop)
	c:RegisterEffect(e1)
end 
function c4437659.acfilter(c,tp)
	return c:IsSetCard(0xd77) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLocation(LOCATION_MZONE)
end
function c4437659.chcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return rp==1-tp and tg and tg:IsExists(c4437659.acfilter,1,nil,tp) 
end
function c4437659.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c4437659.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil)  end
end
function c4437659.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c4437659.repop)
end
function c4437659.repop(e,tp,eg,ep,ev,re,r,rp) 
	local sg1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)  
	Duel.SendtoDeck(sg1,nil,1,REASON_EFFECT)  
	local sg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,1,nil)  
	Duel.SendtoDeck(sg2,nil,1,REASON_EFFECT)  
	Duel.BreakEffect() 
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end







