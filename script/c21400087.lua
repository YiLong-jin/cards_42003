--纳垢高汤醉人
function c21400087.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--th 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,21400087) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM) end)
	e1:SetTarget(c21400087.thtg)
	e1:SetOperation(c21400087.thop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,11400087) 
	e2:SetCondition(c21400087.drcon)
	e2:SetTarget(c21400087.drtg)
	e2:SetOperation(c21400087.drop)
	c:RegisterEffect(e2)
	--pendulum set
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetCountLimit(1,31400087)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
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
	e1:SetCondition(c21400087.pencon)
	e1:SetTarget(c21400087.pentg)
	e1:SetOperation(c21400087.penop)
	c:RegisterEffect(e1)
end
function c21400087.thfilter(c)
	return c:IsCode(21400094) and c:IsAbleToHand()
end
function c21400087.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400087.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21400087.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400087.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g) 
	end
end
function c21400087.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and r==REASON_FUSION
end
function c21400087.drtg(e,tp,eg,ep,ev,re,r,rp,chk)   
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21400087.drop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end 
function c21400087.cfilter(c)
	return c:IsSetCard(0x9210)
end
function c21400087.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c21400087.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c21400087.penfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and not c:IsCode(21400087) and not c:IsForbidden()
end
function c21400087.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c21400087.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c21400087.penop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c21400087.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end





