--堕香莉莉丝·迷迭香
function c9879080.initial_effect(c)
	 aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),8,2)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c9879080.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9879080.spcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e3)


	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(9879080,0))
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1,9879080) 
	e4:SetCost(c9879080.spcost1) 
	e4:SetTarget(c9879080.pltg) 
	e4:SetOperation(c9879080.plop) 
	c:RegisterEffect(e4) 

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9879080,1))
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetHintTiming(0,TIMING_END_PHASE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,9879080)
	e13:SetCost(c9879080.spcost)
	e13:SetCondition(c9879080.spcon)
	e13:SetTarget(c9879080.sptg)
	e13:SetOperation(c9879080.spop)
	c:RegisterEffect(e13)
	
end
function c9879080.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end


function c9879080.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c9879080.plfil(c) 
	return (c:IsCode(28265983) or c:IsCode(9879085)) and not c:IsForbidden()  
end 
function c9879080.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879080.plfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end   
end 
function c9879080.plop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c9879080.plfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) 
	end 
end 


function c9879080.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9879080.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9879080.spfilter(c,e,tp,mc)
	return (c:IsSetCard(0x17ea) or c:IsSetCard(0xc9)) and c:IsType(TYPE_MONSTER) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 and not c:IsCode(9879080)
end
function c9879080.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879080.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9879080.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9879080.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end