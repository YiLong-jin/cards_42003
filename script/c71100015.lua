--菌兽首骸·狄密特
local m=71100015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--level down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.ldcon)
	e3:SetCost(cm.ldcost)
	e3:SetTarget(cm.ldtg)
	e3:SetOperation(cm.ldop)
	c:RegisterEffect(e3)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x7d1)
end
function cm.spcostfilter(c,e)
	return c:IsAbleToRemoveAsCost() and c~=e:GetHandler()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spcostfilter,tp,LOCATION_GRAVE,0,2,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spcostfilter,tp,LOCATION_GRAVE,0,2,2,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_GRAVE) and not c:IsHasEffect(EFFECT_NECRO_VALLEY))) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.ldcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLevel()>1
end
function cm.ldcostfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsSetCard(0x7d0) or c:IsSetCard(0x7d1))
end
function cm.ldcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ldcostfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local lv=e:GetHandler():GetLevel()
	local g=Duel.SelectMatchingCard(tp,cm.ldcostfilter,tp,LOCATION_GRAVE,0,1,lv-1,nil)
	local cost=Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(cost)
end
function cm.ldtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():GetLevel()>1 end
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,e:GetHandler(),0,0,0)
end
function cm.ldop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local cost=e:GetLabel()
	if cost<1 or lv<2 or c:IsFacedown() or c:IsImmuneToEffect(e) or not c:IsLocation(LOCATION_MZONE) then return end
	if cost>=lv then cost=lv-1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(-cost)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end












