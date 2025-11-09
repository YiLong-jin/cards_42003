--七海八千代-星环
function c9878752.initial_effect(c)
	aux.AddCodeList(c,9877883)

	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(9878752,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,9878752)
	e1:SetCondition(c9878752.spcon)
	e1:SetTarget(c9878752.sptg)
	e1:SetOperation(c9878752.spop)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9878752,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,1878752)
	e2:SetTarget(c9878752.thtg)
	e2:SetOperation(c9878752.thop)
	c:RegisterEffect(e2)

	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(9878752,1))
	e13:SetCategory(CATEGORY_ATKCHANGE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e13:SetCode(EVENT_CUSTOM+9878752)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1,2878752)
	e13:SetCondition(c9878752.atkcon)
	e13:SetTarget(c9878752.atktg)
	e13:SetOperation(c9878752.atkop)
	c:RegisterEffect(e13)
	aux.RegisterMergedDelayedEvent(c,9878752,EVENT_DESTROYED)
	
end
function c9878752.f(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9877883)
end
function c9878752.spcon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(c9878752.f,tp,LOCATION_MZONE,0,nil)
	return #g>0 
end
function c9878752.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9878752.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

function c9878752.thfilter(c)
	return aux.IsCodeListed(c,9877883) and c:IsAbleToGrave()and c:IsFaceup()
end
function c9878752.thfilter1(c)
	return aux.IsCodeListed(c,9877883) and c:IsAbleToHand()
end
function c9878752.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9878752.thfilter,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_REMOVED)
end
function c9878752.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9878752.thfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(9878752,2)) then
		local g1=Duel.SelectMatchingCard(tp,c9878752.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
			Duel.SendtoHand(g1,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
			end 
	end
end


function c9878752.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9878752.atkfilter1,nil,tp)
	if #g==0 then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function c9878752.atkfilter1(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>0
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c9878752.atkfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c9878752.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9878752.atkfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9878752.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9878752.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9878752.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if g:GetCount()>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			g=g:Select(tp,1,1,nil)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(g:GetFirst():GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	e:GetLabelObject():DeleteGroup()
end