--奥秘·虚空之风传送门
function c2222703.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,2222703)
	e2:SetCondition(c2222703.condition2)
	e2:SetTarget(c2222703.target)
	e2:SetOperation(c2222703.operation)
	c:RegisterEffect(e2)
end
function c2222703.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==1-tp
end
function c2222703.filter(c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c2222703.filters(c,e,tp)
	return c:IsLevelAbove(4) and c:IsLevelBelow(4) and c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0
end
function c2222703.atkf(c)
	return c:IsFaceup() and (c:IsAttackAbove(1) or c:IsDefenseAbove(1))
end
function c2222703.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c2222703.filters,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c2222703.atkf,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c2222703.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(atk/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(def/2))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
	local g=Duel.GetMatchingGroup(c2222703.filters,tp,LOCATION_DECK,0,nil)
	if #g>0 then 
		local tsc=g:RandomSelect(tp,1)
		if tsc then Duel.SpecialSummon(tsc,0,tp,tp,false,false,POS_FACEUP) end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c2222703.filter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end













