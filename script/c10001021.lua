--粉蝶x闪蝶 妖艳之惑
function c10001021.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10001021,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10001021)
	e2:SetCondition(c10001021.rmcon)
	e2:SetTarget(c10001021.rmtg)
	e2:SetOperation(c10001021.rmop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10001021)
	e3:SetTarget(c10001021.reptg)
	e3:SetValue(c10001021.repval)
	e3:SetOperation(c10001021.repop)
	c:RegisterEffect(e3)
end
function c10001021.rmcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcde0)
end
function c10001021.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_TRAP+TYPE_MONSTER+TYPE_SPELL) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c10001021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_HAND,1,nil)
		and Duel.IsExistingMatchingCard(c10001021.rmcfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c10001021.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end
function c10001021.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcde0) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c10001021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c10001021.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c10001021.repval(e,c)
	return c10001021.repfilter(c,e:GetHandlerPlayer())
end
function c10001021.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end