--黑骑士小队-湮灭
function c9877631.initial_effect(c)
	 aux.AddLinkProcedure(c,nil,2,99,c9877631.lcheck)
	c:EnableReviveLimit()  

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9877631,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9877631)
	e3:SetCost(c9877631.cost1)
	e3:SetCondition(c9877631.spcon1)
	e3:SetTarget(c9877631.destg)
	e3:SetOperation(c9877631.desop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c9877631.spcon2)
	c:RegisterEffect(e4)
	
end
function c9877631.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,9877612)
end
function c9877631.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,9877612)
end

function c9877631.lcheck(g,lc)
	return g:IsExists(c9877631.mzfilter,1,nil)
end
function c9877631.mzfilter(c)
	return c:IsLinkSetCard(0x17ec)
end



function c9877631.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500)
	else Duel.PayLPCost(tp,1500) end
end
function c9877631.desfilter1(c)
	return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c9877631.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chk==0 then return Duel.IsExistingMatchingCard(c9877631.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c9877631.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c9877631.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	if  Duel.Destroy(g1,REASON_EFFECT)~=0 and Duel.CheckLPCost(tp,1500) and Duel.SelectYesNo(tp,aux.Stringid(9877631,0)) then
			Duel.PayLPCost(tp,1500)
			local e11=Effect.CreateEffect(c) 
			e11:SetType(EFFECT_TYPE_SINGLE) 
			e11:SetCode(EFFECT_UPDATE_ATTACK)  
			e11:SetRange(LOCATION_MZONE) 
			e11:SetValue(1500) 
			e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
			c:RegisterEffect(e11) 
	end
end
