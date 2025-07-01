--断罪神 三角魔
function c10701658.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701658,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,10701658)
	e1:SetTarget(c10701658.thtg)
	e1:SetOperation(c10701658.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701658,1))
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10701659)
	e3:SetCondition(c10701658.setcon1)
	e3:SetTarget(c10701658.settg)
	e3:SetOperation(c10701658.setop)
	c:RegisterEffect(e3) 
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c10701658.setcon2)
	c:RegisterEffect(e4) 
end
function c10701658.thfilter(c)
	return (c:IsSetCard(0x7c0) or c:IsCode(24857466)) and not c:IsType(TYPE_COUNTER) and c:IsAbleToHand()
end
function c10701658.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10701658.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10701658.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10701658.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10701658.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_COUNTER)
end
function c10701658.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_COUNTER)
end
function c10701658.rfilter(c)
	return c:IsFaceup() and c:IsReleasableByEffect()
end
function c10701658.setfilter(c)
	return c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function c10701658.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return  chkc~=c and chkc:IsLocation(LOCATION_MZONE) and c10701658.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701658.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) and Duel.IsExistingMatchingCard(c10701658.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c10701658.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,2,0,0)
end
function c10701658.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local sg=Group.FromCards(c,tc)
		if Duel.Release(sg,REASON_EFFECT)~=2 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local gg=Duel.SelectMatchingCard(tp,c10701658.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if gg:GetCount()>0 then
			Duel.SSet(tp,gg:GetFirst())
		end
	end
end