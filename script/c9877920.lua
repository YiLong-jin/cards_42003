--彩羽与黑江 合力一击
function c9877920.initial_effect(c)
	 aux.AddCodeList(c,9877873,9877918)

	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)   
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9877920+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9877920.condition)
	e1:SetTarget(c9877920.target)
	e1:SetOperation(c9877920.activate)
	c:RegisterEffect(e1)
end

function c9877920.filter1(c)
	return (aux.IsCodeListed(c,9877918) or aux.IsCodeListed(c,9877873) ) and c:IsFaceup()
end
function c9877920.filter2(c)
	return c:IsFaceup() and c:IsCode(9877873)
end
function c9877920.filter3(c)
	return c:IsFaceup() and c:IsCode(9877918)
end
function c9877920.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9877920.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c9877920.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c9877920.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c9877920.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9877920.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9877920.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c9877920.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
	  if Duel.IsExistingMatchingCard(c9877920.filter3,tp,LOCATION_MZONE,0,1,nil) then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c9877920.distg)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9877920.discon)
		e2:SetOperation(c9877920.disop)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	   end
	  if Duel.IsExistingMatchingCard(c9877920.filter2,tp,LOCATION_MZONE,0,1,nil) then
		  Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
function c9877920.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function c9877920.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9877920.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end