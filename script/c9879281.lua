--爱意的烟火祭
function c9879281.initial_effect(c)
	 aux.AddCodeList(c,9879280)

	 local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9879281,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,9879281+EFFECT_COUNT_CODE_OATH)
	e4:SetTarget(c9879281.destg1)
	e4:SetOperation(c9879281.desop1)
	c:RegisterEffect(e4)

	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1879281)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9879281.rectg)
	e3:SetOperation(c9879281.recop)
	c:RegisterEffect(e3)
end
function c9879281.spfilter(c,e,tp)
	return c:IsCode(9879280) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c9879281.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c9879281.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9879281.desop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879281.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c9879281.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c9879281.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
