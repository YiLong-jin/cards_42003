--超绝最强究极美少女黑江
function c9878616.initial_effect(c)
	aux.AddCodeList(c,9877873,9877918)
	aux.AddFusionProcCodeFun(c,9877918,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),1,true,true)
	c:EnableReviveLimit()
	
	 aux.EnableChangeCode(c,9877918,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878616,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,9878616)
	e2:SetTarget(c9878616.target)
	e2:SetOperation(c9878616.operation)
	c:RegisterEffect(e2)
	
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9878616,1))
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_QUICK_O) 
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetHintTiming(0,TIMING_END_PHASE)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,9878616)
	e13:SetOperation(c9878616.desop)
	c:RegisterEffect(e13)
end
function c9878616.spfil(c,e,tp)
	return (aux.IsCodeListed(c,9877873) or aux.IsCodeListed(c,9877918)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9878616.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9878616.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9878616.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9878616.operation(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


function c9878616.desop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9878616,2))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c9878616.efilter)
		c:RegisterEffect(e1)
end
function c9878616.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end