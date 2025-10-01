--太阳花田的演奏舞台
c40802020.RR_ZXESZ=true
function c40802020.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,40802020+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c40802020.activate)
	c:RegisterEffect(e1) 

	
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e11:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e11:SetTargetRange(LOCATION_SZONE,0)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCountLimit(1)
	e11:SetCondition(c40802020.actcon)
	e11:SetTarget(c40802020.acttg)
	c:RegisterEffect(e11)
	local e14=e11:Clone()
	e14:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	c:RegisterEffect(e14)
	
end
function c40802020.filter(c)
	return c.RR_ZXESZ and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c40802020.actcon(e)
	return Duel.IsExistingMatchingCard(c40802020.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c40802020.acttg(e,c)
	return c.RR_ZXESZ 
end


function c40802020.thfilter(c)
	return c.RR_ZXESZ and c:IsAbleToHand()
end
function c40802020.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40802020.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40802020,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end