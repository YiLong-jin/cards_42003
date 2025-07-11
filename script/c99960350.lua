--水符「湖葬」
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
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCondition(c99960350.condition)
	e1:SetCost(c99960350.spcost)
	e1:SetTarget(c99960350.damtg)
	e1:SetOperation(c99960350.spop)
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
c99960350.Savior_Paqi = true

function s.gcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(id)
end
function s.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
end



function c99960350.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c99960350.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960300)
	local count=fa-2
	if chk==0 then return fa>1 end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960300)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960300,0,0,0)
		end
end
function c99960350.filter2(c)
	return not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet()
end
function c99960350.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
		local g=Duel.GetMatchingGroup(c99960350.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c99960350.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectTarget(tp,c99960350.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
end

function c99960350.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end