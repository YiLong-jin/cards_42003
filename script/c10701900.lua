--寄生羽虫
function c10701900.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,10701896)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,1)
	e1:SetCondition(c10701900.spcon)
	e1:SetOperation(c10701900.spop)
	c:RegisterEffect(e1) 
	--race  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0) 
	e2:SetCondition(c10701900.racecon)
	e2:SetValue(RACE_INSECT)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701900,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c10701900.spcon2)
	e3:SetTarget(c10701900.sptg2)
	e3:SetOperation(c10701900.spop2)
	c:RegisterEffect(e3)
end
function c10701900.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonCount(tp,1)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10701901,0,TYPES_TOKEN_MONSTER,100,100,1,RACE_INSECT,ATTRIBUTE_EARTH,POS_FACEUP_ATTACK)
end
function c10701900.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local token=Duel.CreateToken(tp,10701901)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) 
	Duel.SpecialSummonComplete()
end
function c10701900.racefilter(c)
	return c:IsFaceup() and c:IsCode(10701896) 
end
function c10701900.racecon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c10701900.racefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c10701900.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function c10701900.spfilter2(c,e,tp,sump)
	return c:IsCode(10701902) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,sump)
end
function c10701900.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c10701900.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,tp)
		local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 
			and Duel.IsExistingMatchingCard(c10701900.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,1-tp)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c10701900.spop2(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c10701900.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,tp)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 
		and Duel.IsExistingMatchingCard(c10701900.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,1-tp)
	if not (b1 or b2) then return end   
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(10701900,2),aux.Stringid(10701900,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(10701900,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(10701900,3))+1
	end
	local target_player=tp
	if op==1 then target_player=1-tp end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701900.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,target_player)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,target_player,false,false,POS_FACEUP)
	end
end