--暗面魔法少女 和泉十七夜
function c99900630.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99900630)
	e1:SetCost(c99900630.spcost1)
	e1:SetTarget(c99900630.sptg1)
	e1:SetOperation(c99900630.spop1)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99900630,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,99900631)
	e3:SetTarget(c99900630.sptg)
	e3:SetOperation(c99900630.spop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99900630,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c99900630.indcon)
	e4:SetOperation(c99900630.indop)
	c:RegisterEffect(e4)
------------------------------------------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900630.thfilter(c)
	return c:IsSetCard(0x676) and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function c99900630.thfilter2(c,e,tp)
	return c:IsSetCard(0x676) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99900630.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99900630.thfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():IsAbleToGraveAsCost() end
	local g=Duel.SelectMatchingCard(tp,c99900630.thfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99900630.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99900630.thfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99900630.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99900630.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
	end
		Duel.SpecialSummonComplete()
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900630.filter(c,e,tp)
	return c:IsSetCard(0x676) and c:IsDefense(1150) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99900630.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99900630.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c99900630.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99900630.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------
function c99900630.indcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 
		and e:GetHandler():GetReasonCard():IsSetCard(0x676)
end
function c99900630.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c99900630.discon)
	e1:SetOperation(c99900630.disop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(99900630,2))
	Duel.Readjust()
end
function c99900630.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local atk=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTACK)
	return rp==1-tp and re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) and atk==0
end
function c99900630.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end



