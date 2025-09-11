--灵魂鸟神-稚孔雀
function c10701238.initial_effect(c)
	c:SetSPSummonOnce(10701238)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c10701238.lcheck)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701238,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10701238.stcon)
	e1:SetTarget(c10701238.sttg)
	e1:SetOperation(c10701238.stop)
	c:RegisterEffect(e1)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c10701238.retreg)
	c:RegisterEffect(e3)	 
end
function c10701238.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_SPIRIT) or g:IsExists(Card.IsCode,1,nil,25415053)
end
function c10701238.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10701238.thfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c10701238.stfilter(c)
	return aux.IsTypeInText(c,TYPE_SPIRIT) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c10701238.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10701238.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10701238.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c10701238.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10701238.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		   local sg=Duel.GetMatchingGroup(c10701238.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
		   if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701238,1)) then
			   Duel.BreakEffect()
			   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			   local sc=Duel.SelectMatchingCard(tp,c10701238.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
			   if tc then 
				  Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			   end
		   end
		end
	end
end
function c10701238.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(aux.SpiritReturnConditionForced)
	e1:SetTarget(c10701238.rettg)
	e1:SetOperation(c10701238.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.SpiritReturnConditionOptional)
	c:RegisterEffect(e2)
end
function c10701238.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10701238.thfilter2(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c10701238.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
		 local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10701238.thfilter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		 if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10701238,2)) then
			 Duel.BreakEffect()
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			 local sg=g:Select(tp,1,1,nil)
			 Duel.SendtoHand(sg,nil,REASON_EFFECT)
			 Duel.ConfirmCards(1-tp,sg)
		 end
	end
end