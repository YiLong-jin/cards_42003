--废品战士/爆裂体
function c10701392.initial_effect(c)
	aux.AddCodeList(c,80280737)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.AssaultModeLimit)
	c:RegisterEffect(e1) 
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701392,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10701392)
	e2:SetTarget(c10701392.sptg2)
	e2:SetOperation(c10701392.spop2)
	c:RegisterEffect(e2)
	--Special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701392,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c10701392.spcon)
	e3:SetTarget(c10701392.sptg)
	e3:SetOperation(c10701392.spop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701392,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c10701392.atktg)
	e4:SetOperation(c10701392.atkop)
	c:RegisterEffect(e4)   
end
c10701392.assault_name=60800381
function c10701392.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c10701392.spfilter(c,e,tp)
	return c:IsCode(60800381) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701392.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701392.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10701392.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10701392.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c10701392.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10701392.spfilter2(c,e,tp)
	return c:IsLevelBelow(2)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c10701392.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701392.spfilter2(chkc,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0
		and Duel.IsExistingTarget(c10701392.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10701392.spfilter2,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function c10701392.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetTargetsRelateToChain()
	if #g==0 then return end
	if #g>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(tp,ft,ft,nil)
	end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c10701392.filter(c)
	return c:IsFaceup() and c:IsLevelBelow(2)
end
function c10701392.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701392.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c10701392.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10701392.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=0
		local tc=g:GetFirst()
		while tc do
			atk=atk+tc:GetAttack()
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end