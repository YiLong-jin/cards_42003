--二叶莎奈-原点觉醒
function c9877915.initial_effect(c)
	aux.AddCodeList(c,9877913) 
	aux.AddLinkProcedure(c,c9877915.lfcheck,2,99)
	c:EnableReviveLimit()


	aux.EnableChangeCode(c,9877913,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c9877915.chainop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9877915,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(2,9877915)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9877915.discon)
	e2:SetTarget(c9877915.distg)
	e2:SetOperation(c9877915.disop)
	c:RegisterEffect(e2)
	
end
function c9877915.lfcheck(c)
	return c:IsLinkRace(RACE_SPELLCASTER)
end
function c9877915.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetType()==TYPE_TRAP and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) and ep==tp then
		Duel.SetChainLimit(c9877915.chainlm)
	end
end
function c9877915.chainlm(e,rp,tp)
	return tp==rp or not e:IsActiveType(TYPE_MONSTER)
end


function c9877915.discfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
end
function c9877915.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c9877915.discfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c9877915.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9877915.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end