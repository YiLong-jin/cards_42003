--风花雪月
function c10700779.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_TOHAND)
	e1:SetCondition(c10700779.condition)
	e1:SetTarget(c10700779.target)
	e1:SetOperation(c10700779.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c10700779.handcon)
	c:RegisterEffect(e2)	
end
function c10700779.cfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c10700779.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10700779.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WIND)
		and Duel.IsExistingMatchingCard(c10700779.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(c10700779.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c10700779.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_EARTH)
end
function c10700779.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
		or (Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanDiscardDeck(1-tp,ct))
		or ((h1<4 and Duel.IsPlayerCanDraw(tp,4-h1)) or (h2<4 and Duel.IsPlayerCanDraw(1-tp,4-h2)) or h1>4 or h2>4)
		or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c10700779.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(10700779,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsPlayerCanDiscardDeck(tp,ct) and Duel.IsPlayerCanDiscardDeck(1-tp,ct) then
		ops[off]=aux.Stringid(10700779,1)
		opval[off-1]=2
		off=off+1
	end
	if (h1<4 and Duel.IsPlayerCanDraw(tp,4-h1)) or (h2<4 and Duel.IsPlayerCanDraw(1-tp,4-h2)) or h1>4 or h2>4 then
		ops[off]=aux.Stringid(10700779,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(10700779,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	elseif opval[op]==2 then
		local d1=Duel.GetDecktopGroup(tp,ct)
		local d2=Duel.GetDecktopGroup(1-tp,ct)
		d1:Merge(d2)
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(d1,REASON_EFFECT)
	elseif opval[op]==3 then
		if h1<4 and Duel.IsPlayerCanDraw(tp,4-h1) then
		   Duel.Draw(tp,4-h1,REASON_EFFECT)
		end
		if h2<4 and Duel.IsPlayerCanDraw(tp,4-h2) then
		   Duel.Draw(1-tp,4-h2,REASON_EFFECT)
		end
		if h1>4 then
		   Duel.DiscardHand(tp,nil,h1-4,h1-4,REASON_EFFECT+REASON_DISCARD)
		end
		if h2>4 then
		   Duel.DiscardHand(1-tp,nil,h2-4,h2-4,REASON_EFFECT+REASON_DISCARD)
		end
	elseif opval[op]==4 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c10700779.handcon(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return h1==h2
end