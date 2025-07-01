--破魂枪骑 阿瓦克莉
function c88888003.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,88888003)
	e1:SetValue(c88888003.matval)
	c:RegisterEffect(e1)
	--feild link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,88888003)
	e2:SetValue(c88888003.matval2)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,18888003)
	e2:SetCondition(c88888003.spcon)
	e2:SetTarget(c88888003.sptg)
	e2:SetOperation(c88888003.spop)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88888003,1))
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c88888003.atcon)
	e3:SetCost(c88888003.atcost)
	e3:SetOperation(c88888003.atop)
	c:RegisterEffect(e3)
end
function c88888003.mfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c88888003.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(88888003)
end
function c88888003.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x8980) then return false,nil end
	return true,not mg or mg:IsExists(c88888003.mfilter,1,nil) and not mg:IsExists(c88888003.exmfilter,1,nil)
end
function c88888003.exmfilter2(c)
	return c:IsLocation(LOCATION_SZONE) and c:IsCode(88888003) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c88888003.matval2(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x8980) then return false,nil end
	return true,not mg or mg:IsExists(c88888003.mfilter,1,nil) and not mg:IsExists(c88888003.exmfilter2,1,nil)
end
function c88888003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x8980)
end
function c88888003.spfilter(c,e,tp)
	return c:IsSetCard(0x8980) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c88888003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88888003.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c88888003.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c88888003.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c88888003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c88888003.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0,true) and c:IsSetCard(0x8980)
end
function c88888003.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88888003.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
end