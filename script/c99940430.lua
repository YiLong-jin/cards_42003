--闪刀起动-迎击
function c99940430.initial_effect(c)


	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99940430.sptg)
	e1:SetOperation(c99940430.spop)
	c:RegisterEffect(e1)
	
	
end
function c99940430.spfilter(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil)
end
function c99940430.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940430.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99940430.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99940430.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.LinkSummon(tp,g:GetFirst(),nil)
	end
end