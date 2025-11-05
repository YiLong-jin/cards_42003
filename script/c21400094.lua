--纳垢坩埚
function c21400094.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c21400094.target)
	e1:SetOperation(c21400094.activate)
	c:RegisterEffect(e1)
	--xx 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400094,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,21400094)  
	e1:SetLabel(1)
	e1:SetCost(c21400094.cost)
	e1:SetTarget(c21400094.rectg)
	e1:SetOperation(c21400094.recop)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(21400094,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,21400094)  
	e2:SetLabel(4)
	e2:SetCost(c21400094.cost)   
	e2:SetTarget(c21400094.thtg)
	e2:SetOperation(c21400094.thop)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(21400094,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,21400094)  
	e3:SetLabel(7)
	e3:SetCost(c21400094.cost)   
	e3:SetTarget(c21400094.sptg)
	e3:SetOperation(c21400094.spop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c21400094.desreptg)
	e4:SetOperation(c21400094.desrepop)
	c:RegisterEffect(e4)
end
function c21400094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x1077,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x1077)
end
function c21400094.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x1077,1)
	end
end
function c21400094.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetLabel()
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1077,x,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1077,x,REASON_COST) 
end 
function c21400094.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1077)
	if chk==0 then return ct>1 and Duel.GetFlagEffect(tp,21400094)==0 end 
	Duel.RegisterFlagEffect(tp,21400094,0,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*700)
end
function c21400094.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1077)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Recover(p,ct*700,REASON_EFFECT)
	end
end
function c21400094.thfilter(c)
	return c:IsSetCard(0x9210) and c:IsAbleToHand()
end
function c21400094.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400094.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c21400094.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400094.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end 
function c21400094.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0x9210) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0  
end 
function c21400094.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400094.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c21400094.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sc=Duel.SelectMatchingCard(tp,c21400094.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst() 
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) then
		sc:RegisterFlagEffect(21400094,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(sc)
		e1:SetCondition(c21400094.tdcon)
		e1:SetOperation(c21400094.tdop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SpecialSummonComplete()
end 
function c21400094.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(21400094)~=0
end
function c21400094.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)
end
function c21400094.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE)
		and e:GetHandler():IsCanRemoveCounter(tp,0x1077,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c21400094.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1077,1,REASON_EFFECT)
end

