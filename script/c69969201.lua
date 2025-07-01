--交响曲·月光
function c69969201.initial_effect(c)
 c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c69969201.lcheck)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969201,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,69969201)
	e1:SetCondition(c69969201.thcon)
	e1:SetTarget(c69969201.thtg)
	e1:SetOperation(c69969201.thop)
	c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c69969201.tgcon)
	e2:SetValue(aux.tgoval)
	--c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c69969201.tgcon)
	e3:SetValue(c69969201.bttg)
	--c:RegisterEffect(e3)
 local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(69969201,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,69969196)
	e4:SetTarget(c69969201.atktg)
	e4:SetOperation(c69969201.atkop)
	c:RegisterEffect(e4)
end
--0
function c69969201.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x69b)
end
--1
function c69969201.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c69969201.thfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)
end
function c69969201.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c69969201.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c69969201.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c69969201.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--2
function c69969201.tgcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c69969201.bttg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
--3
function c69969201.ef(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsFaceup()
end
function c69969201.tf(c,lg)
	if c:IsAttack(0) or c:IsFacedown() or not lg:IsContains(c) then return false end
	local exg=c:GetEquipGroup():Filter(c69969201.ef,nil)
	if #exg>0 then
		return #exg>0
	else
		return c:IsAbleToHand() 
	end
end
function c69969201.sp(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c69969201.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c69969201.tf(tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(c69969201.tf,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local tc=Duel.SelectTarget(tp,c69969201.tf,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg):GetFirst()
	if tc:GetEquipGroup():FilterCount(c69969201.ef,nil)>0 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	else
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c69969201.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local exg=tc:GetEquipGroup():Filter(c69969201.ef,nil)
		if #exg>0 then
			local atk=c:GetAttack()
			local spg=exg:Filter(c69969201.sp,nil,e,tp)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			if c:GetAttack()>atk and #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(69969201,2)) then
				local sg=spg:Select(tp,1,1,nil)
				if #sg==0 then return false end
				Duel.HintSelection(sg)
				if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)==0 or not c:IsAbleToHand() then return false end
				Duel.BreakEffect()
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
			end
		else
			local atk=c:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			if c:GetAttack()<atk then return false end
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
