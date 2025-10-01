--日月符「皇家钻戒」
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
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCost(c99960450.spcost)
	e1:SetTarget(c99960450.target)
	e1:SetOperation(c99960450.operation)
	c:RegisterEffect(e1)
	
			--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(3,id+1)
	e2:SetCondition(s.gcon)
	e2:SetOperation(s.gop)
	c:RegisterEffect(e2)
	
end
c99960450.Savior_Paqi = true

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(id) and re:GetHandlerPlayer()=tp
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
end




function c99960450.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960290)
	local fb=Duel.GetFlagEffect(tp,99960300)
	local count=fa-4
	if chk==0 then return fa>3 and fb>3 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960290)
	Duel.ResetFlagEffect(tp,99960300)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960290,0,0,0)
		Duel.RegisterFlagEffect(tp,99960300,0,0,0)
		end
end
function c99960450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c99960450.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
