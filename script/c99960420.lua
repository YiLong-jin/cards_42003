--月木符「卫星向日葵」
local s,id,o=GetID()
function s.initial_effect(c)

	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(aux.FALSE)
	c:RegisterEffect(e8)
		--attribute
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_ATTRIBUTE)
	e7:SetRange(0xff)
	e7:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e7)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,99960420)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCost(c99960420.spcost)
	e1:SetTarget(c99960420.target)
	e1:SetOperation(c99960420.operation)
	c:RegisterEffect(e1)
	
			--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,99960421)
	e2:SetCondition(s.gcon)
	e2:SetOperation(s.gop)
	c:RegisterEffect(e2)
	
end
c99960420.Savior_Paqi = true

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(id)
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
end




function c99960420.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960300)
	local fb=Duel.GetFlagEffect(tp,99960310)
	local count=fa-2
	if chk==0 then return fa>1 and fb>1 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960300)
	Duel.ResetFlagEffect(tp,99960310)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960300,0,0,0)
		Duel.RegisterFlagEffect(tp,99960310,0,0,0)
		end
end
function c99960420.pofilter(c)
	return c:IsPosition(POS_DEFENSE)
end
function c99960420.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99960420.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c99960420.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c99960420.filter(c)
	return c.Savior_Paqi and c:IsFaceupEx() and c:IsAbleToHand()
end
function c99960420.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99960420.pofilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	local ogg=Duel.GetOperatedGroup()
	local ct=ogg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c99960420.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end


