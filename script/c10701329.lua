--科技属 晋升战士
function c10701329.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit() 
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.NonTuner(nil),1,99,c10701329.mf)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.synlimit)
	c:RegisterEffect(e0)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c10701329.rmcon)
	e1:SetTarget(c10701329.rmtg)
	e1:SetOperation(c10701329.rmop)
	c:RegisterEffect(e1)  
	--synchro summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701329,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCondition(c10701329.sccon)
	e3:SetTarget(c10701329.sctg)
	e3:SetOperation(c10701329.scop)
	c:RegisterEffect(e3)  
end
c10701329.material_type=TYPE_SYNCHRO 
function c10701329.mf(g)
	return g:IsExists(c10701329.scfilter,1,nil)
end
function c10701329.scfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x27)
end
function c10701329.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10701329.rmfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c10701329.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return e:GetHandler():IsAbleToRemove() and Duel.IsExistingTarget(c10701329.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c10701329.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c10701329.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc)
	if Duel.NegateActivation(ev) then
	   if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	   if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		  local og=Duel.GetOperatedGroup()
		  local oc=og:GetFirst()
		  while oc do
			  oc:RegisterFlagEffect(10701329,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			  oc=og:GetNext()
		  end
		  og:KeepAlive()
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e1:SetCode(EVENT_PHASE+PHASE_END)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  e1:SetCountLimit(1)
		  e1:SetLabelObject(og)
		  e1:SetOperation(c10701329.retop)
		  Duel.RegisterEffect(e1,tp)
	   end
   end
end
function c10701329.retfilter(c)
	return c:GetFlagEffect(10701329)~=0
end
function c10701329.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c10701329.retfilter,nil)
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
function c10701329.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c10701329.filter(c,e,tp)
	return c:IsSetCard(0x27) and c:IsType(TYPE_SYNCHRO) and not c:IsCode(10701329)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c10701329.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(c10701329.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10701329.scop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10701329.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			tc:CompleteProcedure()
		end
	end
end