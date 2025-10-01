--木符「翠绿风暴」
local s,id,o=GetID()
function s.initial_effect(c)

	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(aux.FALSE)
	c:RegisterEffect(e8)
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCost(c99960360.spcost)
	e1:SetTarget(c99960360.damtg)
	e1:SetOperation(c99960360.spop)
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
c99960360.Savior_Paqi = true

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(id) and re:GetHandlerPlayer()=tp
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
end




function c99960360.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960310)
	local count=fa-2
	if chk==0 then return fa>1 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960310)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960310,0,0,0)
		end
end
function c99960360.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function c99960360.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
