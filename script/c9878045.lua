--完美落幕 我们的童话
function c9878045.initial_effect(c)
	aux.AddCodeList(c,9878030,9877883)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878045,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE) 
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9878045+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9878045.condition1)
	e2:SetTarget(c9878045.negtg)
	e2:SetOperation(c9878045.negop)
	c:RegisterEffect(e2)

	 local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,1878045)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9878045.thtg)
	e2:SetOperation(c9878045.thop)
	c:RegisterEffect(e2)
end
function c9878045.filter11(c)
	return c:IsFaceup() and (aux.IsCodeListed(c,9878030) or aux.IsCodeListed(c,9877883)) and c:IsType(TYPE_FUSION)
end

function c9878045.condition1(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.IsExistingMatchingCard(c9878045.filter11,tp,LOCATION_MZONE,0,1,nil)
end

function c9878045.negtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_ONFIELD) 
end
function c9878045.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if tc then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end


function c9878045.thfilter(c)
	return (aux.IsCodeListed(c,9878030) or aux.IsCodeListed(c,9877883)) and c:IsAbleToHand()
end
function c9878045.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878045.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9878045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9878045.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end