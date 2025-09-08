--总是呕吐的感染者 2025/09/03 04:45:31 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	aux.AddCodeList(c,71100771)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetOperation(this.thop)
	c:RegisterEffect(e1)
	--②效果：1回合1次特殊召唤衍生物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(this.spcon1)
	e2:SetTarget(this.sptg)
	e2:SetOperation(this.spop)
	c:RegisterEffect(e2)
	--③效果：因对方从场上离开时特殊召唤2只衍生物
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(this.spcon2)
	e3:SetTarget(this.sptg2)
	e3:SetOperation(this.spop2)
	c:RegisterEffect(e3)
end

--①效果：发动时从卡组·墓地加入手卡
function this.thfilter(c)
	return aux.IsCodeListed(c,71100771) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function this.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(this.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--②效果：主要阶段特殊召唤1只衍生物
function this.sp1f(c)
	return aux.IsCodeListed(c,71100771) and c:IsType(TYPE_MONSTER) and c:IsFaceup()end
function this.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(this.sp1f,tp,LOCATION_MZONE,0,1,nil)
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK) then return end
	local token_flag=Duel.GetFlagEffect(tp,71100771)%3
	local token=Duel.CreateToken(tp,71100771+token_flag)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.RegisterFlagEffect(tp,71100771,0,0,1)
end

--③效果：因对方从场上离开时特殊召唤2只衍生物
function this.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_SZONE)
		and (c:IsReason(REASON_DESTROY) or c:IsReason(REASON_EFFECT)) and c:GetReasonPlayer()==1-tp
end
function this.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function this.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,71100771,0,TYPES_TOKEN,1000,1000,4,RACE_AQUA,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token_flag=Duel.GetFlagEffect(tp,71100771)%3
		local token=Duel.CreateToken(tp,71100771+token_flag)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,71100771,0,0,1)
	end
	Duel.SpecialSummonComplete()
end
