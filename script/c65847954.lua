--镜魔 4
function c65847954.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,4,c65847954.lcheck)
	c:EnableReviveLimit()	
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,65847954)
	e0:SetCondition(c65847954.spcon1)
	e0:SetTarget(c65847954.thtg)
	e0:SetOperation(c65847954.thop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(function(e) return e:GetHandler():GetMutualLinkedGroupCount()>0 end)
	e1:SetValue(1)
	--c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--c:RegisterEffect(e2)
	local e3=e0:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(c65847954.spcon2)
	c:RegisterEffect(e3)
end
function c65847954.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65847950)==0
end
function c65847954.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,65847950)~=0
end
function c65847954.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3e6)
end
function c65847954.spfilter(c,e,tp)
	return c:IsSetCard(0x3e6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function c65847954.thfilter(c)
	return c:IsSetCard(0x3e6) and c:IsAbleToHand()
end
function c65847954.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c65847954.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65847954.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c65847954.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	if e:GetHandler():GetMutualLinkedGroupCount()>0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_GRAVE_SPSUMMON+CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND)
		e:SetLabel(0)
	end
end
function c65847954.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) and e:GetLabel()==1 then
		local a1=Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		local a2=false--Duel.IsExistingMatchingCard(c65847954.setfilter,tp,LOCATION_DECK,0,1,nil)
		local a3=Duel.IsExistingMatchingCard(c65847954.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local sp=0
		local op=aux.SelectFromOptions(tp,
			{a1,aux.Stringid(65847954,0)},
			{a2,aux.Stringid(65847954,1)},
			{a3,aux.Stringid(65847954,2)},
			{true,aux.Stringid(65847954,3)})
		if op==1 then a1=false elseif op==2 then a2=false elseif op==3 then a3=false end
		if e:GetHandler():GetMutualLinkedGroupCount()>0 and op>10 then
			sp=aux.SelectFromOptions(tp,
			{a1,aux.Stringid(65847954,0)},
			{a2,aux.Stringid(65847954,1)},
			{a3,aux.Stringid(65847954,2)},
			{true,aux.Stringid(65847954,3)})
		end
		if op==1 or sp==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
		if op==2 or sp==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local ac=Duel.SelectMatchingCard(tp,c65847954.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			if ac then
				Duel.SSet(tp,ac)
			end
		end
		if op==3 or sp==3 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c65847954.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end