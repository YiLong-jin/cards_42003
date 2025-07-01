--古代的机械砦城
function c71100401.initial_effect(c)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71100401,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c71100401.ntcon)
	e2:SetTarget(c71100401.nttg)
	c:RegisterEffect(e2)
   --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(71100401,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCost(c71100401.cost)
	e3:SetCondition(c71100401.spcon)
	e3:SetTarget(c71100401.sptg)
	e3:SetOperation(c71100401.spop)
	c:RegisterEffect(e3)
 --special summon2
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetDescription(aux.Stringid(71100401,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCost(c71100401.cost)
	e4:SetCondition(c71100401.spcon2)
	e4:SetTarget(c71100401.sptg)
	e4:SetOperation(c71100401.spop)
	c:RegisterEffect(e4)
end
function c71100401.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c71100401.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x7)
end
function c71100401.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71100401)==0 end
	Duel.RegisterFlagEffect(tp,71100401,RESET_CHAIN,0,1)
end
function c71100401.spcon(e,tp,eg,ep,ev,re,r,rp)
	  return e:GetHandler():IsPreviousLocation(LOCATION_FZONE)
end
function c71100401.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71100401.spfilter,1,nil)
end
function c71100401.spfilter(c)
	return c:IsCode(37694547) and c:IsPreviousLocation(LOCATION_FZONE)
end
function c71100401.filter(c,e,tp)
	return c:IsSetCard(0x7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71100401.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c71100401.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c71100401.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetActivateLocation()==LOCATION_FZONE and not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c71100401.filter),tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end
