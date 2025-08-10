--黑骑士小队-决灭
function c9877632.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,99,c9877632.lcheck)
	c:EnableReviveLimit()  

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877632,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877632)
	e3:SetCost(c9877632.cost1)
	e3:SetCondition(c9877632.spcon1)
	e3:SetTarget(c9877632.destg)
	e3:SetOperation(c9877632.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877632.spcon2)
	c:RegisterEffect(e4)

end
function c9877632.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877632.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877632.lcheck(g,lc)
	return g:IsExists(c9877632.mzfilter,1,nil)
end
function c9877632.mzfilter(c)
	return c:IsLinkSetCard(0x17ec)
end

function c9877632.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000)
	else Duel.PayLPCost(tp,1000) end
end
function c9877632.thfil(c,tp) 
	return c:IsAbleToHand() and c:IsFaceup()
end 
function c9877632.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingTarget(c9877632.thfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c9877632.thfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9877632.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,aux.Stringid(9877632,0))  then
		  Duel.PayLPCost(tp,500)
		  Duel.Recover(tp,tc:GetBaseAttack()+1000,REASON_EFFECT)
		end
	end
end
