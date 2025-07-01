--童谣 王后
function c65846988.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	--e1:SetCountLimit(1,65846988+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c65846988.hspcon)
	e1:SetTarget(c65846988.hsptg)
	e1:SetOperation(c65846988.hspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65846988,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c65846988.thgtg)
	e2:SetOperation(c65846988.thgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c65846988.atkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c65846988.tgtg)
	e4:SetOperation(c65846988.thop)
	c:RegisterEffect(e4)
end
function c65846988.hspfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetBaseAttack()==c:GetBaseDefense() and c:IsLevel(7,8)
end
function c65846988.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function c65846988.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c65846988.hspfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c,REASON_SPSUMMON)
	return rg:CheckSubGroup(c65846988.fselect,2,2,tp)
end
function c65846988.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c65846988.hspfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,c,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,c65846988.fselect,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c65846988.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c65846988.filter(c)
	return c:IsFaceup() and c:IsLevel(7,8)
end
function c65846988.atkop(e,c)
	return Duel.GetMatchingGroupCount(c65846988.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c65846988.thfilter1(c)
	return c:IsSetCard(0x23e2) and c:IsType(0x1) and c:IsAbleToHand()
end
function c65846988.thfilter2(c)
	return c:IsSetCard(0x23e2) and c:IsType(0x6) and c:IsAbleToGrave()
end
function c65846988.thgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65846988.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c65846988.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c65846988.thgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65846988.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then	
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c65846988.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c65846988.thfilter(c)
	return c:IsSetCard(0x23e2) and c:IsType(0x6) and c:IsAbleToHand() and c:IsFaceupEx()
end
function c65846988.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c65846988.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65846988.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c65846988.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c65846988.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end