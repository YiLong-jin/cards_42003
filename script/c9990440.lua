--六翼 余裕
function c9990440.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9990440,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9990440)
	e1:SetTarget(c9990440.thtg)
	e1:SetOperation(c9990440.thop)
	c:RegisterEffect(e1)
end
function c9990440.costfilter(c,g)
	return c:IsSetCard(0x675) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
		and g:IsExists(c9990440.thfilter1,1,nil,g,c:GetLevel())
end
function c9990440.thfilter1(c,g,lv)
	return g:IsExists(c9990440.thfilter2,1,c,c,lv)
end
function c9990440.thfilter2(c,mc,lv)
	return not c:IsCode(mc:GetCode()) and c:GetLevel()+mc:GetLevel()==lv
end
function c9990440.thfilter(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9990440.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9990440.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990440.costfilter,tp,LOCATION_EXTRA,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c9990440.costfilter,tp,LOCATION_EXTRA,0,1,1,nil,g)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9990440.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9990440.thfilter,tp,LOCATION_DECK,0,nil)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(tp,c9990440.thfilter1,1,1,nil,g,lv)
	if #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g:FilterSelect(tp,c9990440.thfilter2,1,1,sg:GetFirst(),sg:GetFirst(),lv)
		sg:Merge(sg2)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(1-tp,1)
		tg:GetFirst():SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		sg:Sub(tg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c9990440.splimit(e,c)
	return not c:IsSetCard(0x671) and c:IsLocation(LOCATION_EXTRA)
end