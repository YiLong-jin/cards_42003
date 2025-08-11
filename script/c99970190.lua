--yume no sinsei！
local m=99970190
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
		--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.xyztg)
	e1:SetOperation(cm.xyzop)
	c:RegisterEffect(e1)
	
		--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon1)
	e2:SetTarget(cm.sptg1)
	e2:SetOperation(cm.spop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e3)
end

function cm.cfilter(c)
	return c:IsFaceup() and c:IsAttack(1500) and c:IsDefense(1500) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local c=e:GetHandler()
		local fl=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) 
		if c:IsLocation(LOCATION_EXTRA) then
			return fl and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		else
			return fl and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local fl=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) 
		if c:IsLocation(LOCATION_EXTRA) then
			fl=fl and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		else
			fl=fl and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
		if fl then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end









-----------------------------------------------------------------------------
function cm.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
end

function c99970190.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c99970190.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c99970190.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970190.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c99970190.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99970190.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

