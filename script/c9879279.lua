--鲑鱼子九霄
function c9879279.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,9879202) 

	local e1=aux.AddRitualProcGreater2(c,c9879279.filter,LOCATION_HAND+LOCATION_GRAVE,nil,c9879279.matfilter,true)
	e1:SetDescription(aux.Stringid(9879279,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9879279)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9879279,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9879279.spcon)
	e2:SetTarget(c9879279.sptg)
	e2:SetOperation(c9879279.spop)
	c:RegisterEffect(e2)

	
	  local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,1875665)
	e3:SetTarget(c9879279.target)
	e3:SetOperation(c9879279.operation)
	c:RegisterEffect(e3)
	
end
function c9879279.filter(c,e,tp,chk)
	return aux.IsCodeListed(c,9879202) and (not chk or c~=e:GetHandler())
end
function c9879279.matfilter(c,e,tp,chk)
	return not chk or c~=e:GetHandler()
end


function c9879279.filter(c)
	return c:IsSetCard(0x1661) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c9879279.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879279.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c9879279.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9879279.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>=0 then 
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function c9879279.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c9879279.spfilter(c,e,tp)
	return  ((c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT))and c:GetAttack()==c:GetDefense()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(9879279)
end
function c9879279.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9879279.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9879279.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879279.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
