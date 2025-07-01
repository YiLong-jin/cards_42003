--居家之刃 村正
function c9877747.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9877747,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,9877747)
	e1:SetCondition(c9877747.spcon)
	e1:SetTarget(c9877747.sptg1)
	e1:SetOperation(c9877747.spop1)
	c:RegisterEffect(e1) 


	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)

	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_EQUIP)
	e13:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e13:SetValue(1)
	c:RegisterEffect(e13)

	 local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1877747)
	e3:SetCondition(c9877747.eqcon)
	e3:SetTarget(c9877747.sptg)
	e3:SetOperation(c9877747.spop)
	c:RegisterEffect(e3)
	
end
function c9877747.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x27eb) or (c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE)))
end
function c9877747.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9877747.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9877747.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9877747.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 



function c9877747.eqcon(e)
	return e:GetHandler():GetEquipTarget()
end
function c9877747.spfilter(c,e,tp)
	return (c:IsSetCard(0x27eb) or (c:IsLevel(2) and c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE))) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877747.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9877747.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE) 
end
function c9877747.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9877747.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end