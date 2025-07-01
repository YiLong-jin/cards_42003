--远古海洋 奇虾
local s,id,o=GetID()
function s.initial_effect(c)
  --special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp,exc)
	local b2=c:IsSetCard(0x975) and c:IsLocation(LOCATION_EXTRA)
		and Duel.GetLocationCountFromEx(tp,tp,exc,c)>0 and c:IsType(TYPE_XYZ)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and b2
end
function s.sptgfilter(c,e,tp)
	return c:IsSetCard(0x975) and not c:IsCode(90306302)
end
function s.sptgexfilter(c,e,tp,code)
	local sc=e:GetHandler()
	return  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c:IsType(TYPE_XYZ) and sc:IsCanBeXyzMaterial(c) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0 and c:IsSetCard(0x975)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.sptgfilter(chkc,e,tp) end   
	if chk==0 then return aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) and Duel.IsExistingTarget(s.sptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.sptgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
 end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if not sc:IsRelateToChain() then return end
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if not aux.MustMaterialCheck(sc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.sptgexfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
	local tc=sg:GetFirst()
	if sg:GetCount()>0 then
	Duel.Overlay(tc,c) 
	Duel.Overlay(tc,sc)
	Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	end
end
