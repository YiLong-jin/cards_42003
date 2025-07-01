--蜃缚的孤傲 昂珀尔哈
local m=99910140
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)


	--negate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_ATKCHANGE)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,m)
	e0:SetCondition(cm.discon)
	e0:SetTarget(cm.distg)
	e0:SetOperation(cm.disop)
	c:RegisterEffect(e0)
	--To Hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m+1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	--c:RegisterEffect(e1) 
	local e4=e1:Clone()
	e4:SetCode(EVENT_TO_DECK)
	e4:SetCondition(cm.atkcon)
	c:RegisterEffect(e4)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x167a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end














function cm.filter11(c)
	return c:IsSetCard(0x167a) and c:IsType(TYPE_PENDULUM)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter11,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
		local g=Duel.SelectMatchingCard(tp,cm.filter11,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
end


