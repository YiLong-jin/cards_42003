--天浮神社
function c9875590.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_BEAST))
	e2:SetValue(100)
	c:RegisterEffect(e2)

	 local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9875590)
	e3:SetTarget(c9875590.rectg)
	e3:SetOperation(c9875590.recop)
	c:RegisterEffect(e3)

	 local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9875590,1))
	e4:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_RECOVER)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(3,1875590)
	e4:SetCondition(c9875590.thcon)
	e4:SetTarget(c9875590.thtg)
	e4:SetOperation(c9875590.thop)
	c:RegisterEffect(e4)
end
function c9875590.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c9875590.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

function c9875590.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function c9875590.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9875590)==0 end
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) then
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,200)
	end
	Duel.RegisterFlagEffect(tp,9875590,RESET_CHAIN,0,1)
end
function c9875590.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) then
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil) 
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	else 
		Duel.Damage(1-tp,200,REASON_EFFECT)
	end
end
