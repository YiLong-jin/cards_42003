--真实灾杰·莱奥
function c17030830.initial_effect(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c17030830.sumsuc)
	c:RegisterEffect(e1)
	--counter
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(17030830,0))
	e6:SetCategory(CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c17030830.coucon)
	e6:SetTarget(c17030830.coutg)
	e6:SetOperation(c17030830.couop)
	c:RegisterEffect(e6)
end
function c17030830.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsSummonLocation(LOCATION_GRAVE) then return end
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(c17030830.effectfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetValue(c17030830.effectfilter)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function c17030830.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and bit.band(loc,LOCATION_ONFIELD)~=0
		and (te:GetHandler():IsSetCard(0x57f3) or te:GetHandler():IsType(TYPE_SPELL) or te:GetHandler():IsRace(RACE_SPELLCASTER))
end
function c17030830.coucon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c17030830.coutg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if rc:IsSetCard(0x57f3) then e:GetHandler():RegisterFlagEffect(17030830,RESET_CHAIN,0,1) end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,nil,0x1,1) end
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x1,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0,0)
end
function c17030830.couop(e,tp,eg,ep,ev,re,r,rp)
	local ct=3 if e:GetHandler():GetFlagEffect(17030830)>0 and Duel.SelectYesNo(tp,aux.Stringid(17030830,1)) then ct=9 end
	if ct>0 and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,nil,0x1,1)>0 then
		while ct>0 do
			local cout=1
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,nil,0x1,1):GetFirst()
			if not tc then break end
			if Duel.SelectYesNo(tp,aux.Stringid(17030830,2)) then cout=ct end
			tc:AddCounter(0x1,cout)
			ct=ct-cout
		end
	end
end
