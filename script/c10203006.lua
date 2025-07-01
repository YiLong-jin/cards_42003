--玉莲帮幻术师
function c10203006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10203006,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10203006)
	e1:SetCondition(c10203006.chcon)
	e1:SetCost(c10203006.cost)
	e1:SetTarget(c10203006.chtg)
	e1:SetOperation(c10203006.chop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(c10203006.effcon)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
end
function c10203006.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE)
	or ((re:GetActiveType(TYPE_SPELL) or re:GetActiveType(TYPE_TRAP)) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c10203006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10203006.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c10203006.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	e:SetLabel(cg:GetCount())
end
function c10203006.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10203006.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
end
function c10203006.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c10203006.Banishment)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10203006.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c10203006.filters(c)
	return c:IsSetCard(0xe79e) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10203006.effcon(e)
	return Duel.GetMatchingGroupCount(c10203006.filters,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>1
end
--
function c10203006.spfilter(c,e,tp)
	return c:IsCode(10203001) and 
	c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10203006.Banishment(e,tp,eg,ep,ev,re,r,rp)
--
	Duel.Recover(1-tp,1000,REASON_EFFECT)
end