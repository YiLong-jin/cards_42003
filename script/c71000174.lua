--灰灭之火
local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13179234,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thfilter(c)
	return c:IsSetCard(0x17a1) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.desfilter(c,oc,e,tp)
	if oc:GetSequence()>=5 and Duel.GetMZoneCount(tp)<1 then return false end
	return c:IsFaceup() and c:IsAttackPos() and Duel.GetMZoneCount(tp,c,tp)>0 and c:IsDestructable(e) and oc:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local oc=Duel.GetOperatedGroup():GetFirst()
		local dg=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,0,nil,oc,e,tp)
		if dg:GetCount()>0 and oc and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dc=dg:Select(1-tp,1,1,nil)
			Duel.HintSelection(dc)
			if Duel.Destroy(dc,REASON_EFFECT)>0 then
				Duel.SpecialSummon(oc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end