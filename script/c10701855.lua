--圣诞夜想曲 奥秘白雪
function c10701855.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_HAND)
	e0:SetOperation(c10701855.adjustop)
	c:RegisterEffect(e0) 
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,10701855) 
	e1:SetTarget(c10701855.tg1)
	e1:SetOperation(c10701855.op1)
	c:RegisterEffect(e1)
	--hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+10701855)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c10701855.sptg)
	e2:SetOperation(c10701855.spop)
	c:RegisterEffect(e2) 
	--xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCountLimit(1,10701856) 
	e3:SetTarget(c10701855.tg2)
	e3:SetOperation(c10701855.op2)
	c:RegisterEffect(e3)
end
function c10701855.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPublic() and c:GetFlagEffect(10701856)==0 then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+10701855,e,0,0,0,0)
		c:RegisterFlagEffect(10701856,RESET_EVENT+RESETS_STANDARD,0,1)
	elseif not c:IsPublic() and c:GetFlagEffect(10701855)>0 then
		c:ResetFlagEffect(10701856)
	end
end
--e1
function c10701855.e1f1(c,e,tp)
	return c:IsSetCard(0x27c9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10701855.e1f2(xc, mc, g)
	return g:CheckSubGroup(c10701855.e1f3, 1, #g, xc, mc)
end
function c10701855.e1f3(g, xc, mc)
	if not g:IsContains(mc) then return false end
	return xc:IsXyzSummonable(g, #g, #g)
end
function c10701855.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10701855.e1f1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10701855.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE) <= 0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10701855.e1f1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) == 0 or not 
		(c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup()) then return end
	local fg = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
	local g = Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	g = g:Filter(c10701855.e1f2, nil, c, fg)
	if #g == 0 or not Duel.SelectYesNo(tp,1165) then return end
	local xc, mg
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		xc = g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,513)
		mg = fg:SelectSubGroup(tp, c10701855.e1f3, true, 1, #g, xc, c)
	until mg
	Duel.BreakEffect()
	Duel.XyzSummon(tp, xc, mg)
end
--e2
function c10701855.e2f(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanTurnSet()
end
function c10701855.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10701855.e2f(chkc) end
	local c = e:GetHandler()
	if chk==0 then return c:IsCanOverlay() and
		Duel.IsExistingTarget(c10701855.e2f,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10701855.e2f,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c10701855.op2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not (c:IsRelateToEffect(e) and aux.NecroValleyFilter()(c) and c:IsCanOverlay()) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Overlay(tc,Group.FromCards(c))
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
end
function c10701855.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10701855.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,c)
	end
end