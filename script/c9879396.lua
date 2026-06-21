--契约的魔石
function c9879396.initial_effect(c)
	 local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(c9879396.target)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTarget(c9879396.target)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	
	
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(9879396,0))
	e11:SetCategory(CATEGORY_COUNTER+CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e11:SetType(EFFECT_TYPE_QUICK_O) 
	e11:SetCode(EVENT_FREE_CHAIN) 
	e11:SetHintTiming(0,TIMING_END_PHASE)
	e11:SetRange(LOCATION_SZONE) 
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetCountLimit(1,9879396)
	e11:SetTarget(c9879396.sptg1)
	e11:SetOperation(c9879396.spop1)
	c:RegisterEffect(e11)
	
	
	local e13=Effect.CreateEffect(c) 
	e13:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND) 
	e13:SetType(EFFECT_TYPE_IGNITION)  
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetRange(LOCATION_GRAVE) 
	e13:SetCountLimit(1,9879396) 
	e13:SetTarget(c9879396.dttg) 
	e13:SetOperation(c9879396.dtop) 
	c:RegisterEffect(e13) 
end
function c9879396.target(e,c)
	return c:GetCounter(0x107e)~=0
end
function c9879396.filter1(c,e,tp)
	return c:IsSetCard(0x27e3) and c:IsAbleToHand()
end
function c9879396.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsCanAddCounter(0x107e,1)  end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,0x107e,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,0x107e,1)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x107e)
end
function c9879396.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g1=Duel.GetMatchingGroup(c9879396.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:AddCounter(0x107e,1)  then   
	  if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9879396,0))  then
		local sg=g1:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		end 
	end
end

function c9879396.desfil(c) 
	return c:IsFaceup() and c:GetCounter(0x107e)>0 
end 
function c9879396.dttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c9879396.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsAbleToHand() end 
	local g=Duel.SelectTarget(tp,c9879396.desfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end 
function c9879396.dtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,c) 
	end 
end 