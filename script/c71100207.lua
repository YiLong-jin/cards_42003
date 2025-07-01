--猫车
local m=71100207
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,71100206)
	c:SetUniqueOnField(1,0,m)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.tohcon)
	e1:SetTarget(cm.tohtg)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.tohcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil) 
end
function cm.cfilter(c)
	return (c:IsCode(71100206) or c:IsSetCard(0x7db)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.toh(c,e)
	return c:IsAbleToHand() and (not e or c:IsRelateToEffect(e))
end
function cm.tohtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,m+100)
	local g=eg:Filter(cm.cfilter,nil)
	local b1=#g>0 
	local b2=#g>0 and c:GetFlagEffect(m)==0
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(cm.tohop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,mg,1,0,0)
	elseif opval[op]==2 then
		c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(cm.tohop3)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,mg,1,0,0)
	end
	if Duel.GetFlagEffect(tp,m+100)>=3 then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,nil)
		tg:AddCard(c)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end
function cm.tohop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,m+100)
	local g=eg:Filter(cm.cfilter,nil)
	local tc=g:GetFirst()
	if not tc or ct>=3 then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		tc=sg:GetFirst()
		Duel.HintSelection(sg)
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 
			and tc:IsLocation(LOCATION_HAND)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.sp,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=Duel.SelectMatchingCard(tp,cm.sp,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g3:GetCount()>0 then
				Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.HintSelection(g)
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 
			and tc:IsLocation(LOCATION_HAND)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.sp,tp,LOCATION_HAND,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g3=Duel.SelectMatchingCard(tp,cm.sp,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g3:GetCount()>0 then
				Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function cm.tohop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,m+100)
	local g=eg:Filter(cm.cfilter,nil)
	local tc=g:GetFirst()
	if not tc or ct>=3 then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		tc=sg:GetFirst()
		Duel.HintSelection(sg)
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 
			and tc:IsLocation(LOCATION_HAND)
			and c:IsLocation(LOCATION_SZONE)
			and c:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
			c:RegisterEffect(e1)
		end
	else
		Duel.HintSelection(g)
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 
			and tc:IsLocation(LOCATION_HAND)
			and c:IsLocation(LOCATION_SZONE)
			and c:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(m,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_OPPO_TURN)
			c:RegisterEffect(e1)
		end
	end
end
function cm.sp(c,e,tp)
	return (c:IsSetCard(0x7db) or c:IsCode(71100206)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

