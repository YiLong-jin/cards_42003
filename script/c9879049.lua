--核心列车 粒子加速器
function c9879049.initial_effect(c)
	aux.AddCodeList(c,9879042)

	local e02=Effect.CreateEffect(c)  
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND)
	e02:SetCountLimit(1,9879049)
	e02:SetCondition(c9879049.spcon)
	e02:SetTarget(c9879049.sptg)
	e02:SetOperation(c9879049.spop)
	c:RegisterEffect(e02)  

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(9879049,1))
	e12:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_IGNITION)  
	e12:SetRange(LOCATION_MZONE) 
	e12:SetCountLimit(1,1879049)
	e12:SetTarget(c9879049.thtg1)
	e12:SetOperation(c9879049.thop1)
	c:RegisterEffect(e12)
end
function c9879049.f(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsLevel(10)
end
function c9879049.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9879049.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9879049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9879049.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end



function c9879049.ctilter1(c,e,tp)
	return  aux.IsCodeListed(c,9879042) and c:IsLevel(10) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9879049.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c9879049.thop1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   if Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c9879049.ctilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(9879042,2)) then
			local g=Duel.SelectMatchingCard(tp,c9879049.ctilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end