--贫符「厄运播散」
c40802022.RR_ZXESZ=true
function c40802022.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c40802022.target)
	e1:SetOperation(c40802022.activate)
	c:RegisterEffect(e1) 

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40802022,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,40802021)
	e2:SetCondition(c40802022.thcon)
	e2:SetTarget(c40802022.thtg1)
	e2:SetOperation(c40802022.thop1)
	c:RegisterEffect(e2)

end

function c40802022.checkfilter(c)
	return c:IsCode(40802000) and c:IsFaceup()
end
function c40802022.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c40802022.tarfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c40802022.tarfil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c40802022.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local check=Duel.IsExistingMatchingCard(c40802022.checkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
		local e4=Effect.CreateEffect(c) 
		e4:SetCategory(CATEGORY_DAMAGE) 
		e4:SetType(EFFECT_TYPE_QUICK_F) 
		e4:SetCode(EVENT_CHAINING) 
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetCondition(c40802022.condition)
		e4:SetTarget(c40802022.rmtg)
		e4:SetOperation(c40802022.rmop)
		tc:RegisterEffect(e4)
	end
	if check and not tc:IsImmuneToEffect(e) then
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			e5:SetRange(LOCATION_MZONE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e5:SetValue(1)
			tc:RegisterEffect(e5)
			local e8=e5:Clone()
			e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e8)
	end
end


function c40802022.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c40802022.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true  end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end
function c40802022.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	if  Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 then
   local op=Duel.SelectOption(tp,aux.Stringid(40802022,0),aux.Stringid(40802022,1))+1   
	 if op==1 then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	 else 
		 local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)  
	end
   end
   if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<0 then
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)   
	end
end


function c40802022.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c40802022.thfilter(c)
	return c.RR_ZXESZ and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToHand() and not c:IsCode(40802022)
end
function c40802022.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40802022.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40802022.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40802022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end