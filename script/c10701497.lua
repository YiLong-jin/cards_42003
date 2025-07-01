--银之钥匙
function c10701497.initial_effect(c)
	aux.AddCodeList(c,10701151)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10701497+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10701497.sptg)
	e1:SetOperation(c10701497.spop)
	c:RegisterEffect(e1)
	--Destroy 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701497,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c10701497.atkcon)
	e2:SetTarget(c10701497.atktg)
	e2:SetOperation(c10701497.atkop)
	c:RegisterEffect(e2)
end
function c10701497.spfilter(c,e,tp)
	return (c:IsCode(10701163) or (c:IsSetCard(0x7c3) and c:IsLocation(LOCATION_HAND+LOCATION_REMOVED))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701497.filter(c)
	return c:IsCode(10701151) and c:IsFaceup()
end
function c10701497.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local loc=LOCATION_HAND+LOCATION_REMOVED 
		if Duel.IsExistingMatchingCard(c10701497.filter,tp,LOCATION_SZONE,0,1,nil) then
			loc=loc+LOCATION_DECK
		end
		return Duel.IsExistingMatchingCard(c10701497.spfilter,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED+LOCATION_DECK)
end
function c10701497.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc=LOCATION_HAND+LOCATION_REMOVED 
	if Duel.IsExistingMatchingCard(c10701497.filter,tp,LOCATION_SZONE,0,1,nil) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701497.spfilter,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701497.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsControler(tp) and eg:GetFirst():IsCode(10701163)
end
function c10701497.atkfilter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or aux.NegateMonsterFilter(c))
end
function c10701497.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701497.atkfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.GetFlagEffect(tp,10701497)==0 end
	Duel.RegisterFlagEffect(tp,10701497,RESET_CHAIN,0,1)
end
function c10701497.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10701497.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e4)
		tc=g:GetNext()
	end
end