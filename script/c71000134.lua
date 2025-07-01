--废柴小红帽 要夜袭！
local m = 71000134
local cm = _G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2521011,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.settg)
	e1:SetOperation(cm.setop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39015,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
function cm.conf(c)
	return c:IsLevel(3) and c:IsRace(RACE_BEAST) and c:GetAttack()==c:GetDefense()
end
function cm.con(e)
	return Duel.IsExistingMatchingCard(cm.conf,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.setfilter(c,e,tp,mft,sft)
	return (sft>0 and c:IsSSetable(true) or mft>0 and c:IsCanChangePosition() and c:IsAbleToChangeControler())
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		return cm.con(e) and Duel.IsExistingMatchingCard(cm.setfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp,mft,sft)
	end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	if not cm.con(e) then return end
	local mft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.setfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp,mft,sft):GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.GetControl(tc,tp)
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	elseif tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
		Duel.ChangePosition(tc,POS_FACEDOWN)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		Duel.ChangePosition(tc,POS_FACEDOWN)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
	Duel.ConfirmCards(1-tp,tc)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.filter(c,e,tp)
	return c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.con(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not cm.con(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end