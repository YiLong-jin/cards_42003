--交响曲·弄臣
function c69969289.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),7,2)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(69969289,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,69969289)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c69969289.cost)
	e1:SetTarget(c69969289.target)
	e1:SetOperation(c69969289.operation)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetDescription(aux.Stringid(69969289,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_SSET+TIMING_EQUIP+TIMING_END_PHASE)
	e5:SetCountLimit(1,69969289)
	e5:SetCondition(c69969289.rmcon2)
	c:RegisterEffect(e5)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c69969289.tgcon)
	c:RegisterEffect(e3)
end
function c69969289.rmfilter(c,tp)
	return c:GetOwner()==1-tp and c:IsType(TYPE_MONSTER)
end
function c69969289.rmcon2(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsExistingMatchingCard(c69969289.rmfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	end
function c69969289.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69969289.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c69969289.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	if	Duel.GetControl(tc,tp)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetCountLimit(1)
			e2:SetLabel(1000)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetOperation(c69969289.cdamop)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c69969289.cdamop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,e:GetLabel(),REASON_EFFECT)
end
--2
function c69969289.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
	end
	
	
	
	