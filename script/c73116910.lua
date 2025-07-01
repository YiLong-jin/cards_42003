--预见末日的贤人·调停者
function c73116910.initial_effect(c)
	aux.EnableChangeCode(c,73116915,LOCATION_MZONE+LOCATION_GRAVE)
----------------------------------------------------------------------------------------------------------------------------------------
	local e1=Effect.CreateEffect(c)
	c:EnableReviveLimit()
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c73116910.fuckkonami)
	c:RegisterEffect(e1)
----------------------------------------------------------------------------------------------------------------------------------------	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetDescription(aux.Stringid(73116910,0))
	e2:SetCondition(c73116910.con)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetTarget(c73116910.tg)
	e2:SetOperation(c73116910.op)
	c:RegisterEffect(e2)
----------------------------------------------------------------------------------------------------------------------------------------
--[[	local e3=Effect.CreateEffect(c)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetDescription(aux.Stringid(73116910,1))
	e3:SetCountLimit(1,73116910)
	e3:SetCondition(c73116910.RR)
	e3:SetTarget(c73116910.SR)
	e3:SetOperation(c73116910.PK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	c:RegisterEffect(e3)]]
----------------------------------------------------------------------------------------------------------------------------------------	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetDescription(aux.Stringid(73116910,2))
	e4:SetCountLimit(1,73116910)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c73116910.cptg)
	e4:SetCondition(c73116910.condition)
	e4:SetOperation(c73116910.cpop)
	c:RegisterEffect(e4)
	
	
	
----------------------------------------------------------------------------------------------------------------------------------------	
		--copy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(73116905,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,73116910+100000)
	e7:SetCost(c73116910.cost2)
	e7:SetCondition(c73116910.condition)
	e7:SetTarget(c73116910.cptg)
	e7:SetOperation(c73116910.cpop)
	c:RegisterEffect(e7)
	
	
	
	
end

function c73116910.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c73116910.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c73116910.cpfilter(c)
	return  c:IsSetCard(0x8ac) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c73116910.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c73116910.cpfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c73116910.cpfilter,tp,LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c73116910.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end





















function c73116910.fuckkonami(e,se,sp,st)
	return st&SUMMON_TYPE_LINK == 0 and not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c73116910.con(e,c)
	if (c==nil) then return true end
	local tp = c:GetControler()
	local g1 = Duel.GetMatchingGroup(c73116910.spy, tp, LOCATION_GRAVE, 0, nil, 73116915)
	local g2 = Duel.GetMatchingGroup(c73116910.spy, tp, LOCATION_GRAVE, 0, nil, 73116905)
	g1:Merge(g2)
	return g1:GetCount() >= 2 and g1:CheckSubGroup(c73116910.spy2, 2, 2, c, tp)
end
function c73116910.tg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1 = Duel.GetMatchingGroup(c73116910.spy, tp, LOCATION_GRAVE, 0, nil, 73116915)
	local g2 = Duel.GetMatchingGroup(c73116910.spy, tp, LOCATION_GRAVE, 0, nil, 73116905)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
	local sg = g1:SelectSubGroup(tp, c73116910.spy2, true, 2, 2, c, tp)
	if sg then
		sg:KeepAlive()
   		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function c73116910.spy(c,id)
	return c:IsCode(id) and c:IsAbleToDeckOrExtraAsCost() and c:IsFaceup()
end
function c73116910.psy(g)	
	local c1 = g:GetFirst()
	local c2 = g:GetNext()
	return (c1:IsCode(73116915) and c2:IsCode(73116905)) or (c1:IsCode(73116905) and c2:IsCode(73116915))	
end
function c73116910.spy2(g, c, tp)
	return c73116910.psy(g) and Duel.GetLocationCountFromEx(tp, tp, g, c) >= 1
end
function c73116910.op(e,tp,eg,ep,ev,re,r,rp,c)
	local g = e:GetLabelObject()
	Duel.SendtoDeck(g, nil, 2, REASON_COST+REASON_SPSUMMON)
	g:DeleteGroup()
end
function c73116910.RR(e,tp,eg,ep,ev,re,r,rp)
	local te = Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	if not te then return false end
	local tc = te:GetHandler()
	return tc:IsSetCard(0x8ac)
end
function c73116910.SR(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end
function c73116910.PK(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g, REASON_EFFECT)
	end
end
function c73116910.filter(c)
	local typ=c:GetType()
	return c:IsFaceupEx() and c:IsSetCard(0x8ac) and (typ&(TYPE_SPELL+TYPE_TRAP)>0)
		and c:CheckActivateEffect(false,true,false)
end
function c73116910.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c73116910.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c73116910.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst()
	local te,ceg,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c73116910.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not (te and te:GetHandler():IsRelateToEffect(e)) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end