--爱怜解放
function c9879059.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9879059+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9879059.target)
	e1:SetOperation(c9879059.activate)
	c:RegisterEffect(e1)
end
function c9879059.costfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsCanHaveCounter(0x7e2)
end
function c9879059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(c9879059.costfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c9879059.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c9879059.costfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
	Duel.Draw(p,d,REASON_EFFECT)
	end
end