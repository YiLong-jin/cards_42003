--附赠的G
function c10701374.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701374,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10701374.spcon)
	e1:SetTarget(c10701374.sptg)
	e1:SetOperation(c10701374.spop)
	c:RegisterEffect(e1) 
	--imit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetCountLimit(c10701374.con)
	e2:SetTarget(c10701374.splimit)
	c:RegisterEffect(e2) 
	--destroy
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(c10701374.descon)
	e10:SetTarget(c10701374.destg)
	e10:SetOperation(c10701374.desop)
	c:RegisterEffect(e10)
end
function c10701374.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c10701374.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701374.cfilter,1,nil,1-tp)
end
function c10701374.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701374.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		c:RegisterFlagEffect(10701374,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	end
	Duel.SpecialSummonComplete()
end
function c10701374.con(e)
	return e:GetHandler():GetFlagEffect(10701374)~=0
end
function c10701374.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	local lim_type=0 
	local ug=Duel.GetMatchingGroup(Card.IsFaceup,sump,LOCATION_MZONE,0,nil)
	if ug:IsExists(Card.IsType,1,nil,TYPE_FUSION) then lim_type=lim_type+SUMMON_TYPE_FUSION end
	if ug:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then lim_type=lim_type+SUMMON_TYPE_SYNCHRO end
	if ug:IsExists(Card.IsType,1,nil,TYPE_XYZ) then lim_type=lim_type+SUMMON_TYPE_XYZ end
	if ug:IsExists(Card.IsType,1,nil,TYPE_LINK) then lim_type=lim_type+SUMMON_TYPE_LINK end
	return bit.band(sumtype & lim_type,SUMMON_TYPE_FUSION+SUMMON_TYPE_SYNCHRO+SUMMON_TYPE_XYZ+SUMMON_TYPE_LINK)~=0
end
function c10701374.cfilter2(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c10701374.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10701374.cfilter2,1,nil,tp)
end
function c10701374.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c10701374.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end