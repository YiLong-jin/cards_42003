--跨越律者的试炼 月之始终
function c99950350.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99950350)
	c:RegisterEffect(e1)

	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99950350,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c99950350.cost)
	e2:SetTarget(c99950350.target)
	e2:SetOperation(c99950350.operation)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c99950350.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetValue(aux.indoval)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetTarget(c99950350.eftg)
	e5:SetLabelObject(e4)
	--c:RegisterEffect(e5)


end
function c99950350.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99950350.filter(c,tp)
	if (not c:IsType(TYPE_FIELD)) and Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return false end
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x66c) and c:CheckActivateEffect(false,false,false)~=nil
end
function c99950350.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99950350.filter,tp,LOCATION_HAND,0,1,nil,tp) end
end
function c99950350.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99950350,0))
	local tc=Duel.SelectMatchingCard(tp,c99950350.filter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
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

function c99950350.eftg(e,c)
	return (c:IsType(TYPE_XYZ) or (c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)) or c:IsType(TYPE_FIELD) ) and c:IsSetCard(0x66c)
end
