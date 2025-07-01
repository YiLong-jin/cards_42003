--大日零件
function c10701297.initial_effect(c)
	c:SetSPSummonOnce(42110604)
	--link summon
	aux.AddLinkProcedure(c,c10701297.matfilter,1,1)
	c:EnableReviveLimit()
	--destroy + SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701297,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c10701297.target)
	e1:SetOperation(c10701297.operation)
	c:RegisterEffect(e1)
end
function c10701297.matfilter(c)
	return c:GetEquipCount()>0
end
function c10701297.desfilter(c,ec,e,tp)
	local lv=c:GetOriginalLevel()
	local rc=c:GetOriginalRace()
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and lv>0 and Duel.IsExistingMatchingCard(c10701297.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalLevel(),c:GetOriginalRace())
end
function c10701297.spfilter(c,e,tp,lv,rc)
	return c:IsLevelBelow(lv) and c:IsRace(rc) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701297.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c10701297.desfilter(chkc,c,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c10701297.desfilter,tp,LOCATION_SZONE,0,1,nil,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10701297.desfilter,tp,LOCATION_SZONE,0,1,1,nil,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c10701297.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701297.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetOriginalLevel(),tc:GetOriginalRace())
	if g:GetCount()>0 then
	  if tc:IsRelateToEffect(e) and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		  Duel.Destroy(tc,REASON_EFFECT)
	  end
	end
end