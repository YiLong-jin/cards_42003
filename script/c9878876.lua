--银月鬼杀大式神-八岐大蛇
local cm,m=GetID()
function c9878876.initial_effect(c)
	aux.AddCodeList(c,9877864)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.cck,aux.NonTuner(cm.cck),1,1)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)


	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9878876,1))
	e12:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,9878876)
	e12:SetCondition(c9878876.discon) 
	e12:SetTarget(c9878876.distg)
	e12:SetOperation(c9878876.disop)
	c:RegisterEffect(e12) 

	
	local e22=Effect.CreateEffect(c)
	e22:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e22:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e22:SetCode(EVENT_DESTROYED)
	e22:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e22:SetCountLimit(1,1878876) 
	e22:SetTarget(c9878876.sptg)
	e22:SetOperation(c9878876.spop)
	c:RegisterEffect(e22) 
end
function cm.cck(c)
	return aux.IsCodeListed(c,9877864)
end


function c9878876.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end 
function c9878876.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9878876.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end 


function c9878876.spfilter(c,e,tp)
	return c:IsCode(9877864) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9878876.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9878876.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end 
function c9878876.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9878876.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end 
end