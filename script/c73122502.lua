--命运
function c73122502.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c73122502.target)
	e1:SetOperation(c73122502.activate)
	c:RegisterEffect(e1)
end

function c73122502.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function c73122502.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c73122502.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c73122502.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c73122502.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c73122502.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local b1=Duel.Destroy(tc,REASON_EFFECT)
		if b1==0 then
			if Duel.SelectYesNo(tp,aux.Stringid(73122502,0)) then
				local b2=Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
				if b2==0 then
					if Duel.SelectYesNo(tp,aux.Stringid(73122502,1)) then
						local b3=Duel.SendtoGrave(tc,REASON_EFFECT)
						if b3==0 then
							Duel.SendtoDeck(tc,1-tp,SEQ_DECKSHUFFLE,REASON_RULE)
						end
					end
				end
			end
		end
	end
end