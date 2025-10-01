--薇特莉斯甜点工坊-晶莹水晶球
function c9871038.initial_effect(c)
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9871038+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9871038.target1)
	e1:SetOperation(c9871038.activate1)
	c:RegisterEffect(e1)

	 local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9871038,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,1871038)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c9871038.sptg2)
	e5:SetOperation(c9871038.spop2)
	c:RegisterEffect(e5)
end
function c9871038.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x17e4) and not c:IsLevel(5) and c:IsLevelAbove(1) and c:IsType(TYPE_MONSTER)
end
function c9871038.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9871038.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c9871038.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9871038.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9871038,0)) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(5)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end


function c9871038.spfilter(c,e,tp)
	return c:IsSetCard(0x17e4)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c9871038.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c9871038.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9871038.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9871038.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end