--首里 奔向未来
function c9877798.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e0)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877798,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x27eb))
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9877798,1))
	e4:SetCategory(CATEGORY_DRAW) 
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET) 
	e4:SetRange(LOCATION_FZONE) 
	e4:SetCountLimit(1,9877798)
	e4:SetCost(c9877798.negcost1)
	e4:SetTarget(c9877798.drtg) 
	e4:SetOperation(c9877798.drop) 
	c:RegisterEffect(e4)
end


function c9877798.thfilter(c)
	return c:IsSetCard(0x27eb) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9877798.negcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877798.thfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9877798.thfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9877798.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end 
	Duel.SetTargetPlayer(tp) 
	Duel.SetTargetParam(1) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c9877798.drop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM) 
	Duel.Draw(p,d,REASON_EFFECT) 
end 