--闭锁天空的死神
function c65840013.initial_effect(c)
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.Tuner(Card.IsType,TYPE_SYNCHRO),2,99)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c65840013.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,65840013)
	e2:SetCost(c65840013.spcost)
	e2:SetCondition(c65840013.spcon)
	e2:SetTarget(c65840013.sptg)
	e2:SetOperation(c65840013.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetOperation(c65840013.checkop)
	c:RegisterEffect(e3)
end
function c65840013.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER)*500
end
function c65840013.spcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c65840013.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsType(TYPE_TUNER)
end
function c65840013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c65840013.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c65840013.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c65840013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,0,tp,LOCATION_GRAVE)
end
function c65840013.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToChain(ev) and Duel.Destroy(eg,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65840013.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local res=false
	while tc do
		if tc:IsLocation(LOCATION_GRAVE) and (tc:GetReasonCard()==e:GetHandler() or (tc:IsReason(REASON_EFFECT) and re:GetHandler()==e:GetHandler()))
		and tc:IsReason(REASON_DESTROY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(65840013,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			res=true
		end
		tc=eg:GetNext()
	end
	if res then
		Duel.Hint(HINT_CARD,0,65840013)
	end
end