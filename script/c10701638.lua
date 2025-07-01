--古圣妖-古代妖精龙
function c10701638.initial_effect(c)
	aux.AddCodeList(c,25862681)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c10701638.sfilter),1,1)
	c:EnableReviveLimit() 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(25862681)
	e0:SetCondition(c10701638.actcon)
	c:RegisterEffect(e0)  
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10701638,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10701638)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c10701638.destg)
	e2:SetOperation(c10701638.desop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e3:SetCondition(c10701638.actcon)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10701638.actcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
c10701638.material_type=TYPE_SYNCHRO
function c10701638.sfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c10701638.cfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:GetSequence()==5 and c:IsType(TYPE_FIELD) and c:IsFaceup()
end
function c10701638.actcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c10701638.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10701638.ffilter(c)
	return c:GetPreviousTypeOnField()&TYPE_FIELD~=0
end
function c10701638.tdfilter(c)
	return c:IsAbleToHand()
end
function c10701638.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
	   Duel.Destroy(tg,REASON_EFFECT)
	   local og=Duel.GetOperatedGroup()
	   if og:IsExists(c10701638.ffilter,1,nil) then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		   local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701638.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		   if rg:GetCount()>0 then
			   Duel.ConfirmCards(1-tp,rg)
			   Duel.SendtoHand(rg,nil,REASON_EFFECT)
		   end
	   end
	end
end