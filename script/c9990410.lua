--黑洞引擎 企业号-改
function c9990410.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c9990410.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3875465,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9990410)
	e3:SetCondition(c9990410.thcon)
	e3:SetTarget(c9990410.thtg)
	e3:SetOperation(c9990410.thop)
	c:RegisterEffect(e3)
end
function c9990410.tgtg(e,c)
	return c:IsSetCard(0x672)
end
function c9990410.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x672) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsSummonPlayer(tp)
end
function c9990410.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9990410.cfilter,1,nil,tp)
end
function c9990410.thfilter2(c)
	return c:IsSetCard(0x671) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9990410.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9990410.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c9990410.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9990410.thfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end