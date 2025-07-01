--究极宝玉神 亚虹龙
function c10700344.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10700344+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10700344.spcon)
	c:RegisterEffect(e1) 
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10700344.atkval)
	c:RegisterEffect(e2)  
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700344,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c10700344.settg)
	e3:SetOperation(c10700344.setop)
	c:RegisterEffect(e3)  
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10700344,1))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0x3c0)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c10700344.tdcost)
	e4:SetTarget(c10700344.tdtg)
	e4:SetOperation(c10700344.tdop)
	c:RegisterEffect(e4)
end
function c10700344.spfilter(c)
	return c:IsSetCard(0x1034) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c10700344.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c10700344.spfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c10700344.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,3,nil) and g:GetClassCount(Card.GetCode)>2
end
function c10700344.atkfilter(c)
	return c:IsSetCard(0x1034) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c10700344.atkval(e,c)
	return Duel.GetMatchingGroup(c10700344.atkfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD,0,nil):GetClassCount(Card.GetCode)*500
end
function c10700344.setfilter(c)
	return c:IsSetCard(0x34,0x187) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10700344.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10700344.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10700344,0))
end
function c10700344.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10700344.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local dc=g:GetFirst()
	if g:GetCount()>0 then
	   if Duel.SSet(tp,dc)==0 then return end
	   if dc:IsType(TYPE_QUICKPLAY) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetDescription(aux.Stringid(10700344,2))
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		   e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   dc:RegisterEffect(e1)
	   end
	   if dc:IsType(TYPE_TRAP) then
		   local e1=Effect.CreateEffect(c)
		   e1:SetDescription(aux.Stringid(10700344,2))
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   dc:RegisterEffect(e1)
	   end
	end
end
function c10700344.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c10700344.cfilter(c)
	return c:IsSetCard(0x34) and c:IsAbleToGraveAsCost()
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c10700344.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10700344.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) and dg:GetCount()>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c10700344.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,dg:GetCount(),nil)
	e:SetLabel(0,cg:GetCount())
	Duel.SendtoGrave(cg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,cg:GetCount(),0,0)
end
function c10700344.tdop(e,tp,eg,ep,ev,re,r,rp)
	local label,count=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,count,count,nil)
	if g:GetCount()==count then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end