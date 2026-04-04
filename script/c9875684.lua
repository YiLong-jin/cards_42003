--炎圣魔龙
function c9875684.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(nil),1)
	c:EnableReviveLimit()  
	--to grave  
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,9875684) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end) 
	e1:SetTarget(c9875684.tgstg) 
	e1:SetOperation(c9875684.tgsop) 
	c:RegisterEffect(e1)   
	--to deck and des 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1875684) 
	e2:SetTarget(c9875684.tddtg) 
	e2:SetOperation(c9875684.tddop) 
	c:RegisterEffect(e2)   
end 
function c9875684.tgfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToGrave() 
end 
function c9875684.tgstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9875684.tgfil,tp,LOCATION_SZONE,0,1,nil) 
	end 
	local g=Duel.SelectTarget(tp,c9875684.tgfil,tp,LOCATION_SZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c9875684.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x2ea7)   
end 
function c9875684.tgsop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c9875684.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9875684,0)) then 
		Duel.BreakEffect() 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c9875684.tddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c9875684.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsCode(9875671) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9875684,1)) then 
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT) 
	end  
end 













