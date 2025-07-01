--交响曲·海
function c69969254.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x69b),2)
	c:EnableReviveLimit()
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c69969254.atkop)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969254,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,69969254)
	e3:SetTarget(c69969254.seqtg)
	e3:SetOperation(c69969254.seqop)
	c:RegisterEffect(e3)
local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969254,2))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,69969243)
	e4:SetTarget(c69969254.eqtg)
	e4:SetOperation(c69969254.eqop)
	c:RegisterEffect(e4)
local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c69969254.tdcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c69969254.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if  re:GetHandler()~=c and re:IsActiveType(TYPE_MONSTER+TYPE_TRAP+TYPE_SPELL) and c:GetFlagEffect(1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
--2
function c69969254.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackAbove(3000)
end
function c69969254.seqfilter(c)
	local tp=c:GetControler()
	return  Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0
end
function c69969254.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c69969254.seqfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c69969254.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(69969254,1))
	Duel.SelectTarget(tp,c69969254.seqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
end
function c69969254.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ttp=tc:GetControler()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e)
		or Duel.GetLocationCount(ttp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	local p1,p2
	if tc:IsControler(tp) then
		p1=LOCATION_MZONE
		p2=0
	else
		p1=0
		p2=LOCATION_MZONE
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=math.log(Duel.SelectDisableField(tp,1,p1,p2,0),2)
	if tc:IsControler(1-tp) then seq=seq-16 end
	Duel.MoveSequence(tc,seq)
end
--3
function c69969254.tgfilter(c,lg)
	return lg:IsContains(c) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c69969254.eqfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c69969254.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c69969254.tgfilter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c69969254.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) and Duel.IsExistingMatchingCard(c69969254.eqfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c69969254.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
end
function c69969254.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local exc=nil 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then 
	if tc:IsRelateToEffect(e) then exc=tc end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c69969254.eqfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,exc)
		local ec=g:GetFirst()
		if ec then
			if not Duel.Equip(tp,ec,tc) then return end
			--equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabelObject(tc)
			e1:SetValue(c69969254.eqlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
end
function c69969254.eqlimit(e,c)
	return c==e:GetLabelObject()
end
