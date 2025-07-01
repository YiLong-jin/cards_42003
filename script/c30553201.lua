--墟界天使 引导天使
function c30553201.initial_effect(c)
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30553201,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,30553201)
	e1:SetTarget(c30553201.tdtg)
	e1:SetOperation(c30553201.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,30553202)
	e3:SetTarget(c30553201.tg)
	e3:SetOperation(c30553201.op)
	c:RegisterEffect(e3)
end
function c30553201.tgfil(c)
	return c:IsSetCard(0x302) and not c:IsPublic()
end
function c30553201.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30553201.tgfil,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c30553201.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c30553201.tgfil,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.Draw(tp,1,REASON_EFFECT)
		if Duel.SelectYesNo(tp,aux.Stringid(30553201,0)) then
			Duel.BreakEffect()
			Duel.SendtoDeck(g,tp,0,REASON_EFFECT)
		end
	end
end
function c30553201.tdfilter(c)
	return c:IsSetCard(0x302)
end
function c30553201.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30553201.tdfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c30553201.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(30553201,2))
	local g=Duel.SelectMatchingCard(tp,c30553201.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end