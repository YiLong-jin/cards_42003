--星域的星之满溢龙
function c65848068.initial_effect(c)
	aux.AddCodeList(c,65848059)	
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65848066,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,true,true)
	aux.AddContactFusionProcedure(c,aux.FilterBoolFunction(Card.IsReleasable,REASON_SPSUMMON),LOCATION_ONFIELD,0,Duel.SendtoGrave,REASON_SPSUMMON+REASON_MATERIAL)	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65848068,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,65848068)
	e1:SetCondition(c65848068.descon)
	e1:SetTarget(c65848068.destg)
	e1:SetOperation(c65848068.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c65848068.atkval)
	c:RegisterEffect(e2)
end
function c65848068.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c65848068.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c65848068.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c65848068.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c65848068.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,2,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,g1:GetCount(),0,0)
end
function c65848068.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c65848068.atkval(e,c)
	return Duel.GetMatchingGroupCount(function(c) return c:IsType(0x6) and aux.IsCodeListed(c,65848059) end,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end