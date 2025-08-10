--驱动空天变身
c9879208.kotian=true
function c9879208.initial_effect(c)
	aux.AddCodeList(c,9879202)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9879208+EFFECT_COUNT_CODE_OATH) 
	e1:SetTarget(c9879208.target)
	e1:SetOperation(c9879208.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9879208.thtg)
	e2:SetOperation(c9879208.thop)
	c:RegisterEffect(e2)
end
function c9879208.tfilter(c,att,e,tp,tc)
	return c.kotian and c:IsCode(att)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c9879208.filter(c,e,tp)
	return c:IsFaceup() and aux.IsCodeListed(c,9879202)
		and Duel.IsExistingMatchingCard(c9879208.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetCode(),e,tp,c)
end
function c9879208.chkfilter(c,att)
	return c:IsFaceup() and aux.IsCodeListed(c,9879202) and (c:GetCode()&att)==att
end
function c9879208.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9879208.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c9879208.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c9879208.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetCode())
end
function c9879208.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetCode()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9879208.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end


function c9879208.thfilter(c)
	return c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,9879202) and c:IsAbleToHand()  
end
function c9879208.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879208.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9879208.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879208.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end