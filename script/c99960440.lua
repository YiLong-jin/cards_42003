--日水符「氢化日珥」
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
	e7:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e7)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCost(c99960440.spcost)
	e1:SetTarget(c99960440.target)
	e1:SetOperation(c99960440.operation)
	c:RegisterEffect(e1)
	
			--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.gcon)
	e2:SetOperation(s.gop)
	c:RegisterEffect(e2)
	
end
c99960440.Savior_Paqi = true

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(id) and re:GetHandlerPlayer()=tp
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
end




function c99960440.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960290)
	local fb=Duel.GetFlagEffect(tp,99960300)
	local count=fa-2
	if chk==0 then return fa>1 and fb>1 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960290)
	Duel.ResetFlagEffect(tp,99960300)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960290,0,0,0)
		Duel.RegisterFlagEffect(tp,99960300,0,0,0)
		end
end
function c99960440.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c99960440.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99960440.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
		and Duel.IsExistingTarget(c99960440.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	local g=Duel.SelectTarget(tp,c99960440.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c99960440.spfilter(c,e,tp,tap,tc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY) and c:GetOwner()==tap and c~=tc
end
function c99960440.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
			local tap=tc:GetOwner()
			local g=Duel.SelectMatchingCard(tap,c99960440.spfilter,tap,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tap,tc)
			Duel.SpecialSummon(g,0,tap,tap,false,false,POS_FACEUP)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
