--汞之沙漏
function c10701498.initial_effect(c)
	aux.AddCodeList(c,10701151)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701498+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701498.sptg)
	e1:SetOperation(c10701498.spop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701498,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c10701498.reccon)
	e2:SetTarget(c10701498.rectg)
	e2:SetOperation(c10701498.recop)
	c:RegisterEffect(e2)
end
function c10701498.spfilter(c,e,tp)
	return (c:IsCode(10701159) or (c:IsSetCard(0x7c3) and c:IsLocation(LOCATION_HAND+LOCATION_REMOVED))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701498.filter(c)
	return c:IsCode(10701151) and c:IsFaceup()
end
function c10701498.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND+LOCATION_REMOVED 
		if Duel.IsExistingMatchingCard(c10701498.filter,tp,LOCATION_SZONE,0,1,nil) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c10701498.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK)
end
function c10701498.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_REMOVED 
	if Duel.IsExistingMatchingCard(c10701498.filter,tp,LOCATION_SZONE,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701498.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701498.reccon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsCode(10701159)
end
function c10701498.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,10701498)==0 end
	Duel.RegisterFlagEffect(tp,10701498,RESET_CHAIN,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function c10701498.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c10701498.tgfilter)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	Duel.RegisterEffect(e2,tp)
end
function c10701498.tgfilter(e,c)
	return c:IsFaceup()
end