--核心列车 飓风崩坏
c9879219.hxlc=true
function c9879219.initial_effect(c)
	aux.AddXyzProcedure(c,c9879219.mfilter,10,2)
	c:EnableReviveLimit() 

	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e12:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_ONFIELD,0)
	e12:SetTarget(c9879219.indtg)
	e12:SetValue(aux.indoval)
	c:RegisterEffect(e12)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9879219,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,9879219)
	e3:SetCost(c9879219.cost)
	e3:SetTarget(c9879219.sptg)
	e3:SetOperation(c9879219.spop)
	c:RegisterEffect(e3)

end
function c9879219.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end 
function c9879219.indtg(e,c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsType(TYPE_XYZ)
end


function c9879219.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9879219.tgsfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end

function c9879219.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9879219.tgsfilter,tp,0x30,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x30)
end

function c9879219.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9879219.tgsfilter,tp,0x30,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end