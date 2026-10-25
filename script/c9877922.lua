--夏日魔法师 黑江
function c9877922.initial_effect(c)
	aux.AddCodeList(c,9877918,9877873)
	aux.AddLinkProcedure(c,c9877922.lfcheck,2,2)
	c:EnableReviveLimit()

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877922,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,9877922)
	e2:SetTarget(c9877922.target)
	e2:SetOperation(c9877922.operation)
	c:RegisterEffect(e2)
end
function c9877922.lfcheck(c)
	return c:IsLinkRace(RACE_SPELLCASTER)
end
function c9877922.spfil(c,e,tp)
	return (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877918)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877922.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9877922.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9877922.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9877922.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end