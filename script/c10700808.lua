--夜想曲的开幕仪式
function c10700808.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10700808+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10700808.target)
	e1:SetOperation(c10700808.activate)
	c:RegisterEffect(e1)	
end
function c10700808.cfilter(c)
	return c:IsPublic()
end
function c10700808.thfilter1(c)
	return c:IsSetCard(0x17c9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10700808.thfilter2(c)
	return c:IsType(TYPE_FLIP) and c:IsAbleToHand()
end
function c10700808.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function c10700808.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c10700808.cfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c10700808.thfilter1,tp,LOCATION_DECK,0,1,nil) 
		or (ct>=2 and Duel.IsExistingMatchingCard(c10700808.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(c10700808.thfilter1,tp,LOCATION_DECK,0,1,nil)) 
		or (ct>=3 and Duel.IsExistingMatchingCard(c10700808.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)) end
end
function c10700808.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c10700808.cfilter,tp,LOCATION_HAND,0,nil)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c10700808.thfilter1,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(10700808,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c10700808.thfilter1,tp,LOCATION_DECK,0,1,nil) and ct>=1 then
		ops[off]=aux.Stringid(10700808,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c10700808.thfilter1,tp,LOCATION_DECK,0,1,nil) and ct>=2 and Duel.IsExistingMatchingCard(c10700808.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) then
		ops[off]=aux.Stringid(10700808,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c10700808.thfilter1,tp,LOCATION_DECK,0,1,nil) and ct>=3 and Duel.IsExistingMatchingCard(c10700808.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(10700808,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10700808.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	elseif opval[op]==2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10700808.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	   local tc=g:GetFirst()
		if g:GetCount()>0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		   Duel.ConfirmCards(1-tp,tc)
		   local e1=Effect.CreateEffect(tc)
		   e1:SetType(EFFECT_TYPE_SINGLE)
		   e1:SetCode(EFFECT_PUBLIC)
		   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		   tc:RegisterEffect(e1)
		   tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(10700808,4))
		end
	elseif opval[op]==3 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g=Duel.SelectMatchingCard(tp,c10700808.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
		   Duel.SendtoHand(g,nil,REASON_EFFECT)
		   Duel.ConfirmCards(1-tp,g)
		end
	elseif opval[op]==4 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c10700808.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	   local tc=g:GetFirst()
	   if not tc then return end
	   local spos=0
	   if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) then spos=spos+POS_FACEUP_DEFENSE end
	   if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
	   if spos~=0 then
		   Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
		   if tc:IsFacedown() then
			   Duel.ConfirmCards(1-tp,tc)
		   end
	   end
	end
end
