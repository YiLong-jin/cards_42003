--驱动女神宣发活动
function c71100286.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,71100286)
	e1:SetTarget(c71100286.target)
	e1:SetOperation(c71100286.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,71100286)
	e2:SetTarget(c71100286.sttg)
	e2:SetOperation(c71100286.stop)
	c:RegisterEffect(e2)
end
function c71100286.filter(c)
	return c:IsSetCard(0x17df) and c:IsAbleToHand() and not c:IsCode(71100286)
end
function c71100286.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71100286.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71100286.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71100286.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71100286.filter2(c)
	  return c:IsSetCard(0x17df) and c:IsType(TYPE_QUICKPLAY) and c:IsSSetable() 
end
function c71100286.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c71100286.filter2,tp,LOCATION_REMOVED,0,1,nil) end
end
function c71100286.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c71100286.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then 
	  Duel.SSet(tp,tc)
	end
end