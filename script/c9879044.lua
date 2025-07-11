--共振同步加速器
function c9879044.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 

	aux.AddCodeList(c,9879042)

	

	 local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879044,0))
	e11:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCountLimit(1,9879044)
	e11:SetTarget(c9879044.thtg)
	e11:SetOperation(c9879044.thop)
	c:RegisterEffect(e11)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879044,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)  
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9879044)
	e2:SetTarget(c9879044.thtg1)
	e2:SetOperation(c9879044.thop1)
	c:RegisterEffect(e2)

end
function c9879044.ctilter1(c,e,tp)
	return  aux.IsCodeListed(c,9879042) and c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO)and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9879044.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9879044.thop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9879044.ctilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9879042,2)) then
			local g=Duel.SelectMatchingCard(tp,c9879044.ctilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end


function c9879044.thfilter(c)
	return aux.IsCodeListed(c,9879042) and c:IsAbleToHand()
end
function c9879044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879044.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9879044.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879044.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end