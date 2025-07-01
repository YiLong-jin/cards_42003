--公司魔女
local m=71100000
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,71100000)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ToGrave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,71100010)
	e2:SetCondition(cm.qocon1) 
	e2:SetTarget(cm.trtg)
	e2:SetOperation(cm.trop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(cm.qocon2) 
	c:RegisterEffect(e3)
end
function cm.qocon1(e,tp,eg,ep,ev,re,r,rp)
	return not (Duel.GetFlagEffect(tp,71100031)~=0 or e:GetHandler():IsHasEffect(71100031))
end
function cm.qocon2(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,71100031)~=0 or e:GetHandler():IsHasEffect(71100031))
end
function cm.thfilter(c,e,tp)
	return c:IsCode(71100001) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)>0 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsSetCard(0x7d0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)<=0 or not Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return end
	local gh=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.ConfirmCards(1-tp,gh)
	if gh then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
	end
end
function cm.costfilter(c)
	return c:IsSetCard(0x7d0) and c:IsAbleToGraveAsCost() and not c:IsCode(m)
end
function cm.costfilter2(c)
	return aux.dscon() and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c1g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	if e:GetHandler():IsHasEffect(71100030) then 
		local c2g=Duel.GetMatchingGroup(cm.costfilter2,tp,0,LOCATION_MZONE,nil)
		c1g:Merge(c2g)
	end
	if chk==0 then return c1g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c1g:Select(tp,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tgfilter(c)
	return (c:IsSetCard(0x7d0) or c:IsSetCard(0x7d1)) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function cm.trfil(c) 
	return c:IsSetCard(0x7d0,0x7d1) and c:IsAbleToGrave() and c:IsAbleToRemove() 
end 
function cm.trgck(g) 
	return g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==1 
	   and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==1  
end 
function cm.trtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.trfil,tp,LOCATION_MZONE+LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.trgck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0)
end 
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(cm.trfil,tp,LOCATION_MZONE+LOCATION_DECK,0,nil) 
	if g:CheckSubGroup(cm.trgck,2,2) then 
		local sg=g:SelectSubGroup(tp,cm.trgck,false,2,2) 
		Duel.ConfirmCards(1-tp,sg) 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE) 
		local tc1=sg:Select(tp,1,1,nil):GetFirst() 
		local tc2=sg:Filter(aux.TRUE,tc1):GetFirst()
		Duel.SendtoGrave(tc1,REASON_EFFECT) 
		Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT) 
	end 
end






