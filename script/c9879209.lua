--驱动空天变身-六宵
c9879209.kotian=true
function c9879209.initial_effect(c)
	aux.AddCodeList(c,9879202,9879208,9879203)
	c:EnableReviveLimit()

	aux.EnableChangeCode(c,9879203,LOCATION_EXTRA)


	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c9879209.splimit)
	c:RegisterEffect(e0)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c9879209.discon)
	e4:SetOperation(c9879209.disop)
	c:RegisterEffect(e4)


	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879209,0))
	e11:SetCategory(CATEGORY_DESTROY)
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetType(EFFECT_TYPE_QUICK_O) 
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMING_END_PHASE)
	e11:SetCountLimit(1,9879209)
	e11:SetCost(c9879209.cost)
	e11:SetTarget(c9879209.target)
	e11:SetOperation(c9879209.operation)
	c:RegisterEffect(e11)
	
end
function c9879209.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(9879208)
end

function c9879209.cfilter(c,seq2)
	local seq1=aux.MZoneSequence(c:GetSequence())
	return c:IsFaceup() and aux.IsCodeListed(c,9879202) and c:IsSummonLocation(LOCATION_EXTRA) and seq1==4-seq2
end
function c9879209.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	seq=aux.MZoneSequence(seq)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE
		and Duel.IsExistingMatchingCard(c9879209.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c9879209.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9879209)
	Duel.NegateEffect(ev)
end


function c9879209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9879209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9879209.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
