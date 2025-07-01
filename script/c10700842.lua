--逆辉龙刃 百炼钢
function c10700842.initial_effect(c)
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),4,3,nil,nil,99)
	c:EnableReviveLimit()  
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700842,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c10700842.atkcost)
	e1:SetOperation(c10700842.atkop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700842,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c10700842.descon)
	e2:SetTarget(c10700842.destg)
	e2:SetOperation(c10700842.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10700842.descon2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10700842.descon2)
	c:RegisterEffect(e4) 
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10700842,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c10700842.setcon)
	e5:SetTarget(c10700842.settg)
	e5:SetOperation(c10700842.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c10700842.setcon2)
	c:RegisterEffect(e4)
	local e7=e5:Clone()
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c10700842.setcon2)
	c:RegisterEffect(e7) 
	--atk up
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetCondition(c10700842.atkcon)
	e8:SetTarget(c10700842.atktg2)
	e8:SetValue(500)
	c:RegisterEffect(e8) 
	local e9=e8:Clone()  
	e9:SetCondition(c10700842.atkcon)
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e9)
	--indes
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(LOCATION_MZONE,0)
	e10:SetCondition(c10700842.atkcon)
	e10:SetTarget(c10700842.atktg2)
	e10:SetValue(1)
	c:RegisterEffect(e10)
	--tograve
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(10700842,3))
	e11:SetCategory(CATEGORY_TOGRAVE)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e11:SetCountLimit(1)
	e11:SetCondition(c10700842.tgcon)
	e11:SetTarget(c10700842.tgtg)
	e11:SetOperation(c10700842.tgop)
	c:RegisterEffect(e11) 
	--Remove
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(10700842,4))
	e12:SetCategory(CATEGORY_REMOVE)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e12:SetCondition(c10700842.rmcon)
	e12:SetTarget(c10700842.rmtg)
	e12:SetOperation(c10700842.rmop)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCondition(c10700842.rmcon2)
	c:RegisterEffect(e13)
	local e14=e12:Clone()
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e14:SetCode(EVENT_SUMMON_SUCCESS)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCondition(c10700842.rmcon2)
	c:RegisterEffect(e14) 
	--cannot be target/effect indestructable
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e15:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e15:SetRange(LOCATION_MZONE)
	e15:SetCondition(c10700842.iecon)
	e15:SetValue(1)
	c:RegisterEffect(e15)
	local e16=e15:Clone()
	e16:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e16)  
	--pierce
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetCode(EFFECT_PIERCE)
	e17:SetCondition(c10700842.iecon)
	c:RegisterEffect(e17)
	--can not be effect target
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_FIELD)
	e18:SetCode(EFFECT_DISABLE)
	e18:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e18:SetCondition(c10700842.ddcon)
	e18:SetTarget(c10700842.ettg)
	c:RegisterEffect(e18)   
	--destroy
	local e19=Effect.CreateEffect(c)
	e19:SetDescription(aux.Stringid(10700854,0))
	e19:SetCategory(CATEGORY_DESTROY)
	e19:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e19:SetType(EFFECT_TYPE_IGNITION)
	e19:SetRange(LOCATION_MZONE)
	e19:SetCondition(c10700842.ddcon)
	e19:SetCost(c10700842.descost2)
	e19:SetTarget(c10700842.destg2)
	e19:SetOperation(c10700842.desop2)
	c:RegisterEffect(e19)   
end
function c10700842.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=c:GetOverlayCount()
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function c10700842.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
end
function c10700842.drcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c10700842.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
	if ct>=2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c10700842.efilter)
		c:RegisterEffect(e1)
	end
	if ct>=3 and Duel.SelectYesNo(tp,aux.Stringid(10700842,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c10700842.drcfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,c)
		local tc=g:GetFirst()
		if tc then
		  local og=tc:GetOverlayGroup()
		  if og:GetCount()>0 then
			  Duel.SendtoGrave(og,REASON_RULE)
		  end
		  Duel.Overlay(c,Group.FromCards(tc))
		end
	end
end
function c10700842.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10700842.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700836) 
end
function c10700842.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsLevel(4) and c:IsControler(tp)
end
function c10700842.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700836) and not eg:IsContains(e:GetHandler()) and eg:IsExists(c10700842.cfilter,1,nil,tp)
end
function c10700842.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10700842.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10700842.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700837) 
end
function c10700842.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700837) and not eg:IsContains(e:GetHandler()) and eg:IsExists(c10700842.cfilter,1,nil,tp)
end
function c10700842.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c10700842.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and c10700842.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10700842.setfilter,tp,0,LOCATION_SZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c10700842.setfilter,tp,0,LOCATION_SZONE,1,1,nil,tp)
end
function c10700842.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		 if tc:IsType(TYPE_PENDULUM) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then 
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		 elseif tc:IsLocation(LOCATION_GRAVE) then
			Duel.SSet(tp,tc)
		 elseif tc:IsLocation(LOCATION_SZONE) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		 elseif tc:IsLocation(LOCATION_FZONE) and tc:IsType(TYPE_FIELD) then
			Duel.SSet(tp,tc)
		 end
	end
end
function c10700842.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700838) 
end
function c10700842.atktg2(e,c)
	return c:IsRace(RACE_DRAGON)
end
function c10700842.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700839) 
end
function c10700842.tgfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToGrave()
end
function c10700842.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700842.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10700842.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10700842.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsRace(RACE_DRAGON) and tc:IsType(TYPE_NORMAL)
		and Duel.IsExistingMatchingCard(c10700842.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(10700839,2)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c10700842.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700840) 
end
function c10700842.rmcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700840) and not eg:IsContains(e:GetHandler()) and eg:IsExists(c10700842.cfilter,1,nil,tp)
end
function c10700842.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c10700842.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c10700842.iecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700853) 
end
function c10700842.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,10700854) 
end
function c10700842.etfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsLocation(LOCATION_MZONE)
end
function c10700842.ettg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c10700842.etfilter,1,nil,e:GetHandler())
end
function c10700842.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10700842.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10700842.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end