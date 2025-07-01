--先古守护者·凯尔希
function c73116907.initial_effect(c)
	aux.EnableChangeCode(c,73116915,LOCATION_MZONE+LOCATION_GRAVE)
	c:SetUniqueOnField(1,0,73116907)
----------------------------------------------------------------------------------------------------------------------------------------
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,73116915,73116906,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemove,LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_SPSUMMON)
	local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(73116905,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_DRAW_PHASE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,83116907)
	e1:SetCondition(c73116907.rmcon)
	e1:SetTarget(c73116907.thtg1)
	e1:SetOperation(c73116907.thop1)
	c:RegisterEffect(e1)
----------------------------------------------------------------------------------------------------------------------------------------
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD, 0)
	e2:SetTarget(c73116907.etarget)
	e2:SetValue(c73116907.setvalue)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
----------------------------------------------------------------------------------------------------------------------------------------




		--copy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(73116905,1))
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMING_END_PHASE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,83116907)
	e7:SetCost(c73116907.cost2)
	e7:SetCondition(c73116907.condition)
	e7:SetTarget(c73116907.cptg)
	e7:SetOperation(c73116907.cpop)
	c:RegisterEffect(e7)
	
	
	
	
end

function c73116907.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c73116907.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c73116907.cpfilter(c)
	return  c:IsSetCard(0x8ac) and c:IsAbleToRemoveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c73116907.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c73116907.cpfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c73116907.cpfilter,tp,LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c73116907.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end






----------------------------------------------------------------------------------------------------------------------------------------
function c73116907.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(73116907)==0
end
function c73116907.thfilter1(c)
	return c:IsSetCard(0x8ac) and c:IsAbleToHand()
end
function c73116907.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73116907.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c73116907.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c73116907.thfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(73116907,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c73116907.etarget(e, c)
	return c:IsCode(73116915) and c:IsFaceup() and e:GetHandler():IsFaceup()
end