--V城编年史~毁灭根源
local cm,m,o=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Destroy 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cm.rmcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function cm.filter(c,e,tp,spchk)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER) and (c:IsAbleToHand() or spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,spchk)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,spchk)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if spchk and sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and sc:IsType(TYPE_MONSTER)
			and (not sc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(sc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
		end
		local tg = Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
		for tc in aux.Next(tg) do
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_ONFIELD)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(cm.efilter1)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			tc:RegisterEffect(e4)
		end
	end
end
function cm.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.disfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable(REASON_EFFECT)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,nil)
	if #dg>0 and Duel.DiscardHand(tp,cm.disfilter,1,1,REASON_EFFECT,nil)~=0 then 
		local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
