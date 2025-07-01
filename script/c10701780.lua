--阴云变幻
function c10701780.initial_effect(c)
	--act in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10701780,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(c10701780.con1)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,10701780)
	e2:SetTarget(c10701780.tg2)
	e2:SetOperation(c10701780.op2)
	c:RegisterEffect(e2)
	--ep set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10701780,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,10701781)
	e3:SetCondition(c10701780.setcon)
	e3:SetTarget(c10701780.settg)
	e3:SetOperation(c10701780.setop)
	c:RegisterEffect(e3)
	if c10701780.ge then return end
	c10701780.ge = Effect.CreateEffect(c)
	c10701780.ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	c10701780.ge:SetCode(EVENT_MOVE)
	c10701780.ge:SetOperation(c10701780.gop1)
	Duel.RegisterEffect(c10701780.ge,0)   
end
--e1
function c10701780.con1f(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x7c1)
end
function c10701780.con1(e)
	return Duel.IsExistingMatchingCard(c10701780.con1f,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
--e2
function c10701780.tg2f1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x7c1) and c:IsType(TYPE_MONSTER)
end
function c10701780.tg2f2(c,e)
	return c:IsCanTurnSet() and (not e or c:IsCanBeEffectTarget(e))
end
function c10701780.tg2f3(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x7c1) and c:IsType(TYPE_MONSTER)
end
function c10701780.tg2f4(g)
	return g:GetClassCount(Card.GetLocation) == #g
end
function c10701780.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg = Duel.GetMatchingGroup(c10701780.tg2f2,tp,0,LOCATION_ONFIELD,nil,e)
	local gg = Duel.GetMatchingGroup(c10701780.tg2f3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if chkc then return tg:IsContains(chkc) end
	local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c10701780.tg2f1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2 = e:IsCostChecked() and #tg>0 and #gg>0
	if chk==0 then return b1 or b2 end
	local op = b1 and b2 and Duel.SelectOption(tp, aux.Stringid(10701780,0), aux.Stringid(10701780,1))
	if (op == 0) or (not op and b1) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	elseif (op == 1) or (not op and b2) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_POSITION)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetLabel(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		gg = gg:SelectSubGroup(tp,c10701780.tg2f4,false,1,#tg)
		local ct = Duel.SendtoGrave(gg,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		tg = Duel.SelectTarget(tp,c10701780.tg2f2,tp,0,LOCATION_ONFIELD,ct,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,#tg,1-tp,LOCATION_ONFIELD)
	end
end
function c10701780.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701780.tg2f1),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(ATTRIBUTE_LIGHT)
		sc:RegisterEffect(e1)
	elseif e:GetLabel()==1 then
		local tg = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #tg==0 then return end
		Duel.ChangePosition(tg,POS_FACEDOWN_DEFENSE)
	end
end
--e3
function c10701780.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1,10701780)>=5
end
function c10701780.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c10701780.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	  Duel.SSet(tp,c)
	end
end
--glo
function c10701780.gop1(e,tp,eg,ep,ev,re,r,rp)
	for c in aux.Next(eg) do
		if not c:IsReason(REASON_RULE) and c:IsPreviousLocation(LOCATION_OVERLAY) then
		   Duel.RegisterFlagEffect(tp,10701780,RESET_PHASE+PHASE_END,0,1)
		   Duel.RegisterFlagEffect(1-tp,10701780,RESET_PHASE+PHASE_END,0,1)
		end
	end
end