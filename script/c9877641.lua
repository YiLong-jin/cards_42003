--黑骑士小队-乱闪
function c9877641.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c9877641.atkval)
	c:RegisterEffect(e5)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877641,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877641)
	e3:SetCost(c9877641.cost1)
	e3:SetCondition(c9877641.spcon1)
	e3:SetTarget(c9877641.destg)
	e3:SetOperation(c9877641.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877641.spcon2)
	c:RegisterEffect(e4)

end
function c9877641.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_ONFIELD,LOCATION_ONFIELD)*100
end

function c9877641.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877641.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877641.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,3500)
	else Duel.PayLPCost(tp,3500) end
end
function c9877641.setfilter(c)  
	return (c:IsCode(9877639) or c:IsCode(9877640)) and c:IsSSetable() 
end  
function c9877641.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9877641.setfilter,tp,LOCATION_DECK,0,1,nil) end  
end
function c9877641.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9877641.setfilter),tp,LOCATION_DECK,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc and Duel.SSet(tp,tc)~=0 and Duel.CheckLPCost(tp,1500) and Duel.SelectYesNo(tp,aux.Stringid(9877641,0)) then 
		Duel.PayLPCost(tp,1500)
	   if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end