--叛逆者机甲-神威龙神
function c9878898.initial_effect(c)
	aux.AddCodeList(c,9878899)

	aux.AddLinkProcedure(c,c9878898.matfilter,4,99)
	c:EnableReviveLimit()


	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetDescription(aux.Stringid(9878898,0))
	e11:SetCategory(CATEGORY_EQUIP)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetTarget(c9878898.eqtg)
	e11:SetOperation(c9878898.eqop)
	c:RegisterEffect(e11)
	
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9878898,1))
	e12:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e12:SetCountLimit(1,9878898)
	e12:SetCondition(c9878898.discon)
	e12:SetOperation(c9878898.disop)
	c:RegisterEffect(e12)
	
end
function c9878898.matfilter(c)
	return c:IsLinkSetCard(0x17ec) and c:IsType(TYPE_MONSTER)
end

function c9878898.eqfilter(c,tp,mc)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:IsCode(9878899)
end
function c9878898.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9878898.eqfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function c9878898.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9878898.eqfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp,c)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c9878898.eqlimit)
		tc:RegisterEffect(e1)
		local atk=tc:GetAttack()
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(math.ceil(atk/2))
			tc:RegisterEffect(e2)
		end
	end
end
function c9878898.eqlimit(e,c)
	return e:GetOwner()==c
end

function c9878898.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c9878898.disop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		local bc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		bc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(bc,RESET_TURN_SET)
		Duel.Destroy(bc,REASON_EFFECT)
	end
end