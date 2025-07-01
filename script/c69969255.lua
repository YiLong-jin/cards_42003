--交响的四季茶会
function c69969255.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c69969255.ntarget)
	e1:SetOperation(c69969255.activate)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x669b))
	e2:SetValue(c69969255.val)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969255,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,69969255)
	e3:SetCost(c69969255.nacost)
	e3:SetTarget(c69969255.target)
	e3:SetOperation(c69969255.operation)
	c:RegisterEffect(e3)
end
function c69969255.ntarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x169b,3,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x169b)
end
function c69969255.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x169b,3)
	end
end
--2
function c69969255.val(e,c)
   return Duel.GetCounter(e:GetHandlerPlayer(),1,0,0x169b)*100 
end
--3
function c69969255.csfilter(c,tp)
 if not c:IsAbleToGraveAsCost() then return false end
   if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and c:IsLocation(LOCATION_MZONE) then return false end
	 if Duel.GetLocationCount(tp,LOCATION_SZONE)==0 and c:IsLocation(LOCATION_HAND) then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c69969255.exfilter,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c69969255.exfilter,tp,LOCATION_DECK,0,1,nil,false)
	end

end
function c69969255.nacost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c69969255.csfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c69969255.csfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c69969255.exfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c69969255.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969255.exfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		 end
end
function c69969255.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c69969255.exfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	end
end




