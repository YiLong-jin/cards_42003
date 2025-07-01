--彩虹人偶 伴
function c65846113.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c65846113.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2)
	c:RegisterEffect(e1)	
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c65846113.secon)
	e3:SetTarget(c65846113.setg)
	e3:SetOperation(c65846113.seop)
	c:RegisterEffect(e3)
end
c65846113.SetCard_ZJ_CH=true
function c65846113.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsRace(RACE_FAIRY)
end
function c65846113.sefilter(c)
	return c.SetCard_ZJ_CH and c:IsType(0x6) and c:IsSSetable()
end
function c65846113.secon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO 
end
function c65846113.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846113.sefilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,65846113)==0 end
	Duel.RegisterFlagEffect(tp,65846113,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65846113.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65846113.sefilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end