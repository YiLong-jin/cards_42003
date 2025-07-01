--灰篮海德拉
function c10701283.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_AQUA),aux.NonTuner(nil),2)
	c:EnableReviveLimit()  
	--lv change
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SYNCHRO_LEVEL)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetTarget(c10701283.lvtg)
	e0:SetValue(c10701283.lvval)
	c:RegisterEffect(e0)  
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701283,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10701283)
	e1:SetCondition(c10701283.chcon)
	e1:SetTarget(c10701283.chtg)
	e1:SetOperation(c10701283.chop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10701283,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,10701284)
	e4:SetCondition(c10701283.spcon)
	e4:SetTarget(c10701283.sptg)
	e4:SetOperation(c10701283.spop)
	c:RegisterEffect(e4) 
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10701283,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,10701284)
	e5:SetCondition(c10701283.spcon2)
	e5:SetTarget(c10701283.sptg)
	e5:SetOperation(c10701283.spop)
	c:RegisterEffect(e5)
end
function c10701283.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetOwner()~=e:GetHandlerPlayer()
end
function c10701283.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 3
	else return lv end
end
function c10701283.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:IsActiveType(TYPE_MONSTER)
		or (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c10701283.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,rp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil,REASON_EFFECT) end
end
function c10701283.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c10701283.repop)
end
function c10701283.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(1-tp,nil,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
	if #g1==0 then return end
	Duel.HintSelection(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end
function c10701283.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c10701283.filter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsPreviousControler(tp)
end
function c10701283.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701283.filter,1,nil,tp)
end
function c10701283.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701283.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c10701283.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10701283.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701283.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end