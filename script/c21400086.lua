--纳垢庆典录者
function c21400086.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--ct 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400086) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) end)
	e1:SetTarget(c21400086.cttg)
	e1:SetOperation(c21400086.ctop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11400086) 
	e2:SetCondition(c21400086.atkcon)
	e2:SetTarget(c21400086.atktg)
	e2:SetOperation(c21400086.atkop)
	c:RegisterEffect(e2)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,31400086)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
				if chk==0 then return Duel.GetCustomActivityCount(21400084,tp,ACTIVITY_SPSUMMON)==0 end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetTargetRange(1,0)
				e1:SetTarget(function(e,tc) return not tc:IsSetCard(0x9210) end)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end)
	Duel.AddCustomActivityCounter(21400084,ACTIVITY_SPSUMMON,function(tc) return tc:IsSetCard(0x9210) end)
	e2:SetTarget(c21400086.srtg)
	e2:SetOperation(c21400086.srop)
	c:RegisterEffect(e2)
end
function c21400086.cttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,nil,0x1077,1)
	if chk==0 then return g:GetCount()>0 end 
end 
function c21400086.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,nil,0x1077,1)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1077,1)  
		tc=g:GetNext()
	end
end
function c21400086.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and r==REASON_FUSION
end
function c21400086.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local x=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1077) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return x>0 and g:GetCount()>0 end   
end
function c21400086.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local x=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1077) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if x>0 and g:GetCount()>0 then
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(x*100)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext() 
		end 
	end
end
function c21400086.srfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c21400086.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400086.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21400086.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400086.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


