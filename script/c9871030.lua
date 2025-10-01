--薇特莉斯甜点工坊-草莓蛋糕杯
function c9871030.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9871030,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9871030+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9871030.target)
	e1:SetOperation(c9871030.activate)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9871030,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,1871030)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9871030.xyztg)
	e3:SetOperation(c9871030.xyzop)
	c:RegisterEffect(e3)
end
function c9871030.xyzfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7ef)
end
function c9871030.matfilter(c)
	return c:IsSetCard(0x17e4) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c9871030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9871030.xyzfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9871030.xyzfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9871030.matfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9871030.xyzfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9871030.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c9871030.matfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end


function c9871030.xyzfilter(c)
	return c:IsSetCard(0x7ef) and c:IsXyzSummonable(nil)
end
function c9871030.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9871030.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9871030.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9871030.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end