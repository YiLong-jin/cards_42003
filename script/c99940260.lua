--情怀喵
function c99940260.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c99940260.lcheck)
	aux.AddLinkProcedure(c,nil,2,3,c99940260.lcheck)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,99940260+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c99940260.hspcon)
	e0:SetOperation(c99940260.hspop)
	--c:RegisterEffect(e0)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99940260,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99940261)
	e1:SetTarget(c99940260.sptg)
	e1:SetOperation(c99940260.spop)
	c:RegisterEffect(e1)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(13035077,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,99940262)
	e5:SetTarget(c99940260.destg)
	e5:SetOperation(c99940260.desop)
	c:RegisterEffect(e5)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
end
function c99940260.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM) or g:IsExists(Card.IsAttack,1,nil,1550)
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
end
function c99940260.rspfilter(c,tp)
	return (c:IsLinkAbove(3) and c:IsLinkMarker(LINK_MARKER_LEFT)) and (c:IsControler(tp) or c:IsFaceup()) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c99940260.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetReleaseGroup(tp):Filter(c99940260.rspfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c99940260.rspfilter,nil,tp)
	g1:Merge(g2)
	return g1:GetCount()>0
end
function c99940260.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetReleaseGroup(tp):Filter(c99940260.rspfilter,nil,tp)
	local g2=Duel.GetReleaseGroup(1-tp):Filter(c99940260.rspfilter,nil,tp)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	Duel.Release(tc,REASON_COST)
	c:CopyEffect(tc:GetOriginalCodeRule(),RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,1)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
function c99940260.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c99940260.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99940260.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99940260.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c99940260.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c99940260.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
	Duel.SpecialSummonComplete()
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
function c99940260.thfilter(c)
	return c:IsAttack(1550) and c:IsDefense(1550) and c:IsAbleToHand()
end
function c99940260.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c99940260.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99940260.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c99940260.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------




