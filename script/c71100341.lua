--自动棋子 哨戒单元
local cm,m,o=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--search 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCondition(cm.seqcon)
	e4:SetTarget(cm.seqtg)
	e4:SetOperation(cm.seqop)
	c:RegisterEffect(e4)
end
cm.Automatic_chess_piece=true --「自动棋子」记述
function cm.sfilter(c)
	return not (c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup())
end
function cm.spcon(e,c)
	if c==nil then return true end
	return not Duel.IsExistingMatchingCard(cm.sfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function cm.seqcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c.Automatic_chess_piece and c:IsAbleToHand()
end
function cm.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		local check=c:GetColumnGroup():IsExists(Card.IsControler,1,nil,1-tp)
		local g=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_DECK,0,nil)
		if check and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(41546,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end