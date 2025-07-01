--复生机芯·伽拉忒亚
function c69969999.initial_effect(c)
	aux.AddLinkProcedure(c,c69969999.bfilter,1,1)
	c:EnableReviveLimit()
local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969999,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,69969999)
	e1:SetTarget(c69969999.tdtg)
	e1:SetOperation(c69969999.tdop)
	c:RegisterEffect(e1)	
 local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c69969999.tdcon2)
	c:RegisterEffect(e2)
end
function c69969999.bfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkSetCard(0x11b)
end
function c69969999.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,90351981)
end
function c69969999.tdfilter(c)
	return c:IsSetCard(0x11b) and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c69969999.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c69969999.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c69969999.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c69969999.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c69969999.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
