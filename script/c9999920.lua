--恶象天启 蓬莱寺九霄
function c9999920.initial_effect(c)


	aux.AddXyzProcedure(c,c9999920.ovfilter1,nil,3,c9999920.ovfilter,aux.Stringid(9999920,0),4,c9999920.xyzop)
	c:EnableReviveLimit()




	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,9999920)
	e4:SetCondition(c9999920.spcon)
	e4:SetTarget(c9999920.settg)
	e4:SetOperation(c9999920.setop)
	c:RegisterEffect(e4)




	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9999921)
	e1:SetCost(c9999920.cost)
	e1:SetTarget(c9999920.sptg1)
	e1:SetOperation(c9999920.spop1)
	c:RegisterEffect(e1)



end
function c9999920.ovfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x669)
end
function c9999920.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x669) and c:IsLinkAbove(4)
end
function c9999920.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9999921)==0 end
	Duel.RegisterFlagEffect(tp,9999921,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c9999920.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c9999920.setfilter(c)
	return c:IsSetCard(0x669) and c:IsType(TYPE_SPELL) and c:IsSSetable() and not c:IsType(TYPE_QUICKPLAY) and not c:IsType(TYPE_CONTINUOUS)
end
function c9999920.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9999920.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9999920.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9999920.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local c=e:GetHandler()
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(9999920,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
end

function c9999920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c9999920.spfilter1(c,e,tp)
	return c:IsSetCard(0x669) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9999920.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9999920.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c9999920.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9999920.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


