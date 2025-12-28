--巅峰超越
function c65843147.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65843147+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65843147.condition)
	e1:SetCost(c65843147.cost)
	e1:SetTarget(c65843147.target)
	e1:SetOperation(c65843147.activate)
	c:RegisterEffect(e1)	
end
function c65843147.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c65843147.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function c65843147.cfilter(c,e,tp)
	return c:IsSetCard(0x43ef) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsAbleToRemoveAsCost() and c:IsFaceup() and Duel.IsExistingMatchingCard(c65843147.spfilter,tp,LOCATION_PZONE,0,1,c,e,tp)
end
function c65843147.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65843147.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c65843147.cfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65843147.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65843147.spfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function c65843147.szfilter(c,sc)
	local lv=0
	if sc:IsType(TYPE_XYZ) then lv=sc:GetRank() elseif sc:IsType(TYPE_LINK) then lv=0 else lv=sc:GetLevel() end
	return c:GetRank()+c:GetLevel()>lv and c:IsFaceup()
end
function c65843147.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c65843147.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.HintSelection(g1)
	local tc=g1:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and  Duel.IsExistingMatchingCard(c65843147.szfilter,tp,0,LOCATION_MZONE,1,nil,tc) and Duel.SelectYesNo(tp,aux.Stringid(65843147,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65843147,3))
		local g2=Duel.SelectMatchingCard(tp,c65843147.szfilter,tp,SUMMON_TYPE_PENDULUM,LOCATION_MZONE,1,1,nil,tc)
		Duel.HintSelection(g2)
		local zc=g2:GetFirst()
		if Duel.MoveToField(zc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			zc:RegisterEffect(e1)
		end
	end
end