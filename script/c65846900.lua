--超可爱执行者·光天女 开拓
function c65846900.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65846890,65846891,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_ONFIELD,0,aux.tdcfop(c))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65846900.setcon)
	e2:SetTarget(c65846900.settg)
	e2:SetOperation(c65846900.setop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,65846900)
	e3:SetCondition(c65846900.tdcon)
	e3:SetTarget(c65846900.tdtg)
	e3:SetOperation(c65846900.tdop)
	c:RegisterEffect(e3)
end
c65846900.SetCard_ZJ_CKAZXZ=true
function c65846900.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and c.SetCard_ZJ_CKAZXZ
end
function c65846900.tdfilter(c)
	return c:IsAbleToDeck() 
end
function c65846900.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) and chkc:IsControler(1-tp) and cm.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846900.tdfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c65846900.tdfilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c65846900.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c65846900.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c65846900.stfilter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c65846900.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65846900.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,65846900)==0 end
	Duel.RegisterFlagEffect(tp,65846900,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c65846900.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846900.stfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end