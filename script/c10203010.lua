--玉 莲 指 引
function c10203010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10203010)
	e1:SetCost(c10203010.thfilters)
	e1:SetTarget(c10203010.thtg)
	e1:SetOperation(c10203010.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,102030101)
	e2:SetCondition(c10203010.negcon)
	e2:SetTarget(c10203010.target)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c10203010.activate2)
	c:RegisterEffect(e2)
end
function c10203010.thfilter(c)
	return c:IsSetCard(0xe79e) and c:IsAbleToHand() or c:IsAbleToHand()
end
function c10203010.thfiltert(c)
	return c:IsSetCard(0xe79e) and c:IsAbleToHand()
end
function c10203010.thfilters(c)
	return Duel.GetMatchingGroupCount(nil,nil,LOCATION_GRAVE,LOCATION_GRAVE,0,nil)>0
end
function c10203010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10203010.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10203010.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_GRAVE,LOCATION_GRAVE,0,nil)
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,3,nil)
		local sge=sg
		local sgee=Group.CreateGroup()
		local tc=sge:GetFirst()
		while tc do
		if tc:IsSetCard(0xe79e) then
		sgee:AddCard(tc)
		end
		tc=sge:GetNext()
		end
		if sgee~=nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sgee:Select(tp,0,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		local sget=tg:GetFirst()
		if sget~=nil then
		sg:RemoveCard(sget)
		end
		end
		Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		
	end
end
function c10203010.spfilter(c,e,tp)
	return c:IsCode(10203001) or c:IsSetCard(0xe79e)
end
function c10203010.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c10203010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c10203010.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
end
function c10203010.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10203010.spfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end