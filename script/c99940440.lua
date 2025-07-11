--零衣-交刃基础武装
function c99940440.initial_effect(c)

	c:SetSPSummonOnce(99940440)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,1,c99940440.lcheck)
		--destroy
		
			--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99940440,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(c99940440.cost)
	e3:SetTarget(c99940440.target)
	e3:SetOperation(c99940440.operation)
	c:RegisterEffect(e3)
end

function c99940440.lcheck(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,26077387)
end
function c99940440.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c99940440.filter(c,tp)
	if (not c:IsType(TYPE_FIELD)) and Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return false end
	return ((c:GetType()==TYPE_SPELL) or c:IsType(TYPE_QUICKPLAY) ) and c:CheckActivateEffect(true,false,false)~=nil
end
function c99940440.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99940440.filter,tp,LOCATION_HAND,0,1,nil,tp) end
end
function c99940440.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99940440,0))
	local tc=Duel.SelectMatchingCard(tp,c99940440.filter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local loc=nil
	if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE else loc=LOCATION_SZONE end
	if tc then
		Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		e:SetLabelObject(te:GetLabelObject())
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		if not tc:IsType(TYPE_FIELD+TYPE_CONTINUOUS) then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	end
end