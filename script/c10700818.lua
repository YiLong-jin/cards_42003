--万圣夜想曲 弗兰肯小姐
function c10700818.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_HAND)
	e0:SetOperation(c10700818.adjustop)
	c:RegisterEffect(e0)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c10700818.target)
	e1:SetOperation(c10700818.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+10700818)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c10700818.target)
	e2:SetOperation(c10700818.operation)
	c:RegisterEffect(e2) 
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(35199656,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,10700820)
	e3:SetTarget(c10700818.sptg)
	e3:SetOperation(c10700818.spop)
	c:RegisterEffect(e3)   
end
function c10700818.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPublic() and c:GetFlagEffect(10700819)==0 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10700818,e,0,0,0,0)
		c:RegisterFlagEffect(10700819,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif not c:IsPublic() and c:GetFlagEffect(10700818)>0 then
		c:ResetFlagEffect(10700819)
	end
end
function c10700818.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700818.handfilter,tp,LOCATION_HAND,0,1,nil)
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10700820,0x51,TYPES_TOKEN_MONSTER,0,0,1,RACE_MACHINE,ATTRIBUTE_LIGHT)) end
end
function c10700818.handfilter(c)
	return not c:IsPublic()
end
function c10700818.operation(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c10700818.handfilter,tp,LOCATION_HAND,0,1,nil) then
		ops[off]=aux.Stringid(10700818,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,10700820,0x51,TYPES_TOKEN_MONSTER,0,0,2,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		ops[off]=aux.Stringid(10700818,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c10700818.handfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10700818,4))
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
		local token=Duel.CreateToken(tp,10700820)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_CHANGE_RACE)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   e1:SetValue(rc)
		   token:RegisterEffect(e1)
		end
	end
end
function c10700818.spfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:IsDestructable()
end
function c10700818.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10700818.spfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c10700818.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c10700818.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10700818.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local spos=0
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then spos=spos+POS_FACEUP_DEFENSE end
	if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,spos)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end