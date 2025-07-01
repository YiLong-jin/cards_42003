--西行寺幽幽子
function c65847923.initial_effect(c)
	aux.AddMaterialCodeList(c,65846921)
	aux.AddCodeList(c,65846916)
	--synchro summon
	aux.AddSynchroProcedure(c,c65847923.tfilter1,aux.NonTuner(c65847923.tfilter2),1)	
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65847923,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65846923)
	e1:SetCondition(c65847923.setcon)
	e1:SetTarget(c65847923.settg)
	e1:SetOperation(c65847923.setop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c65847923.spcon)
	e2:SetTarget(c65847923.sptg)
	e2:SetOperation(c65847923.spop)
	c:RegisterEffect(e2)
end
----{同调素材限制}
function c65847923.tfilter1(c)
	return c:IsCode(65846921)
end
function c65847923.tfilter2(c)
	return aux.IsCodeListed(c,65846916) and c:IsSynchroType(TYPE_SYNCHRO)
end
----{盖卡效果-处理}
function c65847923.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c65847923.setfilter(c)
	return aux.IsCodeListed(c,65846916) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c65847923.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65847923.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c65847923.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c65847923.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(65847923,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		if tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(65847923,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
----{更改效果的效果-处理}
function c65847923.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end
function c65847923.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65846923)==0 end
	Duel.RegisterFlagEffect(tp,65846923,RESET_PHASE+PHASE_END,0,1)
end
function c65847923.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65847923.repop)
end
function c65847923.repop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c65847923.spcon2)
	e1:SetOperation(c65847923.spop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
----{苏生效果-处理}
function c65847923.spfilter(c,e,tp)
	return not c:IsCode(65846923) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(c,65846916) and c:IsFaceupEx()
end
function c65847923.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65847923.spfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,1-tp)
end
function c65847923.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65847923)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(c65847923.spfilter),tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,1,nil,e,1-tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end