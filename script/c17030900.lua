--真实的魔镜
function c17030900.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17030900+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17030900.target)
	e1:SetOperation(c17030900.activate)
	c:RegisterEffect(e1)
end
function c17030900.copyfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,17030906,0,TYPES_TOKEN_MONSTER,c:GetBaseAttack(),c:GetBaseDefense(),
			c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute())
end
function c17030900.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c17030900.copyfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c17030900.copyfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c17030900.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,17030906,0,TYPES_TOKEN_MONSTER,tc:GetBaseAttack(),tc:GetBaseDefense(),
			tc:GetOriginalLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()) then return end
	local token=Duel.CreateToken(tp,17030906)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(tc:GetBaseAttack())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(tc:GetBaseDefense())
	token:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(tc:GetOriginalLevel())
	token:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetValue(tc:GetOriginalRace())
	token:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e5:SetValue(tc:GetOriginalAttribute())
	token:RegisterEffect(e5)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local ct=tc:GetOriginalLevel()
	if ct>0 and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,c,0x1,1)>0
		and Duel.SelectYesNo(tp,aux.Stringid(17030900,1))then
		while ct>0 do
			local cout=1
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,LOCATION_ONFIELD,0,1,1,c,0x1,1):GetFirst()
			if not tc then break end
			if Duel.SelectYesNo(tp,aux.Stringid(17030900,2)) then cout=ct end
			tc:AddCounter(0x1,cout)
			ct=ct-cout
		end
	end
end

