--火土符「环状熔岩带」
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
	e7:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e7)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,99960390)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_STANDBY_PHASE+TIMING_BATTLE_PHASE+TIMING_MAIN_END)
	e1:SetCost(c99960390.spcost)
	e1:SetOperation(c99960390.spop)
	c:RegisterEffect(e1)
	
end
c99960390.Savior_Paqi = true




function c99960390.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local fa=Duel.GetFlagEffect(tp,99960290)
	local fb=Duel.GetFlagEffect(tp,99960330)
	local count=fa-1
	if chk==0 then return (fa>0) and (fb>0) end
	Duel.ConfirmCards(1-tp,c)
	Duel.ResetFlagEffect(tp,99960290)
	Duel.ResetFlagEffect(tp,99960330)
		for i=1,count do
		Duel.RegisterFlagEffect(tp,99960290,0,0,0)
		Duel.RegisterFlagEffect(tp,99960330,0,0,0)
		end
end
function c99960390.spop(e,tp,eg,ep,ev,re,r,rp)
	-- 为对方玩家创建攻击限制效果
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ATTACK_COST)  -- 使用攻击代价替换效果
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)  -- 影响对方玩家
	e1:SetCost(c99960390.cost)
	e1:SetValue(c99960390.val)
	e1:SetReset(RESET_PHASE+PHASE_END)  -- 回合结束时重置
	Duel.RegisterEffect(e1,tp)
		--accumulate
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_FLAG_EFFECT+99960390)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetReset(RESET_PHASE+PHASE_END)  -- 回合结束时重置
	Duel.RegisterEffect(e3,tp)
end
-- 支付600基本分的代价函数
function c99960390.cost(e,tp)
	local ct=Duel.GetFlagEffect(tp,99960390)
	return Duel.CheckLPCost(tp,ct*600)
end

-- 实际支付操作
function c99960390.val(e,c)
	Duel.PayLPCost(tp,600)
end

