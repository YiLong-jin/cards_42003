--鲑鱼子五宵
function c9879273.initial_effect(c)
	 aux.AddCodeList(c,9879202)
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),c9879273.ntfilter,1,1)
	c:EnableReviveLimit() 

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879273,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,9879273)
	e3:SetCondition(c9879273.remcon)
	e3:SetTarget(c9879273.destg)
	e3:SetOperation(c9879273.desop)
	c:RegisterEffect(e3)

	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9879273,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9879273)
	e1:SetTarget(c9879273.target)
	e1:SetOperation(c9879273.activate)
	c:RegisterEffect(e1)
	
end
function c9879273.ntfilter(c)
	return not c:IsType(TYPE_TUNER) and aux.IsCodeListed(c,9879202)
end

function c9879273.spfilter(c,e,tp)
	return aux.IsCodeListed(c,9879202) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9879273.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9879273.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c9879273.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c9879273.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879273.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end



function c9879273.desfilter1(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c9879273.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c)
end
function c9879273.desfilter2(c,mc)
	return c:IsFaceup() and c:IsAttribute(mc:GetAttribute()) and not c:IsCode(mc:GetCode())
end
function c9879273.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9879273.desfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9879273.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c9879273.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	local g2=Duel.GetMatchingGroup(c9879273.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,g1,g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c9879273.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c9879273.desfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,tc)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end