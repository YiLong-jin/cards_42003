--巴托尼亚-圣人之境哥隆尼
function c21400184.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(21400184,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21400184.srtg)
	e1:SetOperation(c21400184.srop)
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400184,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,21400184)
	e2:SetCost(c21400184.xxcost)
	e2:SetTarget(c21400184.xxtg)
	e2:SetOperation(c21400184.xxop)
	c:RegisterEffect(e2) 
	--pl 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,21400185)
	e3:SetCost(c21400184.xxcost)
	e3:SetTarget(c21400184.pltg)
	e3:SetOperation(c21400184.plop)
	c:RegisterEffect(e3)
end
function c21400184.srfilter(c)
	return c:IsAbleToHand() and c:IsCode(21400172)
end
function c21400184.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400184.srfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c21400184.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400184.srfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c21400184.pbfil(c) 
	return c:IsCode(21400172) and not c:IsPublic() 
end 
function c21400184.xxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400184.pbfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c21400184.pbfil,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.ConfirmCards(1-tp,g) 
	Duel.ShuffleHand(tp) 
end 
function c21400184.xxfil(c)   
	if not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5211)) then return end 
	local b1=c:IsAbleToHand() 
	local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() 
	return b1 or b2  
end 
function c21400184.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400184.xxfil,tp,LOCATION_DECK,0,1,nil) end 
end
function c21400184.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.SelectMatchingCard(tp,c21400184.xxfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	if tc then 
		local b1=tc:IsAbleToHand() 
		local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsForbidden() 
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(21400184,3)},{b2,aux.Stringid(21400184,4)})
		if op==1 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,tc) 
		end
		if op==2 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e2)
		end
	end 
end 
function c21400184.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
end
function c21400184.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end 
end 






