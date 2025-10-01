--超可爱执行者伙伴
function c65846908.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65846908,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c65846908.thtg)
	e1:SetOperation(c65846908.thop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846908,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65846908)
	e2:SetTarget(c65846908.eqtg)
	e2:SetOperation(c65846908.eqop)
	c:RegisterEffect(e2)
end
c65846908.SetCard_ZJ_CKAZXZ=true
function c65846908.filter(c)
	return c.SetCard_ZJ_CKAZXZ and c:IsType(0x1) and c:IsAbleToHand() and not c:IsCode(65846908)
end
function c65846908.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846908.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,65846908)==0 end
	Duel.RegisterFlagEffect(tp,65846908,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65846908.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65846908.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65846908.cfilter(c,tp)
	return c:IsFaceup() and c.SetCard_ZJ_CKAZXZ
		and Duel.IsExistingMatchingCard(c65846908.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c:GetOriginalAttribute(),tp)
end
function c65846908.eqfilter(c,att,tp)
	return c:IsType(TYPE_MONSTER) and c.SetCard_ZJ_CKAZXZ and c:GetOriginalAttribute()~=att
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c65846908.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65846908.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c65846908.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c65846908.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c65846908.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c65846908.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc:GetOriginalAttribute(),tp)
		local sc=g:GetFirst()
		if not sc then return end
		local res=sc:IsLocation(LOCATION_DECK)
		if not Duel.Equip(tp,sc,tc) then return end
		--equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetValue(c65846908.eqlimit)
		sc:RegisterEffect(e1)
		--atk up
		local e2=Effect.CreateEffect(sc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e2)
	end
end
function c65846908.eqlimit(e,c)
	return c==e:GetLabelObject()
end
