--四季·花束
function c69969256.initial_effect(c)
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969256,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,69969256)
	e1:SetTarget(c69969256.target)
	e1:SetOperation(c69969256.activate)
	c:RegisterEffect(e1)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969256,1))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,69969256)
	e4:SetTarget(c69969256.mvtg)
	e4:SetOperation(c69969256.mvop)
	c:RegisterEffect(e4)
end
function c69969256.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x69b) and c:GetOriginalType()&TYPE_MONSTER>0
		and Duel.IsExistingMatchingCard(c69969256.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetAttribute())
end
function c69969256.spfilter(c,e,tp,attr)
	return not c:IsAttribute(attr) and c:IsSetCard(0x669b)
		 and c:IsType(TYPE_MONSTER)and not c:IsForbidden() 
end
function c69969256.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c69969256.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c69969256.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c69969256.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
end
function c69969256.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		local attr=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c69969256.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,attr)
		local tc=g:GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			if tc:IsCanAddCounter(0x169b,2) then
			Duel.BreakEffect()
			tc:AddCounter(0x169b,2)
	  end
	  end
   end
end
--2
function c69969256.gfilter(c,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	return c:IsSetCard(0x669b) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c69969256.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c69969256.gfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c69969256.gfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c69969256.gfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp)
	if g:GetFirst():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0,tp)
	end
end
function c69969256.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT) and not tc:IsImmuneToEffect(e)
		and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
