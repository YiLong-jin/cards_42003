--纳垢瘟疫兽
function c21400089.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,c21400089.ffilter,2,true)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,21400089)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) end)
	e1:SetTarget(c21400089.settg)
	e1:SetOperation(c21400089.setop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11400089)
	e2:SetCost(c21400089.thcost)
	e2:SetTarget(c21400089.thtg)
	e2:SetOperation(c21400089.thop)
	c:RegisterEffect(e2)
end
function c21400089.ffilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM)
end
function c21400089.setfilter(c)
	return c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c21400089.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c21400089.setfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,2000)
end
function c21400089.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) or not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.GetMatchingGroup(c21400089.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	local tc1=g1:GetFirst()
	local tc2=g1:GetNext()
	if Duel.MoveToField(tc1,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		if Duel.MoveToField(tc2,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
			Duel.Damage(tp,2000,REASON_EFFECT)
			tc2:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		tc1:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
function c21400089.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21400089.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9210) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c21400089.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400089.thfilter,tp,LOCATION_EXTRA,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c21400089.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400089.thfilter,tp,LOCATION_EXTRA,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end




