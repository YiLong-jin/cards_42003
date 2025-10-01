--薇特莉斯甜点工坊-蜜桃
function c9877348.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c9877348.mfilter,c9877348.xyzcheck,3,3)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(c9877348.etarget)
	e2:SetValue(c9877348.efilter)
	c:RegisterEffect(e2) 

	local e11=Effect.CreateEffect(c) 
	e11:SetCategory(CATEGORY_TOHAND)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_MZONE)
	e11:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e11:SetCountLimit(1,9877348)
	e11:SetCost(c9877348.spcost)
	e11:SetTarget(c9877348.thtg) 
	e11:SetOperation(c9877348.thop)  
	c:RegisterEffect(e11)

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9877348,1))
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetCost(aux.bfgcost)
	e12:SetTarget(c9877348.sptg2)
	e12:SetOperation(c9877348.spop2)
	c:RegisterEffect(e12)
end

function c9877348.etarget(e,c)
	return c:IsSetCard(0x17e4) and c:IsFaceup()
end
function c9877348.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_LINK) and re:IsActivated()
end
function c9877348.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ) and c:IsSetCard(0x17e4)
end
function c9877348.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1
end


function c9877348.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c9877348.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c9877348.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	end   
end 


function c9877348.spfilter2(c,e,tp)
	return c:IsSetCard(0x17e4) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9877348.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9877348.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9877348.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9877348.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end