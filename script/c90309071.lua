--幸运魔人 伪装者
function c90309071.initial_effect(c)
--link summon
	aux.AddLinkProcedure(c,c90309071.mfilter,1)
	c:EnableReviveLimit()
--special summon	
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90309071,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,90309071)
	e1:SetCost(c90309071.cost)
	e1:SetTarget(c90309071.target)
	e1:SetOperation(c90309071.activate)
	c:RegisterEffect(e1)
end
c90309071.toss_dice=true
function c90309071.mfilter(c)
	return c:IsLevelBelow(6) and c:IsLinkSetCard(0x973)
end
function c90309071.cfilter(c,e,tp)
	return c:IsDiscardable()
		
end
function c90309071.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x973) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90309071.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.IsExistingMatchingCard(c90309071.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c90309071.cfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c90309071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local res=e:GetLabel()==100
		e:SetLabel(0)
		return res or Duel.IsExistingMatchingCard(c90309071.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,6)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90309071.fselect(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function c90309071.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	local res=false
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 then
		if ft>1 then ft=1 end
		local g=Duel.GetMatchingGroup(c90309071.spfilter,tp,LOCATION_DECK,0,nil,e,tp,dc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c90309071.fselect,false,1,1,dc)
		if sg then
			for tc in aux.Next(sg) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.SpecialSummonComplete()
			res=true
		end
	end
end