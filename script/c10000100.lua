--大刀直刺
function c10000100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10000100)
	e1:SetTarget(c10000100.target)
	e1:SetOperation(c10000100.activate)
	c:RegisterEffect(e1)	
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10000100,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,20000100)
	e2:SetCost(c10000100.setcost)
	e2:SetTarget(c10000100.settg)
	e2:SetOperation(c10000100.setop)
	c:RegisterEffect(e2)
end 
function c10000100.spfilter(c,e,tp) 
	return c:IsCode(10000135) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c10000100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10000100.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10000100.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10000100.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c10000100.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp) 
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c10000100.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
end
function c10000100.splimit(e,c)
	return not c:IsSetCard(0xa797) 
end
function c10000100.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) 
end 
function c10000100.stfilter(c)
	return c:IsSetCard(0xbdef) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c10000100.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10000100.stfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c10000100.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c10000100.stfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end



