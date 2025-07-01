--觉醒前夜
function c99900430.initial_effect(c)
	  --summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99900430+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c99900430.spcost)
	e1:SetTarget(c99900430.sumtg)
	e1:SetOperation(c99900430.sumop)
	c:RegisterEffect(e1)
end
function c99900430.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(99900430,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c99900430.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c99900430.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x676)
end
function c99900430.filter(c,e,tp)
	return c:IsSetCard(0x676) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c99900430.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c99900430.filter2(c,code)
	return c:IsSetCard(0x676) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end
function c99900430.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900430.filter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99900430.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end   
	local g=Duel.SelectMatchingCard(tp,c99900430.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local code=g:GetFirst():GetCode()
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c99900430.filter2,tp,LOCATION_DECK,0,1,nil,code) then
			Duel.BreakEffect()
			local tg=Duel.SelectMatchingCard(tp,c99900430.filter2,tp,LOCATION_DECK,0,1,1,nil,code)
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
