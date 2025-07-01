--自动棋子 工程单元
local cm,m,o=GetID()
function cm.initial_effect(c)
	--sps
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
	--return to hand 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCondition(cm.rhcon)
	e4:SetCost(cm.rhcost)
	e4:SetTarget(cm.rhtg)
	e4:SetOperation(cm.rhop)
	c:RegisterEffect(e4)
end
cm.Automatic_chess_piece=true --「自动棋子」记述
function cm.ac_chk(ev)
	local a_chk=false 
	for i=1,ev do
		local re=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if re:GetHandler():IsAttribute(ATTRIBUTE_WATER) then 
			a_chk=true 
			break 
		end
	end
	return a_chk
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentChain()~=0 and cm.ac_chk(ev) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.rhcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.rhcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c)
	return c.Automatic_chess_piece and c:IsAbleToHand() and c:IsFaceup() and not c:IsCode(m)
end
function cm.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		return g:GetClassCount(Card.GetCode)>1
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.SendtoHand(tg1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg1)
end
