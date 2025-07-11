--金木符「元素收获着」
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
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,99960410)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCost(c99960410.spcost)
	e1:SetOperation(c99960410.spop)
	c:RegisterEffect(e1)
	
end
c99960410.Savior_Paqi = true




function c99960410.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960320)
	local fb=Duel.GetFlagEffect(tp,99960310)
	local count=fa-1
	if chk==0 then return fa>0 and fb>0 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960320)
	Duel.ResetFlagEffect(tp,99960310)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960320,0,0,0)
		Duel.RegisterFlagEffect(tp,99960310,0,0,0)
		end
end
function c99960410.spop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(24,0,aux.Stringid(99960290,0))
	Duel.RegisterFlagEffect(tp,99960290,0,0,0)
		Duel.RegisterFlagEffect(tp,99960300,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960300,0))
		Duel.RegisterFlagEffect(tp,99960330,0,0,0)
	Duel.Hint(24,0,aux.Stringid(99960330,0))
end

