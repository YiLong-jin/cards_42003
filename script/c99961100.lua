--全世界的博物馆
local s, id = GetID()
function c99961100.initial_effect(c)
	
	-- 效果①：除外回收+伤害
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c99961100.xiaoyecon1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)
	c:RegisterEffect(e1)
	
	-- 效果②：回合跳跃
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1,EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(s.condition2)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
	
	
		--damage1
	local xiaoye=Effect.CreateEffect(c)
	xiaoye:SetType(EFFECT_TYPE_ACTIVATE)
	xiaoye:SetCategory(CATEGORY_DAMAGE)
	xiaoye:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	xiaoye:SetCode(EVENT_FREE_CHAIN)
	xiaoye:SetTarget(c99961100.xiaoyetg)
	xiaoye:SetCondition(c99961100.xiaoyecon)
	xiaoye:SetOperation(c99961100.xiaoyeop)
	c:RegisterEffect(xiaoye)
end
s.Savior_Xiaoye=true

-- 效果①的filter
function s.filter1(c)
	return c.Savior_Xiaoye and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToRemove()
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil)
		return #g>0
	end
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#g*100)
end

function s.thfilter(c)
	return c:IsCode(99961060) and c:IsAbleToHand()
end

function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=#g
		local dam=ct*100
		if Duel.Damage(1-tp,dam,REASON_EFFECT)~=0 then
			local thct=math.floor(dam/300)
			if thct>0 then
				local hg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil)
				if #hg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local shg=hg:Select(tp,1,math.min(thct,#hg),nil)
					Duel.SendtoHand(shg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,shg)
				end
			end
		end
	end
end

function s.cfilter(c)
	return c:IsFaceup() and c.Savior_Xiaoye
end
function s.cfilter12(c)
	return c:IsFaceup() and c.Savior_Xiaoye
end
-- 效果②的条件
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 or Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetCount()>0 and g:FilterCount(c99961100.cfilter12,nil)==g:GetCount()
end

function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 回合跳跃
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(s.cfilter1))
	e1:SetValue(32841045)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	-- 赋予速攻魔法发动权限	 	local e2=Effect.CreateEffect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,1-tp)
	
	
end

function s.cfilter1(c)
	return c.Savior_Xiaoye
end









function c99961100.xiaoyecon1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)==0
end
function c99961100.xiaoyecon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,99961051)~=0
end
function c99961100.xiaoyetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c99961100.xiaoyeop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
