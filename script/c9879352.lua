--一餅・二獅子・三紅晴
function c9879352.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9879352.target)
	e1:SetOperation(c9879352.activate)
	c:RegisterEffect(e1)
end
function c9879352.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,4,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c9879352.activate(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if ag:GetCount()==1 then
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		local xg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,3,3,nil)
	 if xg:GetCount()==3 then
		Duel.SendtoHand(xg,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,xg)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
	end
		end
	end
end