--变形斗士·冷冻柜
function c10701274.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c10701274.spcon)
	e1:SetOperation(c10701274.spop)
	e1:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e1)	 
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_SZONE)
	e2:SetCondition(c10701274.cona)
	e2:SetTarget(c10701274.tga)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69248256,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetCondition(c10701274.cond)
	e3:SetTarget(c10701274.tgd)
	e3:SetOperation(c10701274.opd)
	c:RegisterEffect(e3)
end
function c10701274.spfilter(c)
	return c:IsSetCard(0x26) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10701274.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701274.spfilter,tp,LOCATION_DECK,0,1,e:GetHandler())
end
function c10701274.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10701274.spfilter,tp,LOCATION_DECK,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10701274.cona(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and e:GetHandler():IsAttackPos()
end
function c10701274.actfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x26) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c10701274.tga(e,c)
	local face=c:GetColumnGroup()
	return face:IsExists(c10701274.actfilter,1,nil,e:GetHandlerPlayer()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c10701274.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c10701274.imfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x26) or c:IsSetCard(0xc2))
end
function c10701274.tgd(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c10701274.imfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c10701274.imfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10701274.imfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c10701274.opd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e)
		and not tc:IsImmuneToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c10701274.rcon)
		e1:SetValue(c10701274.efilter)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
	end
end
function c10701274.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c10701274.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end