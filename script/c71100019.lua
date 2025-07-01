--菌兽肋骸·伊西斯
local m=71100019
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
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x7d1)
end
function cm.spfilter(c)
	return c:IsSetCard(0x7d1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.mfilter(c,e,syc)
	local mg=Group.__add(c,e:GetHandler())
	return syc:IsSynchroSummonable(nil,mg)
end
function cm.synfilter(syc,e,tp)
	return syc:IsAttribute(ATTRIBUTE_LIGHT) and syc:IsRace(RACE_FIEND) and Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,syc)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then return end
	local g=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if c:IsFaceup() and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mg=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_MZONE,0,1,1,c,e,sg:GetFirst())
		Group.AddCard(mg,c)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end

















