--小阿卡那的星币 河的旋律
function c65846955.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65846955+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c65846955.target)
	e1:SetOperation(c65846955.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846955,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65846955.ovcon)
	e2:SetTarget(c65846955.ovtg)
	e2:SetOperation(c65846955.ovop)
	c:RegisterEffect(e2)
end
function c65846955.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65846955.filter(c,e,sp)
	return c:IsSetCard(0x23ef) and c:IsCanBeSpecialSummoned(e,0,sp,false,false,POS_FACEUP_DEFENSE)
end
function c65846955.activate(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c65846955.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(65846955,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c65846955.cfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c65846955.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65846955.cfilter,1,nil)
end
function c65846955.matfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function c65846955.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c65846955.matfilter(chkc) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846955.matfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c65846955.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65846955.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		Duel.Overlay(tc,g)
	end
	if c:IsRelateToChain() and c:IsCanOverlay() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(65846955,3)) then
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,c)
	end
end