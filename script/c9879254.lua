--魔石重压
function c9879254.initial_effect(c)
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879254,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9879254)
	e2:SetTarget(c9879254.target)
	e2:SetOperation(c9879254.operation)
	c:RegisterEffect(e2)

	  local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetTarget(c9879254.actg)
	e3:SetValue(1)
	c:RegisterEffect(e3)


	local e13=Effect.CreateEffect(c) 
	e13:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND) 
	e13:SetType(EFFECT_TYPE_IGNITION)  
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_GRAVE) 
	e13:SetCountLimit(1,1879254) 
	e13:SetTarget(c9879254.dttg) 
	e13:SetOperation(c9879254.dtop) 
	c:RegisterEffect(e13) 

end

function c9879254.filter(c)
	return c:IsSetCard(0x27e3) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c9879254.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879254.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9879254.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c9879254.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c9879254.actg(e,c)
	return c:IsFaceup() and c:GetCounter(0x107e)>0
end

function c9879254.desfil(c) 
	return c:IsFaceup() and c:GetCounter(0x107e)>0 
end 
function c9879254.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879254.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsAbleToHand() end 
	local g=Duel.SelectTarget(tp,c9879254.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c9879254.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,c) 
	end 
end 