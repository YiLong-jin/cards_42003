--彩羽·莎奈-睡衣派对
function c9878770.initial_effect(c)
	aux.AddCodeList(c,9877913)
	aux.AddLinkProcedure(c,c9878770.lfcheck,2,99)
	c:EnableReviveLimit()
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878770,0))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9878770)
	e2:SetTarget(c9878770.sttg)
	e2:SetOperation(c9878770.stop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1,1878770)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c9878770.rectg)
	e3:SetOperation(c9878770.recop)
	c:RegisterEffect(e3)
	
end
function c9878770.lfcheck(c)
	return aux.IsCodeListed(c,9877913)
end


function c9878770.stfilter(c)
	return aux.IsCodeListed(c,9877913) and c:GetType(TYPE_TRAP) and c:IsSSetable()
end
function c9878770.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9878770.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878770.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9878770.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c9878770.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)then
		Duel.SSet(tp,tc)
	end
end

function c9878770.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c9878770.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end