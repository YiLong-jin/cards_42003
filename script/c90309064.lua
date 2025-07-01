--幸运魔人1
function c90309064.initial_effect(c)
--special summon	
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90309064,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c90309064.cost)
	e1:SetTarget(c90309064.target)
	e1:SetOperation(c90309064.activate)
	c:RegisterEffect(e1)
--return
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(90309064,2))
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCondition(c90309064.retcon)
	e7:SetTarget(c90309064.rettg)
	e7:SetOperation(c90309064.retop)
	c:RegisterEffect(e7)
	if not c90309064.global_check then
		c90309064.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(90309064)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
	end
end
c90309064.toss_dice=true
function c90309064.cfilter(c,e,tp)
	return c:IsDiscardable()	 
end
function c90309064.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x973) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90309064.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c90309064.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c90309064.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c90309064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==100
		e:SetLabel(0)
		return res or Duel.IsExistingMatchingCard(c90309064.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,6)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90309064.fselect(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function c90309064.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	local res=false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		if ft>1 then ft=1 end
		local g=Duel.GetMatchingGroup(c90309064.spfilter,tp,LOCATION_DECK,0,nil,e,tp,dc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c90309064.fselect,false,1,1,dc)
		if sg then
			for tc in aux.Next(sg) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
			res=true
		end
	end
end
function c90309064.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(90309064)~=0
end
function c90309064.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c90309064.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end