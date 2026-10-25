--完美的应援
function c9878239.initial_effect(c)
	 aux.AddCodeList(c,9877896)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878239,1))
	e2:SetCategory(EFFECT_UPDATE_ATTACK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9878239+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9878239.condition1)
	e2:SetTarget(c9878239.atktg)
	e2:SetOperation(c9878239.atkop)
	c:RegisterEffect(e2)

	local e13=Effect.CreateEffect(c)  
	e13:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_REMOVE)
	e13:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e13:SetCondition(c9878239.grmcon)
	e13:SetTarget(c9878239.grmtg)
	e13:SetOperation(c9878239.grmop)
	c:RegisterEffect(e13) 
end
function c9878239.cfil1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_SPELLCASTER)
end
function c9878239.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9878239.cfil1,tp,LOCATION_MZONE,0,1,nil)
end
function c9878239.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c9878239.atkfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and aux.IsCodeListed(c,9877896)
end
function c9878239.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878239.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c9878239.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9878239.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	if Duel.IsExistingMatchingCard(c9878239.atkfilter1,tp,LOCATION_MZONE,0,1,nil) then
		while tc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(1000)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	else
		while tc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(500)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			tc=g:GetNext()
		end
	end
end


function c9878239.ctilter2(c)
	return  c:IsFacedown()
end
function c9878239.grmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and Duel.GetTurnPlayer()==1-tp and e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c9878239.grmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c9878239.ctilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c9878239.ctilter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9878239.grmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end